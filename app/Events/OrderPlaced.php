<?php

namespace App\Events;

use App\Models\Order;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class OrderPlaced implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $order;

    public function __construct(Order $order)
    {
        $this->order = $order->load(['orderItems.menu.category', 'table', 'user']);
    }

    public function broadcastOn(): array
    {
        return [
            new Channel('orders'),
        ];
    }

    public function broadcastAs()
    {
        return 'order.placed';
    }

    public function broadcastWith(): array
    {
        return [
            'order' => [
                'id' => $this->order->id,
                'table_id' => $this->order->table_id,
                'customer_id' => $this->order->customer_id,
                'order_number' => $this->order->order_number,
                'total_price' => (float)$this->order->total_price,
                'status' => $this->order->status,
                'type' => $this->order->type,
                'table' => $this->order->table ? [
                    'id' => $this->order->table->id,
                    'table_number' => $this->order->table->table_number,
                ] : null,
                'order_items' => $this->order->orderItems->map(fn($item) => [
                    'id' => $item->id,
                    'quantity' => $item->quantity,
                    'price_at_time' => (float)$item->price_at_time,
                    'notes' => $item->notes,
                    'menu' => [
                        'name' => $item->menu->name,
                        'category' => $item->menu->category ? [
                            'name' => $item->menu->category->name,
                        ] : null,
                    ],
                ])->toArray(),
                'user' => $this->order->user ? [
                    'id' => $this->order->user->id,
                    'name' => $this->order->user->name,
                ] : null,
            ]
        ];
    }
}
