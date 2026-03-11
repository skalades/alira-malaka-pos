<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Menu;
use Illuminate\Http\Request;
use Inertia\Inertia;

class MenuController extends Controller
{
    public function index(Request $request, $table_number)
    {
        $table = \App\Models\Table::where('table_number', $table_number)->firstOrFail();

        // Basic token validation (Skipped in local for easier testing)
        if (config('app.env') !== 'local' && $request->token !== $table->qr_code_token) {
            abort(403, 'Invalid or missing table token.');
        }

        $categories = Category::all();
        $menus = Menu::with('category')
            ->where('is_available', true)
            ->when($request->category, function ($query, $category) {
                return $query->whereHas('category', function ($q) use ($category) {
                    $q->where('slug', $category);
                });
            })
            ->get();

        return Inertia::render('Customer/Menu', [
            'table' => $table,
            'categories' => $categories,
            'menus' => $menus,
            'selectedCategory' => $request->category
        ]);
    }
}
