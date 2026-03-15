<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'customer_id',
        'table_id',
        'user_id',
        'order_number',
        'total_price',
        'status',
        'type',
        'points_earned',
        'points_redeemed',
        'loyalty_discount',
        'reservation_id',
        'dp_amount',
        'discount_amount',
        'discount_percentage',
        'discount_notes',
    ];

    protected $appends = ['total_paid'];

    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    public function table()
    {
        return $this->belongsTo(Table::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function transactions()
    {
        return $this->hasMany(Transaction::class);
    }

    public function getTotalPaidAttribute()
    {
        return $this->transactions->sum(function($t) {
            return (float)$t->amount_paid - (float)$t->change_amount;
        });
    }

    public function reservation()
    {
        return $this->belongsTo(Reservation::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
