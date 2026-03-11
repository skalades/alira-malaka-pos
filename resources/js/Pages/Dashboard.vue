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

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <!-- Welcome Card -->
            <div class="lg:col-span-2 bg-white border border-slate-200 rounded-[40px] p-10 relative overflow-hidden group shadow-sm">
                <div class="absolute -top-24 -right-24 w-64 h-64 bg-blue-600/10 rounded-full blur-3xl group-hover:bg-blue-600/20 transition-all duration-700"></div>
                
                <div class="relative z-10">
                    <h2 class="text-4xl font-black tracking-tighter mb-4 text-slate-900">Selamat Datang,<br>{{ $page.props.auth.user.name }}!</h2>
                    <p class="text-slate-400 text-lg max-w-md leading-relaxed mb-8">
                        Sistem POS Alira Malaka siap digunakan. Kelola pesanan, pantau stok, dan lihat performa bisnis Anda secara real-time.
                    </p>
                    <div class="flex gap-4">
                        <Link :href="route('cashier.index')" class="bg-blue-600 text-white px-8 py-4 rounded-2xl font-black hover:bg-blue-700 transition-all active:scale-95 shadow-lg shadow-blue-600/20">
                            Buka Kasir
                        </Link>
                        <Link :href="route('admin.menus')" class="bg-slate-100 text-slate-600 px-8 py-4 rounded-2xl font-black hover:bg-slate-200 transition-all active:scale-95">
                            Kelola Menu
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Quick Stats Card -->
            <div class="bg-white border border-slate-200 rounded-[40px] p-10 flex flex-col justify-between shadow-sm">
                <div>
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-6">Status Sistem</p>
                    <div class="space-y-6">
                        <div class="flex items-center justify-between">
                            <span class="text-slate-600 font-medium">Status Server</span>
                            <span class="flex items-center gap-2 text-green-600 font-bold">
                                <span class="w-2 h-2 bg-green-600 rounded-full animate-pulse"></span>
                                Online
                            </span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-slate-600 font-medium">Database</span>
                            <span class="text-slate-900 font-bold">Terhubung</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <span class="text-slate-600 font-medium">Status Printer</span>
                            <span class="text-blue-600 font-bold text-xs uppercase tracking-widest">Siap</span>
                        </div>
                    </div>
                </div>
                
                <div class="mt-8 pt-6 border-t border-slate-100">
                    <p class="text-xs text-slate-400 italic">"Operational excellence is a journey, not a destination."</p>
                </div>
            </div>

            <!-- Action Cards -->
            <Link :href="route('cashier.index')" class="bg-white border border-slate-200 rounded-[40px] p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-14 w-14 bg-blue-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-7 h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="text-xl font-bold mb-2 text-slate-900">Meja Kasir</h3>
                <p class="text-slate-400 text-sm">Proses pesanan pelanggan dan cetak struk otomatis.</p>
            </Link>

            <Link :href="route('admin.menus')" class="bg-white border border-slate-200 rounded-[40px] p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-14 w-14 bg-blue-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-7 h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                </div>
                <h3 class="text-xl font-bold mb-2 text-slate-900">Manajemen Menu</h3>
                <p class="text-slate-400 text-sm">Kelola daftar makanan, minuman, dan kategori produk.</p>
            </Link>

            <Link :href="route('admin.dashboard')" class="bg-white border border-slate-200 rounded-[40px] p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group shadow-sm">
                <div class="h-14 w-14 bg-blue-600/10 rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                    <svg class="w-7 h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="text-xl font-bold mb-2 text-slate-900">Analitik Bisnis</h3>
                <p class="text-slate-400 text-sm">Lihat laporan pendapatan dan performa penjualan harian.</p>
            </Link>
        </div>
    </AuthenticatedLayout>
</template>
