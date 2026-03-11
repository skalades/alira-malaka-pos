<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { onMounted, ref } from 'vue';
import Chart from 'chart.js/auto';
import { Head } from '@inertiajs/vue3';

const props = defineProps<{
    stats: {
        totalSales: number;
        orderCount: number;
        menuCount: number;
        occupiedTables: number;
    };
    salesData: any[];
}>();

const chartRef = ref<HTMLCanvasElement | null>(null);

onMounted(() => {
    if (chartRef.value) {
        new Chart(chartRef.value, {
            type: 'line',
            data: {
                labels: props.salesData.map(d => d.date),
                datasets: [{
                    label: 'Pendapatan (Rp)',
                    data: props.salesData.map(d => d.total),
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 4,
                    pointBackgroundColor: '#2563eb',
                    pointRadius: 0,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1e293b',
                        titleFont: { family: 'Outfit', size: 12 },
                        bodyFont: { family: 'Outfit', size: 14, weight: 'bold' },
                        padding: 12,
                        cornerRadius: 12,
                        displayColors: false
                    }
                },
                scales: {
                    y: { 
                        beginAtZero: true,
                        grid: { color: 'rgba(0,0,0,0.05)' },
                        ticks: { color: '#94a3b8', font: { family: 'Outfit' } }
                    },
                    x: { 
                        grid: { display: false },
                        ticks: { color: '#94a3b8', font: { family: 'Outfit' } }
                    }
                }
            }
        });
    }
});
</script>

<template>
    <Head title="Analytics - Alira Malaka" />

    <AuthenticatedLayout>
        <template #header>
            Analitik Bisnis
        </template>

        <div class="space-y-10">
            <!-- Stats Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px] group hover:shadow-xl hover:shadow-blue-600/5 transition-all">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4">Total Pendapatan</p>
                    <p class="text-3xl font-black text-blue-600 tracking-tighter">Rp {{ props.stats.totalSales.toLocaleString('id-ID') }}</p>
                    <div class="mt-4 flex items-center gap-2 text-[10px] text-green-600 font-bold uppercase tracking-widest">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 10l7-7m0 0l7 7m-7-7v18"></path></svg>
                        +12.5% vs Periode Lalu
                    </div>
                </div>

                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4">Pesanan Dibayar</p>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.orderCount }}</p>
                    <p class="mt-4 text-[10px] text-slate-400 font-bold uppercase tracking-widest">Transaksi Berhasil</p>
                </div>

                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4">Meja Aktif</p>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.occupiedTables }}</p>
                    <p class="mt-4 text-[10px] text-blue-600/50 font-bold uppercase tracking-widest">Sesi Berjalan</p>
                </div>

                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4">Menu Aktif</p>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.menuCount }}</p>
                    <p class="mt-4 text-[10px] text-slate-400 font-bold uppercase tracking-widest">Dalam Katalog</p>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="bg-white border border-slate-200 p-6 lg:p-10 rounded-[32px] lg:rounded-[40px] relative overflow-hidden">
                <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
                
                <div class="relative z-10">
                    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 mb-10">
                        <div>
                            <h2 class="text-2xl font-black tracking-tight mb-1 text-slate-900">Performa Penjualan</h2>
                            <p class="text-slate-400 text-sm">Pelacakan pendapatan waktu nyata di semua titik transaksi.</p>
                        </div>
                        <div class="flex gap-2 w-full sm:w-auto">
                            <button class="flex-1 sm:flex-none px-4 py-2 bg-slate-100 hover:bg-slate-200 rounded-xl text-xs font-bold transition-all underline decoration-blue-600 underline-offset-4 text-slate-900">Mingguan</button>
                            <button class="flex-1 sm:flex-none px-4 py-2 bg-slate-50 hover:bg-slate-100 rounded-xl text-xs font-bold transition-all text-slate-400">Bulanan</button>
                        </div>
                    </div>

                    <div class="h-80 w-full">
                        <canvas ref="chartRef"></canvas>
                    </div>
                </div>
            </div>

            <!-- Quick Access / Bottom Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <div class="bg-white border border-slate-200 p-8 rounded-[32px]">
                    <h3 class="text-xl font-bold mb-6 text-slate-900">Laporan Sistem</h3>
                    <div class="space-y-4">
                        <button class="w-full h-14 bg-slate-50 hover:bg-slate-100 rounded-2xl px-6 flex items-center justify-between transition-all group">
                            <span class="font-bold text-sm text-slate-700">Unduh Laporan Penjualan (PDF)</span>
                            <svg class="w-5 h-5 text-slate-300 group-hover:text-blue-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                        </button>
                        <button class="w-full h-14 bg-slate-50 hover:bg-slate-100 rounded-2xl px-6 flex items-center justify-between transition-all group">
                            <span class="font-bold text-sm text-slate-700">Ekspor Data Inventaris (CSV)</span>
                            <svg class="w-5 h-5 text-slate-300 group-hover:text-blue-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                        </button>
                    </div>
                </div>

                <div class="bg-slate-900 rounded-[32px] p-6 lg:p-8 flex flex-col justify-between relative overflow-hidden group">
                    <div class="absolute -top-12 -right-12 w-48 h-48 bg-blue-600/20 rounded-full blur-3xl group-hover:bg-blue-600/30 transition-all duration-700"></div>
                    <div class="relative z-10">
                        <h3 class="text-white text-xl lg:text-2xl font-black tracking-tighter mb-2 leading-tight">Butuh Bantuan?</h3>
                        <p class="text-white/60 font-medium text-sm">Hubungi tim pengembang Alira Malaka jika Anda mengalami kendala pada sistem.</p>
                    </div>
                    <button class="relative z-10 mt-6 h-14 bg-blue-600 text-white rounded-2xl font-black uppercase tracking-widest text-xs hover:bg-blue-700 transition-all active:scale-95 shadow-lg shadow-blue-600/20">
                        Hubungi Pengembang
                    </button>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
