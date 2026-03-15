<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use App\Models\Reservation;
use App\Models\Table;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

class ReservationController extends Controller
{
    public function index(Request $request)
    {
        $query = Reservation::with(['customer', 'table']);

        if ($request->filled('date')) {
            $query->whereDate('reservation_time', $request->date);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        return Inertia::render('Admin/Reservations', [
            'reservations' => $query->latest('reservation_time')->paginate(10)->withQueryString(),
            'filters' => $request->only(['date', 'status']),
            'tables' => Table::all(),
            'settings' => [
                'min_dp' => \App\Models\Setting::get('reservation_min_dp', '0'),
            ]
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'table_id' => 'required|exists:tables,id',
            'reservation_time' => 'required|date|after_or_equal:today',
            'num_people' => 'required|integer|min:1',
            'dp_amount' => 'required|numeric|min:0',
            'notes' => 'nullable|string',
            'items' => 'nullable|array',
            'items.*.menu_id' => 'required|exists:menus,id',
            'items.*.variant_id' => 'nullable|exists:menu_variants,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.notes' => 'nullable|string',
        ]);

        $reservation = DB::transaction(function () use ($validated) {
            $customer = Customer::firstOrCreate(
                ['phone' => $validated['phone']],
                ['name' => $validated['name']]
            );

            $reservation = Reservation::create([
                'customer_id' => $customer->id,
                'table_id' => $validated['table_id'],
                'reservation_time' => $validated['reservation_time'],
                'num_people' => $validated['num_people'],
                'notes' => $validated['notes'],
                'status' => 'confirmed', // Admin manual bookings are confirmed by default
                'dp_amount' => $validated['dp_amount'],
            ]);

            if (!empty($validated['items'])) {
                $totalPrice = 0;
                // Calculate total price accurately
                foreach ($validated['items'] as $item) {
                    $menu = \App\Models\Menu::find($item['menu_id']);
                    $price = $menu->price;
                    if (!empty($item['variant_id'])) {
                        $variant = \App\Models\MenuVariant::find($item['variant_id']);
                        $price = $variant->price;
                    }
                    $totalPrice += $price * $item['quantity'];
                }

                $order = \App\Models\Order::create([
                    'customer_id' => $customer->id,
                    'table_id' => $validated['table_id'],
                    'user_id' => auth()->id(),
                    'order_number' => 'RES-' . strtoupper(uniqid()),
                    'total_price' => $totalPrice,
                    'status' => 'pending',
                    'type' => 'reservation',
                    'reservation_id' => $reservation->id,
                ]);

                foreach ($validated['items'] as $item) {
                    $menu = \App\Models\Menu::find($item['menu_id']);
                    $price = $menu->price;
                    if (!empty($item['variant_id'])) {
                        $variant = \App\Models\MenuVariant::find($item['variant_id']);
                        $price = $variant->price;
                    }
                    
                    \App\Models\OrderItem::create([
                        'order_id' => $order->id,
                        'menu_id' => $item['menu_id'],
                        'variant_id' => $item['variant_id'] ?? null,
                        'quantity' => $item['quantity'],
                        'price_at_time' => $price,
                        'notes' => $item['notes'] ?? null,
                    ]);
                }
            }

            return $reservation;
        });

        return back()->with('success', 'Reservasi berhasil dibuat.');
    }

    public function updateStatus(Request $request, Reservation $reservation)
    {
        $validated = $request->validate([
            'status' => 'required|in:pending,confirmed,checked_in,cancelled,completed'
        ]);

        $reservation->update($validated);

        return back()->with('success', 'Status reservasi diperbarui.');
    }

    public function checkIn(Reservation $reservation)
    {
        if ($reservation->status !== 'confirmed') {
            return back()->with('error', 'Hanya reservasi yang sudah dikonfirmasi yang bisa check-in.');
        }

        DB::transaction(function () use ($reservation) {
            $reservation->update(['status' => 'checked_in']);
            
            // Mark table as occupied
            $reservation->table->update(['status' => 'occupied']);

            // Find linked order and broadcast it so it shows up in cashier dashboard
            $order = $reservation->orders()->where('status', 'pending')->first();
            if ($order) {
                $order->update(['dp_amount' => $reservation->dp_amount]);
                broadcast(new \App\Events\OrderPlaced($order))->toOthers();
            }
        });

        return back()->with('success', 'Pelanggan berhasil check-in. Pesanan pre-order otomatis aktif.');
    }

    public function activeForTable(\App\Models\Table $table)
    {
        $reservation = $table->reservations()
            ->with(['customer', 'orders'])
            ->whereDate('reservation_time', today())
            ->whereIn('status', ['confirmed'])
            ->first();

        return response()->json($reservation);
    }
}
