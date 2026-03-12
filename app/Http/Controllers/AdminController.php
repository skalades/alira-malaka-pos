<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Menu;
use App\Models\Order;
use App\Models\Table;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

use App\Models\Setting;
use Illuminate\Support\Str;

class AdminController extends Controller
{
    public function dashboard()
    {
        $stats = [
            'totalSales' => \App\Models\Transaction::sum(\DB::raw('amount_paid - change_amount')) ?? 0,
            'orderCount' => Order::whereIn('status', ['paid', 'completed'])->count(),
            'menuCount' => Menu::count(),
            'occupiedTables' => Table::where('status', 'occupied')->count(),
        ];

        // Real sales data for the last 7 days
        $salesData = \App\Models\Transaction::select(
            \DB::raw('DATE(transaction_time) as date'),
            \DB::raw('SUM(amount_paid - change_amount) as total')
        )
            ->where('transaction_time', '>=', now()->subDays(6)->startOfDay())
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->map(function ($item) {
                return [
                    'date' => \Carbon\Carbon::parse($item->date)->translatedFormat('D'),
                    'total' => (int) $item->total
                ];
            });

        // Top 5 Selling Menus
        $topMenus = \App\Models\OrderItem::select('menu_id', 
                \DB::raw('SUM(quantity) as total_qty'),
                \DB::raw('SUM(quantity * price_at_time) as total_revenue')
            )
            ->with('menu')
            ->join('orders', 'order_items.order_id', '=', 'orders.id')
            ->whereIn('orders.status', ['paid', 'completed'])
            ->groupBy('menu_id')
            ->orderByDesc('total_qty')
            ->limit(5)
            ->get()
            ->map(function ($item) {
                return [
                    'name' => $item->menu->name ?? 'Unknown',
                    'quantity' => (int) $item->total_qty,
                    'revenue' => (int) $item->total_revenue
                ];
            });

        // Sales by Category
        $categorySales = Category::withCount(['menus as total_qty' => function ($query) {
            $query->join('order_items', 'menus.id', '=', 'order_items.menu_id')
                ->join('orders', 'order_items.order_id', '=', 'orders.id')
                ->whereIn('orders.status', ['paid', 'completed']);
        }])
            ->get()
            ->map(function ($cat) {
                return [
                    'name' => $cat->name,
                    'value' => (int) $cat->total_qty
                ];
            })->filter(fn($item) => $item['value'] > 0)->values();

        return Inertia::render('Admin/Dashboard', [
            'stats' => $stats,
            'salesData' => $salesData,
            'topMenus' => $topMenus,
            'categorySales' => $categorySales
        ]);
    }

    public function menus()
    {
        return Inertia::render('Admin/Menus', [
            'categories' => Category::all(),
            'menus' => Menu::with('category')->get(),
            'tables' => Table::all()
        ]);
    }

    // Category CRUD
    public function storeCategory(Request $request)
    {
        $request->validate(['name' => 'required|string|max:255']);
        Category::create([
            'name' => $request->name,
            'slug' => Str::slug($request->name),
            'image' => '/images/categories/default.jpg' // Placeholder
        ]);
        return back()->with('success', 'Kategori berhasil ditambahkan.');
    }

    public function updateCategory(Request $request, Category $category)
    {
        $request->validate(['name' => 'required|string|max:255']);
        $category->update([
            'name' => $request->name,
            'slug' => Str::slug($request->name)
        ]);
        return back()->with('success', 'Kategori berhasil diperbarui.');
    }

    public function deleteCategory(Category $category)
    {
        $category->delete();
        return back()->with('success', 'Kategori berhasil dihapus.');
    }

    // Menu CRUD
    public function storeMenu(Request $request)
    {
        $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'stock' => 'required|integer',
            'description' => 'nullable|string',
            'image_file' => 'nullable|image|max:2048'
        ]);

        $imagePath = '/images/menus/default.jpg';
        if ($request->hasFile('image_file')) {
            $path = $request->file('image_file')->store('menus', 'public');
            $imagePath = '/storage/' . $path;
        }

        Menu::create([
            'category_id' => $request->category_id,
            'name' => $request->name,
            'price' => $request->price,
            'stock' => $request->stock,
            'description' => $request->description,
            'image' => $imagePath,
            'is_available' => true
        ]);

        return back()->with('success', 'Menu berhasil ditambahkan.');
    }

    public function updateMenu(Request $request, Menu $menu)
    {
        $request->validate([
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'price' => 'required|numeric',
            'stock' => 'required|integer',
            'description' => 'nullable|string',
            'image_file' => 'nullable|image|max:2048'
        ]);

        $data = $request->only(['category_id', 'name', 'price', 'stock', 'description']);
        
        if ($request->hasFile('image_file')) {
            $path = $request->file('image_file')->store('menus', 'public');
            $data['image'] = '/storage/' . $path;
        }

        $menu->update($data);

        return back()->with('success', 'Menu berhasil diperbarui.');
    }

    public function deleteMenu(Menu $menu)
    {
        $menu->delete();
        return back()->with('success', 'Menu berhasil dihapus.');
    }

    public function generateQR(Table $table)
    {
        $table->update([
            'qr_code_token' => bin2hex(random_bytes(10))
        ]);

        return back()->with('success', 'QR Code Meja ' . $table->table_number . ' telah diperbarui.');
    }

    public function settings()
    {
        return Inertia::render('Admin/Settings', [
            'settings' => [
                'tax_enabled' => Setting::get('tax_enabled', '0'),
                'tax_percentage' => Setting::get('tax_percentage', '10'),
                'shop_name' => Setting::get('shop_name', 'ALIRA MALAKA'),
                'shop_address' => Setting::get('shop_address', ''),
                'shop_footer' => Setting::get('shop_footer', 'Terima Kasih!'),
                'loyalty_points_per_10k' => Setting::get('loyalty_points_per_10k', '1'),
                'loyalty_point_value' => Setting::get('loyalty_point_value', '100'),
                'bank_name' => Setting::get('bank_name', ''),
                'bank_account_number' => Setting::get('bank_account_number', ''),
                'bank_account_name' => Setting::get('bank_account_name', ''),
                'reservation_min_dp' => Setting::get('reservation_min_dp', '0'),
                'service_charge_enabled' => Setting::get('service_charge_enabled', '0'),
                'service_charge_percentage' => Setting::get('service_charge_percentage', '5'),
            ]
        ]);
    }

    public function updateSettings(Request $request)
    {
        $request->validate([
            'tax_enabled' => 'required|in:0,1',
            'tax_percentage' => 'required|numeric|min:0|max:100',
            'shop_name' => 'required|string|max:255',
            'shop_address' => 'nullable|string|max:500',
            'shop_footer' => 'nullable|string|max:255',
            'loyalty_points_per_10k' => 'required|numeric|min:0',
            'loyalty_point_value' => 'required|numeric|min:0',
            'bank_name' => 'nullable|string|max:255',
            'bank_account_number' => 'nullable|string|max:255',
            'bank_account_name' => 'nullable|string|max:255',
            'reservation_min_dp' => 'required|numeric|min:0',
            'service_charge_enabled' => 'required|in:0,1',
            'service_charge_percentage' => 'required|numeric|min:0|max:100',
        ]);

        Setting::set('tax_enabled', $request->tax_enabled);
        Setting::set('tax_percentage', $request->tax_percentage);
        Setting::set('shop_name', $request->shop_name);
        Setting::set('shop_address', $request->shop_address);
        Setting::set('shop_footer', $request->shop_footer);
        Setting::set('loyalty_points_per_10k', $request->loyalty_points_per_10k);
        Setting::set('loyalty_point_value', $request->loyalty_point_value);
        Setting::set('bank_name', $request->bank_name ?? '');
        Setting::set('bank_account_number', $request->bank_account_number ?? '');
        Setting::set('bank_account_name', $request->bank_account_name ?? '');
        Setting::set('reservation_min_dp', $request->reservation_min_dp);
        Setting::set('service_charge_enabled', $request->service_charge_enabled);
        Setting::set('service_charge_percentage', $request->service_charge_percentage);

        return back()->with('success', 'Pengaturan berhasil diperbarui.');
    }

    public function reports(Request $request)
    {
        $startDate = $request->input('start_date', now()->startOfMonth()->toDateString());
        $endDate = $request->input('end_date', now()->toDateString());

        $transactions = \App\Models\Transaction::with('order.orderItems.menu')
            ->whereBetween('transaction_time', [$startDate . ' 00:00:00', $endDate . ' 23:59:59'])
            ->get();

        $itemizedSales = [];
        $paymentBreakdown = [
            'cash' => 0,
            'qris' => 0,
            'transfer' => 0
        ];
        $totalRevenue = 0;
        $orderCount = $transactions->count();

        foreach ($transactions as $transaction) {
            $revenue = $transaction->amount_paid - $transaction->change_amount;
            $totalRevenue += $revenue;
            
            $method = strtolower($transaction->payment_method);
            if (isset($paymentBreakdown[$method])) {
                $paymentBreakdown[$method] += $revenue;
            } else {
                $paymentBreakdown['other'] = ($paymentBreakdown['other'] ?? 0) + $revenue;
            }

            foreach ($transaction->order->orderItems as $item) {
                $menuId = $item->menu_id;
                if (!isset($itemizedSales[$menuId])) {
                    $itemizedSales[$menuId] = [
                        'name' => $item->menu->name,
                        'stock' => $item->menu->stock,
                        'quantity' => 0,
                        'revenue' => 0
                    ];
                }
                $itemizedSales[$menuId]['quantity'] += $item->quantity;
                $itemizedSales[$menuId]['revenue'] += $item->price_at_time * $item->quantity;
            }
        }

        // Daily chart data
        $dailyData = \App\Models\Transaction::select(
            \DB::raw('DATE(transaction_time) as date'),
            \DB::raw('SUM(amount_paid - change_amount) as total')
        )
            ->whereBetween('transaction_time', [$startDate . ' 00:00:00', $endDate . ' 23:59:59'])
            ->groupBy('date')
            ->orderBy('date')
            ->get();

        $shiftStats = \App\Models\Shift::whereBetween('opened_at', [$startDate . ' 00:00:00', $endDate . ' 23:59:59'])
            ->select(
                \DB::raw('SUM(opening_cash) as total_opening'),
                \DB::raw('SUM(closing_cash) as total_closing')
            )
            ->first();

        return Inertia::render('Admin/Reports', [
            'itemizedSales' => array_values($itemizedSales),
            'totalRevenue' => $totalRevenue,
            'orderCount' => $orderCount,
            'chartData' => $dailyData,
            'paymentBreakdown' => $paymentBreakdown,
            'shiftStats' => [
                'total_opening' => $shiftStats->total_opening ?? 0,
                'total_closing' => $shiftStats->total_closing ?? 0,
            ],
            'filters' => [
                'start_date' => $startDate,
                'end_date' => $endDate
            ]
        ]);
    }

    public function exportPdf(Request $request)
    {
        $startDate = $request->input('start_date', now()->startOfMonth()->toDateString());
        $endDate = $request->input('end_date', now()->toDateString());

        $transactions = \App\Models\Transaction::with('order.orderItems.menu')
            ->whereBetween('transaction_time', [$startDate . ' 00:00:00', $endDate . ' 23:59:59'])
            ->get();

        $itemizedSales = [];
        $paymentBreakdown = [
            'cash' => 0,
            'qris' => 0,
            'transfer' => 0
        ];
        $totalRevenue = 0;

        foreach ($transactions as $transaction) {
            $revenue = $transaction->amount_paid - $transaction->change_amount;
            $totalRevenue += $revenue;

            $method = strtolower($transaction->payment_method);
            if (isset($paymentBreakdown[$method])) {
                $paymentBreakdown[$method] += $revenue;
            } else {
                $paymentBreakdown['other'] = ($paymentBreakdown['other'] ?? 0) + $revenue;
            }

            foreach ($transaction->order->orderItems as $item) {
                $menuId = $item->menu_id;
                if (!isset($itemizedSales[$menuId])) {
                    $itemizedSales[$menuId] = [
                        'name' => $item->menu->name,
                        'stock' => $item->menu->stock,
                        'quantity' => 0,
                        'revenue' => 0
                    ];
                }
                $itemizedSales[$menuId]['quantity'] += $item->quantity;
                $itemizedSales[$menuId]['revenue'] += $item->price_at_time * $item->quantity;
            }
        }

        $shiftStats = \App\Models\Shift::whereBetween('opened_at', [$startDate . ' 00:00:00', $endDate . ' 23:59:59'])
            ->select(
                \DB::raw('SUM(opening_cash) as total_opening'),
                \DB::raw('SUM(closing_cash) as total_closing')
            )
            ->first();

        $shopName = Setting::get('shop_name', 'ALIRA MALAKA');

        $pdf = \Barryvdh\DomPDF\Facade\Pdf::loadView('reports.sales', [
            'itemizedSales' => array_values($itemizedSales),
            'paymentBreakdown' => $paymentBreakdown,
            'totalRevenue' => $totalRevenue,
            'totalOpening' => $shiftStats->total_opening ?? 0,
            'totalClosing' => $shiftStats->total_closing ?? 0,
            'startDate' => $startDate,
            'endDate' => $endDate,
            'shopName' => $shopName
        ]);

        return $pdf->download("Laporan_Penjualan_{$startDate}_{$endDate}.pdf");
    }

    public function transactions(Request $request)
    {
        $query = \App\Models\Transaction::with(['order.orderItems.menu', 'order.table', 'shift.user'])
            ->orderBy('transaction_time', 'desc');

        if ($request->filled('start_date') && $request->filled('end_date')) {
            $query->whereBetween('transaction_time', [
                $request->start_date . ' 00:00:00',
                $request->end_date . ' 23:59:59'
            ]);
        }

        if ($request->filled('payment_method')) {
            $query->where('payment_method', $request->payment_method);
        }

        return Inertia::render('Admin/Transactions', [
            'transactions' => $query->paginate(15)->withQueryString(),
            'filters' => $request->only(['start_date', 'end_date', 'payment_method'])
        ]);
    }

    public function deleteTransaction(\App\Models\Transaction $transaction)
    {
        \DB::transaction(function () use ($transaction) {
            // Restore stock before deleting associated order and its items
            if ($transaction->order) {
                foreach ($transaction->order->orderItems as $item) {
                    if ($item->menu) {
                        $item->menu->increment('stock', $item->quantity);
                    }
                }
                $transaction->order->orderItems()->delete();
                $transaction->order->delete();
            }
            $transaction->delete();
        });

        return back()->with('success', 'Transaksi dan pesanan terkait berhasil dihapus. Stok telah dikembalikan.');
    }
}
