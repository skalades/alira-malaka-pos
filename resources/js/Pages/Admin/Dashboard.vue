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
    topMenus: any[];
    categorySales: any[];
}>();

const chartRef = ref<HTMLCanvasElement | null>(null);
const categoryChartRef = ref<HTMLCanvasElement | null>(null);
const deferredPrompt = ref<any>(null);
const isInstallable = ref(false);

const installPWA = async () => {
    if (!deferredPrompt.value) return;
    deferredPrompt.value.prompt();
    const { outcome } = await deferredPrompt.value.userChoice;
    deferredPrompt.value = null;
    isInstallable.value = false;
};

onMounted(() => {
    window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault();
        deferredPrompt.value = e;
        isInstallable.value = true;
    });

    window.addEventListener('appinstalled', () => {
        isInstallable.value = false;
        deferredPrompt.value = null;
    });

    // 1. Sales Trend Chart
    if (chartRef.value) {
        new Chart(chartRef.value, {
            type: 'line',
            data: {
                labels: props.salesData.map(d => d.date),
                datasets: [{
                    label: 'Pendapatan (Rp)',
                    data: props.salesData.map(d => d.total),
                    borderColor: '#2563eb',
                    backgroundColor: (context) => {
                        const chart = context.chart;
                        const {ctx, chartArea} = chart;
                        if (!chartArea) return 'rgba(37, 99, 235, 0.1)';
                        const gradient = ctx.createLinearGradient(0, chartArea.top, 0, chartArea.bottom);
                        gradient.addColorStop(0, 'rgba(37, 99, 235, 0.2)');
                        gradient.addColorStop(1, 'rgba(37, 99, 235, 0.01)');
                        return gradient;
                    },
                    fill: true,
                    tension: 0.4,
                    borderWidth: 4,
                    pointBackgroundColor: '#2563eb',
                    pointRadius: props.salesData.length > 1 ? 4 : 8,
                    pointHoverRadius: 8
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
                        displayColors: false,
                        callbacks: {
                            label: (context: any) => `Rp ${(context.parsed.y ?? 0).toLocaleString('id-ID')}`
                        }
                    }
                },
                scales: {
                    y: { 
                        beginAtZero: true,
                        grid: { color: 'rgba(0,0,0,0.05)', drawTicks: false },
                        border: { display: false },
                        ticks: { 
                            color: '#94a3b8', 
                            font: { family: 'Outfit', size: 10 },
                            callback: (value) => value === 0 ? '0' : (typeof value === 'number' ? (value / 1000).toLocaleString() + 'k' : value)
                        }
                    },
                    x: { 
                        grid: { display: false },
                        border: { display: false },
                        ticks: { color: '#94a3b8', font: { family: 'Outfit', size: 11 } }
                    }
                }
            }
        });
    }

    // 2. Category Distribution Chart
    if (categoryChartRef.value && props.categorySales.length > 0) {
        new Chart(categoryChartRef.value, {
            type: 'doughnut',
            data: {
                labels: props.categorySales.map(c => c.name),
                datasets: [{
                    data: props.categorySales.map(c => c.value),
                    backgroundColor: ['#2563eb', '#8b5cf6', '#ec4899', '#f97316', '#10b981'],
                    borderWidth: 0
                }]
            },
            options: {
                cutout: '75%',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            font: { family: 'Outfit', size: 10 },
                            padding: 20
                        }
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

        <div class="space-y-6 md:space-y-10 pb-10">
            <!-- Stats Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
                <!-- Total Sales -->
                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px] group hover:shadow-xl hover:shadow-blue-600/5 transition-all">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-10 h-10 bg-blue-50 flex items-center justify-center rounded-2xl text-blue-600">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m.599-1.1c.51-.555.911-1.226.911-1.9 0-1.218-1.343-2.203-3-2.203-1.657 0-3 .984-3 2.203 0 .674.402 1.345.912 1.9m.37 3.51a1.2 1.2 0 111.41-1.41"></path></svg>
                        </div>
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Total Omzet</p>
                    </div>
                    <p class="text-3xl font-black text-blue-600 tracking-tighter">Rp {{ props.stats.totalSales.toLocaleString('id-ID') }}</p>
                    <div class="mt-4 flex items-center gap-2 text-[10px] text-green-500 font-bold uppercase tracking-widest bg-green-50 w-fit px-3 py-1 rounded-full">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 10l7-7m0 0l7 7m-7-7v18"></path></svg>
                        Real Time
                    </div>
                </div>

                <!-- Order Count -->
                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-10 h-10 bg-slate-50 flex items-center justify-center rounded-2xl text-slate-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                        </div>
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Pesanan Dibayar</p>
                    </div>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.orderCount }}</p>
                    <p class="mt-4 text-[10px] text-slate-400 font-bold uppercase tracking-widest">Transaksi Selesai</p>
                </div>

                <!-- Occupied Tables -->
                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-10 h-10 bg-amber-50 flex items-center justify-center rounded-2xl text-amber-500">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
                        </div>
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Meja Aktif</p>
                    </div>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.occupiedTables }}</p>
                    <p class="mt-4 text-[10px] text-blue-600/50 font-bold uppercase tracking-widest">Sesi Berjalan</p>
                </div>

                <!-- Menu Count -->
                <div class="bg-white border border-slate-200 p-6 lg:p-8 rounded-[32px]">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-10 h-10 bg-slate-50 flex items-center justify-center rounded-2xl text-slate-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                        </div>
                        <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Menu Aktif</p>
                    </div>
                    <p class="text-3xl font-black text-slate-900 tracking-tighter">{{ props.stats.menuCount }}</p>
                    <p class="mt-4 text-[10px] text-slate-400 font-bold uppercase tracking-widest">Katalog Berjalan</p>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="bg-white border border-slate-200 p-6 md:p-10 rounded-[40px] relative overflow-hidden">
                <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
                
                <div class="relative z-10">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6 mb-10">
                        <div>
                            <h2 class="text-2xl font-black tracking-tight mb-1 text-slate-900">Tren Pendapatan</h2>
                            <p class="text-slate-400 text-sm">Visualisasi omzet selama 7 hari terakhir.</p>
                        </div>
                        <div class="px-5 py-2.5 bg-blue-600 text-white rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-blue-600/20">
                            7 Hari Terakhir
                        </div>
                    </div>

                    <div class="h-64 md:h-80 w-full">
                        <canvas ref="chartRef"></canvas>
                    </div>
                </div>
            </div>

            <!-- Two Column Stats -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 md:gap-8">
                <!-- Top Selling Items -->
                <div class="bg-white border border-slate-200 p-8 rounded-[40px]">
                    <div class="flex items-center justify-between mb-8">
                        <h3 class="text-xl font-bold text-slate-900">Menu Terlaris</h3>
                        <div class="w-8 h-8 bg-amber-50 rounded-xl flex items-center justify-center text-amber-500">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"></path></svg>
                        </div>
                    </div>
                    
                    <div class="space-y-6">
                        <div v-for="(menu, index) in props.topMenus" :key="index" class="space-y-2">
                            <div class="flex justify-between items-center text-sm">
                                <span class="font-bold text-slate-700 flex items-center gap-2">
                                    <span class="text-[10px] font-black text-slate-400 w-4">0{{ index + 1 }}</span>
                                    {{ menu.name }}
                                </span>
                                <span class="text-blue-600 font-black">{{ menu.quantity }}X</span>
                            </div>
                            <!-- Simple Progress Bar -->
                            <div class="h-2 w-full bg-slate-50 rounded-full overflow-hidden">
                                <div 
                                    class="h-full bg-blue-600 rounded-full transition-all duration-1000"
                                    :style="{ width: index === 0 ? '100%' : (menu.quantity / props.topMenus[0].quantity * 100) + '%' }"
                                ></div>
                            </div>
                            <div class="text-[10px] font-bold text-slate-400 uppercase tracking-widest text-right">
                                Omzet: Rp {{ menu.revenue.toLocaleString('id-ID') }}
                            </div>
                        </div>

                        <div v-if="props.topMenus.length === 0" class="py-10 text-center">
                            <p class="text-slate-400 text-sm italic">Belum ada data penjualan tercatat.</p>
                        </div>
                    </div>
                </div>

                <!-- Category Breakdown -->
                <div class="bg-white border border-slate-200 p-8 rounded-[40px] flex flex-col">
                    <h3 class="text-xl font-bold mb-8 text-slate-900 text-center md:text-left">Distribusi Kategori</h3>
                    
                    <div class="flex-1 flex flex-col items-center justify-center">
                        <div class="h-64 w-full relative">
                            <canvas ref="categoryChartRef"></canvas>
                        </div>
                    </div>

                    <div v-if="props.categorySales.length === 0" class="flex-1 flex items-center justify-center">
                        <p class="text-slate-400 text-sm italic">Belum ada kategori yang terjual.</p>
                    </div>
                </div>
            </div>

            <!-- Footer Section -->
            <div class="bg-slate-900 rounded-[40px] p-8 md:p-12 relative overflow-hidden group">
                <div class="absolute -top-12 -right-12 w-64 h-64 bg-blue-600/20 rounded-full blur-3xl group-hover:bg-blue-600/30 transition-all duration-700"></div>
                <div class="relative z-10 flex flex-col md:flex-row items-center justify-between gap-8 md:gap-20 text-center md:text-left">
                    <div class="max-w-md">
                        <h3 class="text-white text-3xl font-black tracking-tighter mb-4 leading-tight">Analitik di Genggaman Anda.</h3>
                        <p class="text-white/60 font-medium text-sm">Dashboard ini dioptimalkan khusus untuk kenyamanan Anda memantau bisnis melalui smartphone kapanpun dan dimanapun.</p>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
                        <button class="h-14 bg-white text-slate-900 px-8 rounded-2xl font-black uppercase tracking-widest text-xs hover:bg-slate-100 transition-all active:scale-95 flex items-center justify-center gap-3">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                            Download Laporan
                        </button>
                        <button 
                            v-if="isInstallable"
                            @click="installPWA"
                            class="h-14 bg-blue-600 text-white px-8 rounded-2xl font-black uppercase tracking-widest text-xs hover:bg-blue-700 transition-all active:scale-95 flex items-center justify-center gap-3 shadow-lg shadow-blue-600/20"
                        >
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                            Install Aplikasi POS
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap');
* { font-family: 'Outfit', sans-serif; }
</style>
