<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    protected $fillable = [
        'order_id',
        'menu_id',
        'variant_id',
        'quantity',
        'notes',
        'price_at_time',
        'transaction_id',
        'is_printed',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function menu()
    {
        return $this->belongsTo(Menu::class);
    }

    public function variant()
    {
        return $this->belongsTo(MenuVariant::class);
    }

    public function transaction()
    {
        return $this->belongsTo(Transaction::class);
    }
}
