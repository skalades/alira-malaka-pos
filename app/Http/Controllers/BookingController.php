<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use App\Models\Reservation;
use App\Models\Table;
use Illuminate\Http\Request;
use Inertia\Inertia;

class BookingController extends Controller
{
    public function index()
    {
        return Inertia::render('Public/Booking', [
            'tables' => Table::where('status', 'available')->get(),
            'categories' => \App\Models\Category::all(),
            'menus' => \App\Models\Menu::with('variants')->where('is_available', true)->get(),
            'bankSettings' => [
                'bank_name' => \App\Models\Setting::get('bank_name', ''),
                'bank_account_number' => \App\Models\Setting::get('bank_account_number', ''),
                'bank_account_name' => \App\Models\Setting::get('bank_account_name', ''),
                'min_dp' => \App\Models\Setting::get('reservation_min_dp', '0'),
            ],
            'taxSettings' => [
                'enabled' => \App\Models\Setting::get('tax_enabled', '0') === '1',
                'percentage' => (float)\App\Models\Setting::get('tax_percentage', '10'),
            ],
            'serviceChargeSettings' => [
                'enabled' => \App\Models\Setting::get('service_charge_enabled', '0') === '1',
                'percentage' => (float)\App\Models\Setting::get('service_charge_percentage', '5'),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'table_id' => 'required|exists:tables,id',
            'reservation_time' => 'required|date|after:now',
            'num_people' => 'required|integer|min:1',
            'notes' => 'nullable|string',
            'transfer_proof' => 'nullable|image|max:2048',
            'items' => 'nullable|array',
            'items.*.id' => 'required|exists:menus,id',
            'items.*.variant_id' => 'nullable|exists:menu_variants,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.notes' => 'nullable|string',
        ]);

        $reservation = \DB::transaction(function () use ($request, $validated) {
            // Find or create customer
            $customer = Customer::firstOrCreate(
                ['phone' => $validated['phone']],
                ['name' => $validated['name']]
            );

            $proofPath = null;
            if ($request->hasFile('transfer_proof')) {
                $proofPath = $request->file('transfer_proof')->store('proofs', 'public');
            }

            // Create reservation
            $reservation = Reservation::create([
                'customer_id' => $customer->id,
                'table_id' => $validated['table_id'],
                'reservation_time' => $validated['reservation_time'],
                'num_people' => $validated['num_people'],
                'notes' => $validated['notes'],
                'status' => 'pending',
                'transfer_proof' => $proofPath ? '/storage/' . $proofPath : null,
                'dp_amount' => \App\Models\Setting::get('reservation_min_dp', '0'),
            ]);

            // If items are pre-ordered, create an order
            if (!empty($validated['items'])) {
                $order = \App\Models\Order::create([
                    'customer_id' => $customer->id,
                    'table_id' => $validated['table_id'],
                    'user_id' => null, // Public booking
                    'order_number' => 'ORD-' . strtoupper(uniqid()),
                    'total_price' => 0, // Will be updated below
                    'status' => 'pending',
                    'type' => 'dine_in',
                    'reservation_id' => $reservation->id,
                    'dp_amount' => $reservation->dp_amount,
                ]);

                $total = 0;
                foreach ($validated['items'] as $item) {
                    $menu = \App\Models\Menu::find($item['id']);
                    $price = $menu->price;
                    
                    if (!empty($item['variant_id'])) {
                        $variant = \App\Models\MenuVariant::find($item['variant_id']);
                        if ($variant) {
                            $price = $variant->price;
                        }
                    }

                    $order->orderItems()->create([
                        'menu_id' => $menu->id,
                        'variant_id' => $item['variant_id'] ?? null,
                        'quantity' => $item['quantity'],
                        'notes' => $item['notes'] ?? '',
                        'price_at_time' => $price,
                    ]);
                    $total += ($price * $item['quantity']);
                }

                $order->update(['total_price' => $total]);
            }

            return $reservation;
        });

        return back()->with([
            'success' => 'Permintaan reservasi Anda telah terkirim. Admin akan mengkonfirmasi statusnya.',
            'reservation' => $reservation->load('table', 'customer')
        ]);
    }

    public function downloadReceipt(Reservation $reservation)
    {
        // For security, maybe check if it belongs to the current session or similar, 
        // but for now simple ID access is fine since it's meant for public download immediately after booking.
        
        $shopName = \App\Models\Setting::get('shop_name', 'ALIRA MALAKA');
        $shopAddress = \App\Models\Setting::get('shop_address', '');
        $shopFooter = \App\Models\Setting::get('shop_footer', 'Terima Kasih!');

        $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('reports.reservation_receipt', [
            'reservation' => $reservation->load('table', 'customer', 'orders.orderItems.menu', 'orders.orderItems.variant'),
            'shopName' => $shopName,
            'shopAddress' => $shopAddress,
            'shopFooter' => $shopFooter,
            'taxEnabled' => \App\Models\Setting::get('tax_enabled', '0') === '1',
            'taxPercentage' => (float)\App\Models\Setting::get('tax_percentage', '10'),
            'serviceChargeEnabled' => \App\Models\Setting::get('service_charge_enabled', '0') === '1',
            'serviceChargePercentage' => (float)\App\Models\Setting::get('service_charge_percentage', '5'),
        ]);

        return $pdf->download("Struk_Reservasi_{$reservation->id}.pdf");
    }
}
