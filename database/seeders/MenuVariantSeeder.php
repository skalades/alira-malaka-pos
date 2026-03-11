<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Menu;
use App\Models\MenuVariant;

class MenuVariantSeeder extends Seeder
{
    public function run()
    {
        // Find some coffee menus to add variants to
        $coffeeMenus = Menu::where('name', 'like', '%Kopi%')
            ->orWhere('name', 'like', '%Espresso%')
            ->orWhere('name', 'like', '%Americano%')
            ->orWhere('name', 'like', '%Latte%')
            ->get();

        foreach ($coffeeMenus as $menu) {
            // Add Hot variant
            MenuVariant::updateOrCreate(
                ['menu_id' => $menu->id, 'name' => 'Hot'],
                ['price' => $menu->price, 'is_available' => true]
            );

            // Add Ice variant (+ Rp 2.000)
            MenuVariant::updateOrCreate(
                ['menu_id' => $menu->id, 'name' => 'Ice'],
                ['price' => $menu->price + 2000, 'is_available' => true]
            );
        }
    }
}
