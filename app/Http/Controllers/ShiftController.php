<?php

namespace App\Http\Controllers;

use App\Models\Shift;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ShiftController extends Controller
{
    public function start(Request $request)
    {
        $request->validate([
            'opening_cash' => 'required|numeric|min:0',
        ]);

        $activeShift = Shift::where('user_id', Auth::id())
            ->where('status', 'open')
            ->first();

        if ($activeShift) {
            return back()->with('error', 'Anda masih memiliki shift yang terbuka.');
        }

        Shift::create([
            'user_id' => Auth::id(),
            'opening_cash' => $request->opening_cash,
            'status' => 'open',
            'opened_at' => now(),
        ]);

        return back()->with('success', 'Shift berhasil dibuka.');
    }

    public function end(Request $request)
    {
        $request->validate([
            'closing_cash' => 'required|numeric|min:0',
            'notes' => 'nullable|string',
        ]);

        $shift = Shift::where('user_id', Auth::id())
            ->where('status', 'open')
            ->first();

        if (!$shift) {
            return back()->with('error', 'Tidak ada shift aktif yang ditemukan.');
        }

        // Calculate expected cash: Opening + Cash Transactions
        $cashSales = $shift->transactions()
            ->where('payment_method', 'cash')
            ->sum('amount_paid');
        
        // We subtract changes if they were deducted from cash sales? 
        // Actually, amount_paid usually handles the gross received. 
        // Let's check how we record transactions.
        
        $totalChange = $shift->transactions()
            ->where('payment_method', 'cash')
            ->sum('change_amount');

        $expectedCash = $shift->opening_cash + ($cashSales - $totalChange);

        $shift->update([
            'closing_cash' => $request->closing_cash,
            'expected_cash' => $expectedCash,
            'status' => 'closed',
            'closed_at' => now(),
            'notes' => $request->notes,
        ]);

        return back()->with('success', 'Shift berhasil ditutup.');
    }
}
