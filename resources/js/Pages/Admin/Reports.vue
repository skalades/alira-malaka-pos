<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, onMounted, computed, watch } from 'vue';
import Chart from 'chart.js/auto';

const props = defineProps<{
    itemizedSales: any[];
    totalRevenue: number;
    orderCount: number;
    chartData: any[];
    shiftStats: {
        total_opening: number;
        total_closing: number;
    };
    paymentBreakdown: {
        cash: number;
        qris: number;
        transfer: number;
        other?: number;
    };
    filters: {
        start_date: string;
        end_date: string;
    };
}>();

const startDate = ref(props.filters.start_date);
const endDate = ref(props.filters.end_date);
const chartCanvas = ref<HTMLCanvasElement | null>(null);
let chartInstance: any = null;

const applyFilters = () => {
    router.get(route('admin.reports'), {
        start_date: startDate.value,
        end_date: endDate.value
    }, { preserveState: true });
};

const setToday = () => {
    const today = new Date().toISOString().split('T')[0];
    startDate.value = today;
    endDate.value = today;
    applyFilters();
};

const exportPdf = () => {
    window.location.href = route('admin.reports.export', {
        start_date: startDate.value,
        end_date: endDate.value
    });
};

const initChart = () => {
    if (!chartCanvas.value) return;
    if (chartInstance) chartInstance.destroy();

    const ctx = chartCanvas.value.getContext('2d');
    if (!ctx) return;

    chartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: props.chartData.map(d => d.date),
            datasets: [{
                label: 'Pendapatan (Rp)',
                data: props.chartData.map(d => d.total),
                borderColor: '#2563eb',
                backgroundColor: 'rgba(37, 99, 235, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });
};

onMounted(() => {
    initChart();
});

watch(() => props.chartData, () => {
    initChart();
});
</script>

<template>
    <Head title="Laporan Penjualan" />

    <AuthenticatedLayout>
        <template #header>
            Laporan Penjualan
        </template>

        <div class="space-y-8">
            <!-- Filters -->
            <div class="bg-white p-6 rounded-[32px] border border-slate-200 shadow-sm flex flex-wrap items-end gap-6">
                <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Dari Tanggal</label>
                    <input type="date" v-model="startDate" class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold">
                </div>
                <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Sampai Tanggal</label>
                    <input type="date" v-model="endDate" class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold">
                </div>
                <button @click="applyFilters" class="h-12 px-8 bg-blue-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all">
                    Filter
                </button>
                <button @click="setToday" class="h-12 px-8 bg-amber-500 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-amber-600 transition-all">
                    HARI INI
                </button>
                <button @click="exportPdf" class="h-12 px-8 bg-slate-900 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-black transition-all flex items-center gap-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                    Simpan PDF
                </button>
            </div>

            <!-- Stats -->
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div class="bg-blue-600 p-8 rounded-[40px] text-white shadow-xl shadow-blue-600/20">
                    <p class="text-[10px] font-black uppercase tracking-[0.2em] opacity-60 mb-2">Total Pendapatan</p>
                    <h3 class="text-2xl font-black tracking-tighter">Rp {{ totalRevenue.toLocaleString('id-ID') }}</h3>
                </div>
                <div class="bg-slate-900 p-8 rounded-[40px] text-white shadow-xl shadow-slate-900/20">
                    <p class="text-[10px] font-black uppercase tracking-[0.2em] opacity-40 mb-2">Total Transaksi</p>
                    <h3 class="text-2xl font-black tracking-tighter">{{ orderCount }} Pesanan</h3>
                </div>
                <div class="bg-white p-8 rounded-[40px] border border-slate-200 shadow-sm">
                    <p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Total Buka Kas</p>
                    <h3 class="text-2xl font-black text-slate-900 tracking-tighter">Rp {{ shiftStats.total_opening.toLocaleString('id-ID') }}</h3>
                </div>
                <div class="bg-white p-8 rounded-[40px] border border-slate-200 shadow-sm">
                    <p class="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400 mb-2">Total Tutup Kas</p>
                    <h3 class="text-2xl font-black text-slate-900 tracking-tighter">Rp {{ shiftStats.total_closing.toLocaleString('id-ID') }}</h3>
                </div>
            </div>

            <!-- Chart -->
            <div class="bg-white p-8 rounded-[40px] border border-slate-200 shadow-sm">
                <h3 class="text-lg font-black text-slate-900 tracking-tighter mb-6 uppercase tracking-widest text-slate-400">Tren Penjualan</h3>
                <div class="h-72 relative">
                    <canvas ref="chartCanvas"></canvas>
                </div>
            </div>

            <!-- Payment Method Breakdown -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <div class="bg-white p-8 rounded-[40px] border border-slate-200 shadow-sm">
                    <h3 class="text-lg font-black text-slate-900 tracking-tighter mb-6 uppercase tracking-widest text-slate-400">Metode Pembayaran</h3>
                    <div class="space-y-6">
                        <div class="flex justify-between items-center p-4 bg-slate-50 rounded-2xl">
                            <span class="font-bold text-slate-600">Tunai (Cash)</span>
                            <span class="font-black text-slate-900 text-lg">Rp {{ paymentBreakdown.cash.toLocaleString('id-ID') }}</span>
                        </div>
                        <div class="flex justify-between items-center p-4 bg-blue-50/50 rounded-2xl">
                            <span class="font-bold text-blue-600">QRIS</span>
                            <span class="font-black text-blue-600 text-lg">Rp {{ paymentBreakdown.qris.toLocaleString('id-ID') }}</span>
                        </div>
                        <div class="flex justify-between items-center p-4 bg-indigo-50/50 rounded-2xl">
                            <span class="font-bold text-indigo-600">Transfer</span>
                            <span class="font-black text-indigo-600 text-lg">Rp {{ paymentBreakdown.transfer.toLocaleString('id-ID') }}</span>
                        </div>
                        <div v-if="paymentBreakdown.other" class="flex justify-between items-center p-4 bg-slate-100 rounded-2xl">
                            <span class="font-bold text-slate-500">Lainnya</span>
                            <span class="font-black text-slate-500 text-lg">Rp {{ paymentBreakdown.other.toLocaleString('id-ID') }}</span>
                        </div>
                    </div>
                </div>

                <div class="bg-blue-600 p-8 rounded-[40px] text-white shadow-xl shadow-blue-600/20 flex flex-col justify-center text-center">
                    <p class="text-[12px] font-black uppercase tracking-[0.3em] opacity-60 mb-4">Total Pendapatan Bersih</p>
                    <h2 class="text-4xl lg:text-5xl font-black tracking-tighter mb-2">Rp {{ totalRevenue.toLocaleString('id-ID') }}</h2>
                    <p class="text-[10px] font-bold opacity-40 uppercase tracking-widest">Periode Terpilih</p>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-[40px] border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-8 border-b border-slate-100 flex justify-between items-center">
                    <h3 class="text-lg font-black text-slate-900 tracking-tighter uppercase tracking-widest text-slate-400">Produk Terjual</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-100">
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Nama Produk</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-right">Sisa Stok</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-right">Terjual</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-right">Total (Rp)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="item in itemizedSales" :key="item.name" class="border-b border-slate-100 last:border-0 hover:bg-slate-50/50 transition-colors">
                                <td class="p-6 font-bold text-slate-900">{{ item.name }}</td>
                                <td class="p-6 text-right font-black" :class="item.stock <= 5 ? 'text-red-600' : 'text-slate-400'">{{ item.stock }}</td>
                                <td class="p-6 text-right font-black text-blue-600">{{ item.quantity }}</td>
                                <td class="p-6 text-right font-black text-slate-900">Rp {{ item.revenue.toLocaleString('id-ID') }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
