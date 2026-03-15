<?php

namespace App\Http\Controllers;

use App\Events\OrderPlaced;
use App\Models\Menu;
use App\Models\Order;
use App\Models\Table;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'table_id' => 'required_if:type,dine_in|nullable|exists:tables,id',
            'items' => 'required|array|min:1',
            'items.*.id' => 'required|exists:menus,id',
            'items.*.variant_id' => 'nullable|exists:menu_variants,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.notes' => 'nullable|string',
            'type' => 'nullable|in:dine_in,takeaway',
            'reservation_id' => 'nullable|exists:reservations,id',
            'dp_amount' => 'nullable|numeric|min:0',
        ]);

        return DB::transaction(function () use ($request) {
            $table = $request->table_id ? Table::find($request->table_id) : null;

            // Consolidation Logic: Check for active order on the same table
            $order = null;
            if ($request->type === 'dine_in' && $request->table_id) {
                $order = Order::where('table_id', $request->table_id)
                    ->whereNotIn('status', ['completed', 'cancelled'])
                    ->latest()
                    ->first();
            }

            if ($order) {
                // Append to existing order — do NOT touch dp_amount, it is set once from reservation
                $updateData = [];

                // If it was already paid, reset status so cashier knows there's a new bill
                if ($order->status === 'paid') {
                    $updateData['status'] = 'processing';
                }

                if (!empty($updateData)) {
                    $order->update($updateData);
                }
            } else {
                // Create new order
                $order = Order::create([
                    'table_id' => $request->table_id,
                    'user_id' => auth()->id(),
                    'customer_id' => $request->reservation_id ? \App\Models\Reservation::find($request->reservation_id)->customer_id : null,
                    'reservation_id' => $request->reservation_id,
                    'dp_amount' => $request->dp_amount ?? 0,
                    'order_number' => 'ORD-' . strtoupper(bin2hex(random_bytes(4))),
                    'total_price' => 0,
                    'status' => auth()->check() ? 'processing' : 'pending',
                    'type' => $request->type ?? 'dine_in',
                ]);
            }

            $totalPrice = $order->total_price;
            foreach ($request->items as $item) {
                // Use lockForUpdate to prevent race conditions on stock
                $menu = Menu::where('id', $item['id'])->lockForUpdate()->firstOrFail();
                
                // Check if stock is sufficient
                if ($menu->stock < $item['quantity']) {
                    throw \Illuminate\Validation\ValidationException::withMessages([
                        'items' => ["Stok untuk {$menu->name} tidak mencukupi. Sisa stok: {$menu->stock}."]
                    ]);
                }

                $priceAtTime = $menu->price;

                if (!empty($item['variant_id'])) {
                    $variant = \App\Models\MenuVariant::find($item['variant_id']);
                    if ($variant) {
                        $priceAtTime = $variant->price;
                    }
                }

                $subtotal = $priceAtTime * $item['quantity'];
                $totalPrice += $subtotal;

                $order->orderItems()->create([
                    'menu_id' => $menu->id,
                    'variant_id' => $item['variant_id'] ?? null,
                    'quantity' => $item['quantity'],
                    'price_at_time' => $priceAtTime,
                    'notes' => $item['notes'] ?? null,
                    'is_printed' => false,
                ]);

                // Decrement stock
                $menu->decrement('stock', $item['quantity']);
            }

            $order->update(['total_price' => $totalPrice]);
            if ($table) {
                $table->update(['status' => 'occupied']);
            }

            $order->load(['orderItems.menu', 'orderItems.variant', 'table']);

            broadcast(new OrderPlaced($order))->toOthers();

            if ($request->user() && $request->type !== 'dine_in') {
                return back()->with([
                    'success' => 'Pesanan berhasil dibuat!',
                    'new_order' => $order
                ]);
            }

            $message = $order->type === 'dine_in' 
                ? 'Pesanan berhasil dikirim! Silakan ke kasir untuk melakukan konfirmasi agar pesanan dapat segera diproses.'
                : 'Pesanan berhasil dibuat!';

            return back()->with('success', $message);
        });
    }

    public function pay(Request $request, Order $order)
    {
        $shift = \App\Models\Shift::where('user_id', auth()->id())
            ->where('status', 'open')
            ->first();

        if (!$shift) {
            return back()->with('error', 'Silakan buka shift kasir terlebih dahulu sebelum memproses pembayaran.');
        }

        $taxEnabled = \App\Models\Setting::get('tax_enabled', '0') === '1';
        $taxPercentage = (float)\App\Models\Setting::get('tax_percentage', '10');
        $loyaltyPointValue = (float)\App\Models\Setting::get('loyalty_point_value', '100');
        $pointsRedeemed = (int)$request->input('points_redeemed', 0);
        $loyaltyDiscount = $pointsRedeemed * $loyaltyPointValue;

        $serviceChargeEnabled = \App\Models\Setting::get('service_charge_enabled', '0') === '1';
        $serviceChargePercentage = (float)\App\Models\Setting::get('service_charge_percentage', '5');

        $grandTotal = $order->total_price;
        if ($serviceChargeEnabled) {
            $grandTotal += ($order->total_price * $serviceChargePercentage / 100);
        }
        if ($taxEnabled) {
            $grandTotal += ($order->total_price * $taxPercentage / 100);
        }
        
        $manualDiscount = (float)$request->input('discount_amount', 0);
        $discountPercentage = (float)$request->input('discount_percentage', 0);
        
        // Logic Fix: Calculate remaining balance based strictly on unpaid items
        $clearedSubtotal = $order->orderItems()->whereNotNull('transaction_id')->get()->sum(function($item) {
            return $item->price_at_time * $item->quantity;
        });
        
        $unpaidSubtotal = $order->orderItems()->whereNull('transaction_id')->get()->sum(function($item) {
            return $item->price_at_time * $item->quantity;
        });

        $clearedGrandTotal = $clearedSubtotal;
        $unpaidGrandTotal = $unpaidSubtotal;

        if ($serviceChargeEnabled) {
            $clearedGrandTotal += ($clearedSubtotal * $serviceChargePercentage / 100);
            $unpaidGrandTotal += ($unpaidSubtotal * $serviceChargePercentage / 100);
        }
        if ($taxEnabled) {
            $clearedGrandTotal += ($clearedSubtotal * $taxPercentage / 100);
            $unpaidGrandTotal += ($unpaidSubtotal * $taxPercentage / 100);
        }

        $remainingDP = max(0, $order->dp_amount - $clearedGrandTotal);
        
        // Calculate remaining balance BEFORE discount
        $remainingBeforeDiscount = max(0, $unpaidGrandTotal - $remainingDP);
        
        // Discount is calculated ONLY on the remaining balance
        $percentageAmount = ($remainingBeforeDiscount * $discountPercentage) / 100;
        $totalDiscountAmount = $manualDiscount + $percentageAmount;
        
        $finalTotal = max(0, $remainingBeforeDiscount - $loyaltyDiscount - $totalDiscountAmount);

        $request->validate([
            'payment_method' => 'required|in:cash,qris,transfer',
            'amount_paid' => 'required|numeric|min:' . (floor($finalTotal)),
            'change_amount' => 'required|numeric|min:0',
            'customer_id' => 'nullable|exists:customers,id',
            'points_redeemed' => 'nullable|integer|min:0',
            'points_earned' => 'nullable|integer|min:0',
            'discount_amount' => 'nullable|numeric|min:0',
            'discount_percentage' => 'nullable|numeric|min:0',
            'discount_notes' => 'nullable|string',
        ]);

        return DB::transaction(function () use ($request, $order, $shift, $loyaltyDiscount, $finalTotal, $manualDiscount, $discountPercentage, $grandTotal) {
            $transaction = $order->transactions()->create([
                'shift_id' => $shift->id,
                'payment_method' => $request->payment_method,
                'amount_paid' => $request->amount_paid,
                'change_amount' => $request->change_amount,
                'transaction_time' => now(),
                'points_earned' => $request->points_earned ?? 0,
                'points_redeemed' => $request->points_redeemed ?? 0,
                'loyalty_discount' => $loyaltyDiscount,
                'dp_amount' => $order->dp_amount,
                'discount_amount' => $manualDiscount,
                'discount_percentage' => $discountPercentage,
            ]);

            // Link items that haven't been paid for yet to this transaction
            $order->orderItems()->whereNull('transaction_id')->update([
                'transaction_id' => $transaction->id
            ]);

            $order->update([
                'status' => 'paid',
                'customer_id' => $request->customer_id,
                'points_redeemed' => $request->points_redeemed ?? 0,
                'points_earned' => $request->points_earned ?? 0,
                'loyalty_discount' => $loyaltyDiscount,
                'discount_amount' => $manualDiscount,
                'discount_percentage' => $discountPercentage,
                'discount_notes' => $request->discount_notes,
            ]);

            if ($request->customer_id) {
                $customer = \App\Models\Customer::find($request->customer_id);
                if ($customer) {
                    $customer->points = $customer->points - ($request->points_redeemed ?? 0) + ($request->points_earned ?? 0);
                    // Update total spent (Grand Total - Manual Discount)
                    $customer->total_spent += ($grandTotal - $manualDiscount);
                    $customer->save();
                }
            }
            
            broadcast(new \App\Events\OrderStatusUpdated($order))->toOthers();

            return back()->with('success', 'Pembayaran berhasil diproses!');
        });
    }

    public function markAsPrinted(Order $order)
    {
        $order->orderItems()->where('is_printed', false)->update(['is_printed' => true]);
        return back()->with('success', 'Item ditandai sebagai sudah dicetak.');
    }
}
