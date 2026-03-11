<?php

namespace App\Http\Controllers;

use App\Models\Reservation;
use App\Models\Table;
use Illuminate\Http\Request;
use Inertia\Inertia;

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
            'tables' => Table::all()
        ]);
    }

    public function updateStatus(Request $request, Reservation $reservation)
    {
        $validated = $request->validate([
            'status' => 'required|in:pending,confirmed,checked_in,cancelled'
        ]);

        $reservation->update($validated);

        return back()->with('success', 'Status reservasi diperbarui.');
    }

    public function checkIn(Reservation $reservation)
    {
        if ($reservation->status !== 'confirmed') {
            return back()->with('error', 'Hanya reservasi yang sudah dikonfirmasi yang bisa check-in.');
        }

        \DB::transaction(function () use ($reservation) {
            $reservation->update(['status' => 'checked_in']);
            
            // Mark table as occupied
            $reservation->table->update(['status' => 'occupied']);

            // Find linked order and broadcast it so it shows up in cashier dashboard
            $order = $reservation->orders()->where('status', 'pending')->first();
            if ($order) {
                broadcast(new \App\Events\OrderPlaced($order))->toOthers();
            }
        });

        return back()->with('success', 'Pelanggan berhasil check-in. Pesanan pre-order otomatis aktif.');
    }

    public function activeForTable(\App\Models\Table $table)
    {
        $reservation = $table->reservations()
            ->with('customer')
            ->whereDate('reservation_time', today())
            ->whereIn('status', ['confirmed'])
            ->first();

        return response()->json($reservation);
    }
}
