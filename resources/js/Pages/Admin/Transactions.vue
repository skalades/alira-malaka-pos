<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, router, Link } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import dayjs from 'dayjs';

const props = defineProps<{
    transactions: {
        data: any[];
        links: any[];
        meta: any;
    };
    filters: {
        start_date: string;
        end_date: string;
        payment_method: string;
    };
}>();

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');
const paymentMethod = ref(props.filters.payment_method || '');
const selectedTransaction = ref<any>(null);
const showDetailModal = ref(false);

const applyFilters = () => {
    router.get(route('admin.transactions'), {
        start_date: startDate.value,
        end_date: endDate.value,
        payment_method: paymentMethod.value
    }, { preserveState: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    paymentMethod.value = '';
    applyFilters();
};

const viewDetails = (transaction: any) => {
    selectedTransaction.value = transaction;
    showDetailModal.value = true;
};

const deleteTransaction = (id: number) => {
    if (confirm('Apakah Anda yakin ingin menghapus transaksi ini? Tindakan ini juga akan menghapus data pesanan terkait dan tidak dapat dibatalkan.')) {
        router.delete(route('admin.transactions.delete', id), {
            onSuccess: () => {
                showDetailModal.value = false;
            }
        });
    }
};

const formatNumber = (num: number) => {
    return new Intl.NumberFormat('id-ID').format(num);
};

const getStatusColor = (method: string) => {
    switch (method.toLowerCase()) {
        case 'cash': return 'bg-slate-100 text-slate-700';
        case 'qris': return 'bg-blue-100 text-blue-700';
        case 'transfer': return 'bg-indigo-100 text-indigo-700';
        default: return 'bg-gray-100 text-gray-700';
    }
};
</script>

<template>
    <Head title="Riwayat Transaksi" />

    <AuthenticatedLayout>
        <template #header>
            Riwayat Transaksi
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
                <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Metode</label>
                    <select v-model="paymentMethod" class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold">
                        <option value="">Semua Metode</option>
                        <option value="Cash">Cash</option>
                        <option value="QRIS">QRIS</option>
                        <option value="Transfer">Transfer</option>
                    </select>
                </div>
                <div class="flex gap-2">
                    <button @click="applyFilters" class="h-12 px-8 bg-blue-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/20">
                        Filter
                    </button>
                    <button @click="resetFilters" class="h-12 px-6 bg-slate-100 text-slate-600 rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">
                        Reset
                    </button>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-[40px] border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-100">
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">ID / Waktu</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Order #</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Meja</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Metode</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-right">Total Bayar</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="t in transactions.data" :key="t.id" class="border-b border-slate-100 last:border-0 hover:bg-slate-50/50 transition-colors">
                                <td class="p-6">
                                    <div class="font-black text-slate-900">#TRX-{{ t.id }}</div>
                                    <div class="text-[11px] text-slate-400 font-medium">{{ dayjs(t.transaction_time).format('DD MMM YYYY, HH:mm') }}</div>
                                </td>
                                <td class="p-6">
                                    <span class="font-bold text-slate-700">{{ t.order.order_number }}</span>
                                </td>
                                <td class="p-6">
                                    <span class="px-3 py-1 bg-slate-100 rounded-full text-[11px] font-black text-slate-600">
                                        {{ t.order.table ? 'MEJA ' + t.order.table.table_number : t.order.type }}
                                    </span>
                                </td>
                                <td class="p-6">
                                    <span :class="['px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider', getStatusColor(t.payment_method)]">
                                        {{ t.payment_method }}
                                    </span>
                                </td>
                                <td class="p-6 text-right font-black text-slate-900">
                                    Rp {{ formatNumber(t.amount_paid - t.change_amount) }}
                                </td>
                                <td class="p-6">
                                    <div class="flex justify-center gap-2">
                                        <button @click="viewDetails(t)" class="p-2 bg-blue-50 text-blue-600 rounded-xl hover:bg-blue-100 transition-colors" title="Lihat Detail">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                        </button>
                                        <button @click="deleteTransaction(t.id)" class="p-2 bg-red-50 text-red-600 rounded-xl hover:bg-red-100 transition-colors" title="Hapus">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="transactions.data.length === 0">
                                <td colspan="6" class="p-20 text-center">
                                    <div class="flex flex-col items-center opacity-20">
                                        <svg class="w-16 h-16 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                        <p class="font-black uppercase tracking-widest text-xs">Belum ada transaksi</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div v-if="transactions.links.length > 3" class="p-8 bg-slate-50 border-t border-slate-100 flex justify-center gap-2">
                    <template v-for="(link, k) in transactions.links" :key="k">
                        <div v-if="link.url === null" class="h-10 px-4 flex items-center justify-center rounded-xl bg-white border border-slate-200 text-slate-300 text-xs font-bold" v-html="link.label"></div>
                        <Link v-else :href="link.url" class="h-10 px-4 flex items-center justify-center rounded-xl border font-bold text-xs transition-all" :class="link.active ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-white border-slate-200 text-slate-600 hover:border-blue-600 hover:text-blue-600'" v-html="link.label"></Link>
                    </template>
                </div>
            </div>
        </div>

        <!-- Detail Modal -->
        <div v-if="showDetailModal" class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <div class="bg-white w-full max-w-2xl rounded-[48px] shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-300">
                <div class="p-8 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                    <div>
                        <h3 class="text-xl font-black text-slate-900 tracking-tight">Detail Transaksi #{{ selectedTransaction.id }}</h3>
                        <p class="text-[11px] font-bold text-slate-400 uppercase tracking-widest">{{ dayjs(selectedTransaction.transaction_time).format('DD MMMM YYYY, HH:mm') }}</p>
                    </div>
                    <button @click="showDetailModal = false" class="w-12 h-12 flex items-center justify-center rounded-2xl bg-white border border-slate-200 text-slate-400 hover:text-slate-900 hover:border-slate-900 transition-all">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                    </button>
                </div>
                <div class="p-8 max-h-[70vh] overflow-y-auto space-y-8">
                    <!-- Info Grid -->
                    <div class="grid grid-cols-2 gap-6">
                        <div class="p-6 bg-slate-50 rounded-3xl">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Customer / Meja</p>
                            <p class="font-black text-slate-900">{{ selectedTransaction.order.table ? 'MEJA ' + selectedTransaction.order.table.table_number : 'OFFLINE / TAKE AWAY' }}</p>
                        </div>
                        <div class="p-6 bg-slate-50 rounded-3xl">
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Metode Pembayaran</p>
                            <span :class="['px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider', getStatusColor(selectedTransaction.payment_method)]">
                                {{ selectedTransaction.payment_method }}
                            </span>
                        </div>
                    </div>

                    <!-- Items -->
                    <div>
                        <h4 class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-4 ml-1">Rincian Pesanan</h4>
                        <div class="space-y-3">
                            <div v-for="item in selectedTransaction.order.order_items" :key="item.id" class="flex justify-between items-center p-4 bg-slate-50 rounded-2xl">
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center font-black text-blue-600 border border-slate-100">
                                        {{ item.quantity }}x
                                    </div>
                                    <div>
                                        <p class="font-bold text-slate-900">{{ item.menu.name }}</p>
                                        <p class="text-[11px] text-slate-400">@ Rp {{ formatNumber(item.price_at_time) }}</p>
                                    </div>
                                </div>
                                <p class="font-black text-slate-900">Rp {{ formatNumber(item.price_at_time * item.quantity) }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Details -->
                    <div class="border-t border-slate-100 pt-8 space-y-4">
                        <div class="flex justify-between text-slate-600 font-bold">
                            <span>TOTAL PESANAN</span>
                            <span>Rp {{ formatNumber(selectedTransaction.order.total_price) }}</span>
                        </div>
                        <div class="flex justify-between text-slate-600 font-bold">
                            <span>DIBAYAR</span>
                            <span>Rp {{ formatNumber(selectedTransaction.amount_paid) }}</span>
                        </div>
                        <div class="flex justify-between text-blue-600 font-black text-xl border-t border-blue-50 pt-4">
                            <span>KEMBALIAN</span>
                            <span>Rp {{ formatNumber(selectedTransaction.change_amount) }}</span>
                        </div>
                    </div>
                </div>
                <div class="p-8 bg-slate-50/50 border-t border-slate-100 flex justify-end gap-4">
                    <button @click="deleteTransaction(selectedTransaction.id)" class="px-8 h-14 bg-red-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-red-700 transition-all shadow-lg shadow-red-600/20">
                        Hapus Transaksi
                    </button>
                    <button @click="showDetailModal = false" class="px-8 h-14 bg-slate-900 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-black transition-all">
                        Tutup
                    </button>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
