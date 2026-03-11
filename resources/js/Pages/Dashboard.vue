<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Ringkasan - Alira Malaka" />

    <AuthenticatedLayout>
        <template #header>
            Sistem Ringkasan
        </template>

        <div class="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-8">
            <!-- Action Cards -->
            <Link :href="route('cashier.index')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-blue-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Meja Kasir</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Proses pesanan pelanggan dan cetak struk otomatis.</p>
            </Link>

            <Link :href="route('admin.menus')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-indigo-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Manajer Menu</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Kelola daftar makanan, minuman, dan kategori produk.</p>
            </Link>

            <Link :href="route('admin.dashboard')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-blue-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Analitik Bisnis</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Performa bisnis dan grafik pendapatan real-time.</p>
            </Link>

            <Link :href="route('admin.reports')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-violet-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-violet-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2a4 4 0 00-4-4H5m11 2a4 4 0 00-4-4h-1m1 8v-2a4 4 0 014-4h1m-11 8a4 4 0 01-4-4V5a2 2 0 012-2h14a2 2 0 012 2v8a4 4 0 01-4 4h-1" /></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Laporan Penjualan</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Detail transaksi dan rincian item terjual.</p>
            </Link>

            <Link :href="route('admin.transactions')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-pink-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Riwayat</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Daftar semua transaksi yang telah selesai.</p>
            </Link>

            <Link :href="route('admin.customers.index')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-amber-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Loyalty</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Kelola poin pelanggan dan program loyalty.</p>
            </Link>

            <Link :href="route('admin.reservations.index')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-emerald-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Reservasi</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Pantau pesanan meja dan jadwal reservasi.</p>
            </Link>

            <Link :href="route('admin.settings')" class="bg-white border border-slate-200 rounded-[32px] md:rounded-[40px] p-6 md:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-12 w-12 md:h-14 md:w-14 bg-slate-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-6 h-6 md:w-7 md:h-7 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                </div>
                <h3 class="text-lg md:text-xl font-bold mb-2 text-slate-900 leading-tight">Pengaturan</h3>
                <p class="text-slate-400 text-xs md:text-sm hidden sm:block">Konfigurasi outlet, pajak, dan cetak struk.</p>
            </Link>
        </div>
    </AuthenticatedLayout>
</template>
