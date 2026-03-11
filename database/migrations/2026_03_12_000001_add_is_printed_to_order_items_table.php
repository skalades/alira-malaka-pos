<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('order_items', function (Blueprint $blueprint) {
            $blueprint->boolean('is_printed')->default(false)->after('notes');
            $blueprint->index('is_printed');
        });
    }

    public function down(): void
    {
        Schema::table('order_items', function (Blueprint $blueprint) {
            $blueprint->dropIndex(['is_printed']);
            $blueprint->dropColumn('is_printed');
        });
    }
};
