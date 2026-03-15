<?php

namespace App\Http\Controllers;

use App\Events\OrderStatusUpdated;
use App\Models\Menu;
use App\Models\Order;
use App\Models\Table;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CashierController extends Controller
{
    public function index()
    {
        $tables = Table::all();
        $menus = Menu::with(['category', 'variants'])->where('is_available', true)->get();
        $pendingOrders = Order::with(['table', 'orderItems.menu.category', 'orderItems.variant', 'transactions', 'customer', 'user'])
            ->whereIn('status', ['pending', 'processing', 'ready', 'paid'])
            ->latest()
            ->get();

        $dailyStats = [
            'revenue' => \App\Models\Transaction::whereDate('transaction_time', today())->sum(\DB::raw('amount_paid - change_amount')) ?? 0,
            'orders' => Order::whereDate('created_at', today())->where('status', 'completed')->count(),
        ];

        return Inertia::render('Cashier/Dashboard', [
            'tables' => $tables->map(function($table) {
                $table->has_reservation = $table->reservations()
                    ->whereDate('reservation_time', today())
                    ->where('status', 'confirmed')
                    ->exists();
                return $table;
            }),
            'menus' => $menus,
            'pendingOrders' => $pendingOrders,
            'dailyStats' => $dailyStats,
            'activeShift' => \App\Models\Shift::where('user_id', auth()->id())
                ->where('status', 'open')
                ->first(),
            'taxSettings' => [
                'enabled' => \App\Models\Setting::get('tax_enabled', '0') === '1',
                'percentage' => (float)\App\Models\Setting::get('tax_percentage', '10'),
            ],
            'serviceChargeSettings' => [
                'enabled' => \App\Models\Setting::get('service_charge_enabled', '0') === '1',
                'percentage' => (float)\App\Models\Setting::get('service_charge_percentage', '5'),
            ],
            'loyaltySettings' => [
                'points_per_10k' => (float)\App\Models\Setting::get('loyalty_points_per_10k', '1'),
                'point_value' => (float)\App\Models\Setting::get('loyalty_point_value', '100'),
            ],
            'shopSettings' => [
                'name' => \App\Models\Setting::get('shop_name', 'ALIRA MALAKA'),
                'address' => \App\Models\Setting::get('shop_address', ''),
                'footer' => \App\Models\Setting::get('shop_footer', 'Terima Kasih!'),
            ],
            'reservationSettings' => [
                'min_dp' => \App\Models\Setting::get('reservation_min_dp', '0'),
            ]
        ]);
    }

    public function updateStatus(Request $request, Order $order)
    {
        $request->validate([
            'status' => 'required|in:pending,processing,ready,paid,completed,cancelled'
        ]);

        $oldStatus = $order->status;
        $newStatus = $request->status;

        return \DB::transaction(function () use ($request, $order, $oldStatus, $newStatus) {
            $order->update(['status' => $newStatus]);

            // Restore stock if cancelled (and wasn't already cancelled)
            if ($newStatus === 'cancelled' && $oldStatus !== 'cancelled') {
                foreach ($order->orderItems as $item) {
                    if ($item->menu) {
                        $item->menu->increment('stock', $item->quantity);
                    }
                }
            }
            
            // If transitioning FROM cancelled TO something else (rare but possible), decrement stock
            if ($oldStatus === 'cancelled' && $newStatus !== 'cancelled') {
                foreach ($order->orderItems as $item) {
                    if ($item->menu) {
                        $item->menu->decrement('stock', $item->quantity);
                    }
                }
            }

            if ($order->table && in_array($newStatus, ['completed', 'cancelled'])) {
                $order->table->update(['status' => 'available']);
                
                // If order is linked to a reservation, mark it as completed
                if ($order->reservation_id) {
                    $order->reservation->update(['status' => 'completed']);
                }
            }

            broadcast(new OrderStatusUpdated($order))->toOthers();

            return back()->with('success', 'Status pesanan berhasil diperbarui.');
        });
    }
}
