<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = [
        'order_id',
        'shift_id',
        'payment_method',
        'amount_paid',
        'change_amount',
        'transaction_time',
        'points_earned',
        'points_redeemed',
        'loyalty_discount',
        'dp_amount',
        'discount_amount',
    ];

    public function shift()
    {
        return $this->belongsTo(Shift::class);
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
