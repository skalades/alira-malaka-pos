<?php

namespace Tests\Feature;

use App\Models\Menu;
use App\Models\Order;
use App\Models\Table;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class StockTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $table;
    protected $menu;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create(['role' => 'admin']);
        $this->table = Table::create(['table_number' => '1', 'status' => 'available']);
        $this->menu = Menu::create([
            'category_id' => 1, // Assume category 1 exists or create it
            'name' => 'Test Coffee',
            'price' => 10000,
            'stock' => 10,
            'image' => '/test.jpg',
            'is_available' => true
        ]);
        
        // Create a category since Menu requires it
        \App\Models\Category::create(['id' => 1, 'name' => 'Coffee', 'slug' => 'coffee']);
    }

    public function test_stock_decreases_when_order_is_placed()
    {
        $response = $this->actingAs($this->user)
            ->post(route('order.checkout'), [
                'table_id' => $this->table->id,
                'items' => [
                    ['id' => $this->menu->id, 'quantity' => 2]
                ],
                'type' => 'dine_in'
            ]);

        $response->assertStatus(302);
        $this->assertEquals(8, $this->menu->fresh()->stock);
    }

    public function test_order_fails_if_stock_is_insufficient()
    {
        $response = $this->actingAs($this->user)
            ->post(route('order.checkout'), [
                'table_id' => $this->table->id,
                'items' => [
                    ['id' => $this->menu->id, 'quantity' => 11]
                ],
                'type' => 'dine_in'
            ]);

        $response->assertSessionHasErrors('items');
        $this->assertEquals(10, $this->menu->fresh()->stock);
    }

    public function test_stock_is_restored_when_order_is_cancelled()
    {
        // Place order
        $this->actingAs($this->user)
            ->post(route('order.checkout'), [
                'table_id' => $this->table->id,
                'items' => [
                    ['id' => $this->menu->id, 'quantity' => 2]
                ],
                'type' => 'dine_in'
            ]);

        $order = Order::first();
        $this->assertEquals(8, $this->menu->fresh()->stock);

        // Cancel order
        $this->actingAs($this->user)
            ->patch(route('cashier.order.status', $order->id), [
                'status' => 'cancelled'
            ]);

        $this->assertEquals(10, $this->menu->fresh()->stock);
    }
}
