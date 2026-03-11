<script setup lang="ts">
import MainLayout from '@/Layouts/MainLayout.vue';
import { ref } from 'vue';

const menus = [
    { id: 1, name: 'Kopi Susu Gula Aren', price: 18000, category: 'Coffee', image: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=250&h=250&auto=format&fit=crop' },
    { id: 2, name: 'Caramel Macchiato', price: 25000, category: 'Coffee', image: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?q=80&w=250&h=250&auto=format&fit=crop' },
    { id: 3, name: 'Red Velvet Latte', price: 22000, category: 'Non-Coffee', image: 'https://images.unsplash.com/photo-1594631252845-59fc29e3a7dc?q=80&w=250&h=250&auto=format&fit=crop' },
    { id: 4, name: 'Croissant Butter', price: 15000, category: 'Pastry', image: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=250&h=250&auto=format&fit=crop' },
];

const cart = ref([
    { id: 1, name: 'Kopi Susu Gula Aren', price: 18000, quantity: 2 },
    { id: 3, name: 'Red Velvet Latte', price: 22000, quantity: 1 },
]);

const totalPrice = ref(58000);
</script>

<template>
    <MainLayout title="Alira Malaka - Self Order">
        <template #default>
            <div class="mb-8 flex justify-between items-center">
                <h1 class="text-2xl font-black text-gray-900">Pilih Menu</h1>
                <div class="flex gap-2">
                    <button class="px-4 py-2 bg-blue-50 text-blue-700 rounded-lg font-medium">Semua</button>
                    <button class="px-4 py-2 text-gray-500 hover:bg-gray-100 rounded-lg font-medium transition-colors">Coffee</button>
                    <button class="px-4 py-2 text-gray-500 hover:bg-gray-100 rounded-lg font-medium transition-colors">Non-Coffee</button>
                </div>
            </div>

            <div class="grid grid-cols-2 lg:grid-cols-3 gap-6">
                <div v-for="menu in menus" :key="menu.id" class="group bg-white rounded-2xl overflow-hidden shadow-sm border border-gray-100 hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
                    <div class="aspect-square bg-gray-200 relative overflow-hidden">
                        <img :src="menu.image" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" />
                        <div class="absolute top-3 right-3 bg-white/90 backdrop-blur px-3 py-1 rounded-full text-xs font-bold text-blue-600 shadow-sm">
                            {{ menu.category }}
                        </div>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-gray-800 mb-1 truncate">{{ menu.name }}</h3>
                        <p class="text-blue-600 font-black mb-4">Rp {{ menu.price.toLocaleString('id-ID') }}</p>
                        <button class="w-full py-2 bg-gray-900 text-white rounded-xl font-bold active:scale-95 transition-transform">
                            Tambah
                        </button>
                    </div>
                </div>
            </div>
        </template>

        <template #summary>
            <div class="space-y-6">
                <div v-for="item in cart" :key="item.id" class="flex items-center gap-4 group">
                    <div class="h-16 w-16 rounded-xl bg-gray-200 overflow-hidden flex-shrink-0">
                        <!-- Placeholder -->
                    </div>
                    <div class="flex-1 min-w-0">
                        <h4 class="font-bold text-gray-800 truncate">{{ item.name }}</h4>
                        <div class="flex items-center justify-between mt-1">
                            <span class="text-xs text-gray-500 font-medium">Rp {{ item.price.toLocaleString('id-ID') }}</span>
                            <div class="flex items-center gap-3">
                                <button class="h-6 w-6 rounded-full border border-gray-300 flex items-center justify-center text-gray-500 hover:border-gray-900 hover:text-gray-900">-</button>
                                <span class="font-bold text-sm">{{ item.quantity }}</span>
                                <button class="h-6 w-6 rounded-full bg-gray-900 text-white flex items-center justify-center">+</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </template>

        <template #footer>
            <div class="space-y-4">
                <div class="flex items-center justify-between pb-4 border-b border-dashed border-gray-200">
                    <span class="text-gray-500 font-medium">Subtotal</span>
                    <span class="font-bold text-gray-800">Rp 58.000</span>
                </div>
                <div class="flex items-center justify-between mb-4">
                    <span class="text-lg font-normal text-gray-500">Total Pembayaran</span>
                    <span class="text-2xl font-black text-blue-600">Rp 58.000</span>
                </div>
                <button class="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-2xl font-black text-lg shadow-lg shadow-blue-200 active:scale-[0.98] transition-all">
                    Lanjut ke Pembayaran
                </button>
            </div>
        </template>
    </MainLayout>
</template>
