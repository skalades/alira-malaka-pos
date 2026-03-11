<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->decimal('discount_amount', 12, 2)->default(0)->after('loyalty_discount');
            $table->string('discount_notes')->nullable()->after('discount_amount');
        });

        Schema::table('transactions', function (Blueprint $table) {
            $table->decimal('discount_amount', 12, 2)->default(0)->after('loyalty_discount');
        });
    }

    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['discount_amount', 'discount_notes']);
        });

        Schema::table('transactions', function (Blueprint $table) {
            $table->dropColumn('discount_amount');
        });
    }
};
