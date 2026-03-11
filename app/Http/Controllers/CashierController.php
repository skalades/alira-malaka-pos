<?php

namespace App\Http\Controllers;

use App\Events\OrderStatusUpdated;
use App\Models\Menu;
use App\Models\Order;
use App\Models\Table;
use Illuminate\Http\Request;
use Inertia\Inertia;

class CashierController extends Controller
{
    public function index()
    {
        $tables = Table::all();
        $menus = Menu::with(['category', 'variants'])->where('is_available', true)->get();
        $pendingOrders = Order::with(['table', 'orderItems.menu.category', 'orderItems.variant', 'transaction', 'customer', 'user'])
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
            ]
        ]);
    }

    public function updateStatus(Request $request, Order $order)
    {
        $request->validate([
            'status' => 'required|in:pending,processing,ready,paid,completed,cancelled'
        ]);

        $order->update(['status' => $request->status]);

        if ($order->table && in_array($request->status, ['completed', 'cancelled'])) {
            $order->table->update(['status' => 'available']);
        }

        broadcast(new OrderStatusUpdated($order))->toOthers();

        return back()->with('success', 'Status pesanan berhasil diperbarui.');
    }
}
