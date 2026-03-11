<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Menu;
use App\Models\Table;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Clean up existing data to prevent duplicates
        Menu::query()->delete();
        Category::query()->delete();

        // Admin User
        User::updateOrCreate(
            ['email' => 'admin@aliramalaka.com'],
            [
                'name' => 'Admin Alira',
                'password' => bcrypt('password'),
                'role' => 'admin',
            ]
        );

        // Cashier User
        User::updateOrCreate(
            ['email' => 'kasir@aliramalaka.com'],
            [
                'name' => 'Kasir Alira',
                'password' => bcrypt('password'),
                'role' => 'cashier',
            ]
        );

        // Categories
        $categories = [
            'Minuman' => 'https://images.unsplash.com/photo-1544145945-f904253db0ad',
            'Makanan' => 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
            'Cemilan' => 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a'
        ];

        $categoryModels = [];
        foreach ($categories as $name => $image) {
            $categoryModels[$name] = Category::updateOrCreate(
                ['slug' => Str::slug($name)],
                ['name' => $name, 'image' => $image]
            );
        }

        // Minuman
        $minumanItems = [
            ['Kopi Susu Gula Aren', 15000],
            ['Good Day Mocacino', 8000],
            ['Good Day Chococino', 8000],
            ['Good Day Vanila Latte', 8000],
            ['Kapal Api', 7000],
            ['Cappucino', 10000],
            ['Creamy Latte', 10000],
            ['Dancow Coklat', 10000],
            ['Dancow Vanila', 10000],
            ['Milo', 10000],
            ['Energen', 8000],
            ['Teh Tarik', 10000],
            ['Kopi Luwak', 8000],
            ['Indocafe', 7000],
            ['Abc Susu', 7000],
            ['Jus Nanas', 12000],
            ['Jus Buah Naga', 15000],
            ['Jus Alpukat', 15000],
            ['Es Jeruk', 12000],
            ['Sop Buah Creamy', 17000],
            ['Es Teler Creamy', 15000],
            ['Milkshake Coklat', 15000],
            ['Milkshake Strawberry', 15000],
            ['Milkshake Matcha', 15000],
            ['Milkshake Vanilla', 15000],
        ];

        foreach ($minumanItems as $item) {
            Menu::create([
                'category_id' => $categoryModels['Minuman']->id,
                'name' => $item[0],
                'price' => $item[1],
                'image' => 'https://images.unsplash.com/photo-1544145945-f904253db0ad', // Placeholder
                'stock' => 100,
                'is_available' => true
            ]);
        }

        // Makanan
        $makananItems = [
            ['Ayam Bakar Pejantan Kumplit', 29000],
            ['Ayam Goreng Kumplit', 25000],
            ['Ayam Bakar Kumplit', 25000],
            ['Peda Berem Kumplit', 17000],
            ['Ikan Bakar Kumplit', 28000],
            ['Sop Iga', 25000],
            ['Karedok Leunca', 12000],
            ['Lotek / Karedok', 15000],
            ['Tumis Genjer', 12000],
            ['Ceker Mercon', 15000],
            ['Usus Goreng', 5000],
            ['Nasi Merah Ayam Goreng', 25000],
            ['Nasi Cikur Kumplit', 25000],
            ['Paket Ramadhan', 25000],
        ];

        foreach ($makananItems as $item) {
            $description = null;
            if (str_contains($item[0], 'Kumplit')) {
                $description = 'Nasi, Protein, Tahu, Tempe, Lalapan, Sambal';
            }
            if ($item[0] === 'Paket Ramadhan') {
                $description = 'Es lemon tea, ayam goreng, tahu tempe, free takjil, pilihan nasi, pilihan sambal';
            }

            Menu::create([
                'category_id' => $categoryModels['Makanan']->id,
                'name' => $item[0],
                'description' => $description,
                'price' => $item[1],
                'image' => 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', // Placeholder
                'stock' => 50,
                'is_available' => true
            ]);
        }

        // Cemilan
        $cemilanItems = [
            ['Tempe Mendoan', 12000],
            ['Bala-bala', 12000],
            ['Cireng', 12000],
            ['Cireng Isi', 15000],
            ['Pisang Keju', 15000],
            ['Baso Aci Kumplit', 15000],
            ['Potato Cheese', 15000],
            ['Beef Burger', 15000],
            ['Tomyam', 15000],
            ['Omlet Enoki', 15000],
            ['Colenak', 20000],
            ['Kentang Sosis', 20000],
            ['Seblak', 15000],
            ['Basreng', 12000],
            ['Roti Bakar', 15000],
            ['Nugget', 15000],
            ['Risol Matcha', 17000],
            ['Risol Coklat', 17000],
            ['Risol Ubi Ungu', 17000],
            ['Risol Ayam', 17000],
            ['Risol Mayo', 17000],
            ['Donat', 15000],
        ];

        foreach ($cemilanItems as $item) {
            $description = null;
            if (str_contains($item[0], 'Kumplit')) {
                $description = 'Baso aci, tahu, cuankie, pilus cikur, bumbu lengkap';
            }

            Menu::create([
                'category_id' => $categoryModels['Cemilan']->id,
                'name' => $item[0],
                'description' => $description,
                'price' => $item[1],
                'image' => 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', // Placeholder
                'stock' => 50,
                'is_available' => true
            ]);
        }

        // Tables
        Table::where('id', '>', 0)->delete();
        for ($i = 1; $i <= 30; $i++) {
            Table::create([
                'table_number' => $i,
                'qr_code_token' => bin2hex(random_bytes(10)),
                'status' => 'available'
            ]);
        }
    }
}
