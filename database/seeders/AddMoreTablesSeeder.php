<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AddMoreTablesSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $target = 70;
        $existingNumbers = \App\Models\Table::pluck('table_number')->toArray();
        $existingNumbers = array_map('intval', $existingNumbers);
        
        $currentMax = !empty($existingNumbers) ? max($existingNumbers) : 0;

        for ($i = $currentMax + 1; $i <= $target; $i++) {
            \App\Models\Table::create([
                'table_number' => (string)$i,
                'qr_code_token' => bin2hex(random_bytes(10)),
                'status' => 'available',
            ]);
        }
    }
}
