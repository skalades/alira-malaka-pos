<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ShiftController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return redirect()->route('login');
});

Route::get('/demo', function () {
    return Inertia::render('Demo');
});

Route::get('/order/{table_number}', [\App\Http\Controllers\MenuController::class, 'index'])->name('order.index');
Route::post('/order/checkout', [\App\Http\Controllers\OrderController::class, 'store'])->name('order.checkout');

Route::middleware('auth')->group(function () {
    Route::get('/dashboard', function () {
        return Inertia::render('Dashboard');
    })->middleware(['verified', 'role:admin'])->name('dashboard');

    // Cashier & Admin Shared (Non-prefixed)
    Route::middleware('role:cashier,admin')->group(function () {
        Route::get('/cashier', [\App\Http\Controllers\CashierController::class, 'index'])->name('cashier.index');
        Route::patch('/cashier/order/{order}/status', [\App\Http\Controllers\CashierController::class, 'updateStatus'])->name('cashier.order.status');
        Route::post('/cashier/order/{order}/mark-as-printed', [\App\Http\Controllers\OrderController::class, 'markAsPrinted'])->name('cashier.order.mark-printed');
        Route::post('/cashier/order/{order}/pay', [\App\Http\Controllers\OrderController::class, 'pay'])->name('order.pay');

        // Shift Management
        Route::post('/shift/start', [ShiftController::class, 'start'])->name('shift.start');
        Route::post('/shift/end', [ShiftController::class, 'end'])->name('shift.end');

        // Customers (Loyalty) for Cashier
        Route::get('/cashier/customers/search', [\App\Http\Controllers\CustomerController::class, 'search'])->name('cashier.customers.search');
        Route::post('/cashier/customers', [\App\Http\Controllers\CustomerController::class, 'store'])->name('cashier.customers.store');
    });

    // Admin Prefixed Routes
    Route::prefix('admin')->name('admin.')->group(function () {
        // Shared with Cashier (Reservations)
        Route::middleware('role:cashier,admin')->group(function () {
            Route::get('/reservations', [\App\Http\Controllers\ReservationController::class, 'index'])->name('reservations.index');
            Route::post('/reservations', [\App\Http\Controllers\ReservationController::class, 'store'])->name('reservations.store');
            Route::patch('/reservations/{reservation}/status', [\App\Http\Controllers\ReservationController::class, 'updateStatus'])->name('reservations.status');
            Route::get('/reservations/table/{table}', [\App\Http\Controllers\ReservationController::class, 'activeForTable'])->name('reservations.table');
            Route::post('/reservations/{reservation}/check-in', [\App\Http\Controllers\ReservationController::class, 'checkIn'])->name('reservations.checkin');
        });

        // Admin Only
        Route::middleware('role:admin')->group(function () {
            Route::get('/', [\App\Http\Controllers\AdminController::class, 'dashboard'])->name('dashboard');
            Route::get('/menus', [\App\Http\Controllers\AdminController::class, 'menus'])->name('menus');
            
            // Category Management
            Route::post('/categories', [\App\Http\Controllers\AdminController::class, 'storeCategory'])->name('categories.store');
            Route::patch('/categories/{category}', [\App\Http\Controllers\AdminController::class, 'updateCategory'])->name('categories.update');
            Route::delete('/categories/{category}', [\App\Http\Controllers\AdminController::class, 'deleteCategory'])->name('categories.delete');

            // Menu Management
            Route::post('/menus', [\App\Http\Controllers\AdminController::class, 'storeMenu'])->name('menus.store');
            Route::post('/menus/{menu}', [\App\Http\Controllers\AdminController::class, 'updateMenu'])->name('menus.update');
            Route::delete('/menus/{menu}', [\App\Http\Controllers\AdminController::class, 'deleteMenu'])->name('menus.delete');

            Route::post('/table/{table}/qr', [\App\Http\Controllers\AdminController::class, 'generateQR'])->name('table.qr');

            // Settings
            Route::get('/settings', [\App\Http\Controllers\AdminController::class, 'settings'])->name('settings');
            Route::post('/settings', [\App\Http\Controllers\AdminController::class, 'updateSettings'])->name('settings.update');

            // Reports
            Route::get('/reports', [\App\Http\Controllers\AdminController::class, 'reports'])->name('reports');
            Route::get('/reports/export', [\App\Http\Controllers\AdminController::class, 'exportPdf'])->name('reports.export');

            // Transactions History
            Route::get('/transactions', [\App\Http\Controllers\AdminController::class, 'transactions'])->name('transactions');
            Route::delete('/transactions/{transaction}', [\App\Http\Controllers\AdminController::class, 'deleteTransaction'])->name('transactions.delete');

            // Customers (Loyalty) Management
            Route::get('/customers', [\App\Http\Controllers\CustomerController::class, 'index'])->name('customers.index');
            Route::post('/customers', [\App\Http\Controllers\CustomerController::class, 'store'])->name('customers.store');
            Route::patch('/customers/{customer}', [\App\Http\Controllers\CustomerController::class, 'update'])->name('customers.update');
            Route::delete('/customers/{customer}', [\App\Http\Controllers\CustomerController::class, 'delete'])->name('customers.delete');
        });
    });

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

// Public Booking
Route::get('/booking', [\App\Http\Controllers\BookingController::class, 'index'])->name('booking.index');
Route::post('/booking', [\App\Http\Controllers\BookingController::class, 'store'])->name('booking.store');
Route::get('/booking/{reservation}/receipt', [\App\Http\Controllers\BookingController::class, 'downloadReceipt'])->name('booking.receipt');

require __DIR__.'/auth.php';
