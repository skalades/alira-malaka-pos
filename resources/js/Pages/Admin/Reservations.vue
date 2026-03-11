<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import dayjs from 'dayjs';

const props = defineProps<{
    reservations: {
        data: any[];
        links: any[];
    };
    filters: {
        date: string;
        status: string;
    };
    tables: any[];
}>();

const filterDate = ref(props.filters.date || '');
const filterStatus = ref(props.filters.status || '');
const showProof = ref(false);
const selectedProof = ref('');

const openProof = (proof: string) => {
    selectedProof.value = proof;
    showProof.value = true;
};

const handleFilter = () => {
    router.get(route('admin.reservations.index'), {
        date: filterDate.value,
        status: filterStatus.value
    }, { preserveState: true });
};

const updateStatus = (id: number, status: string) => {
    router.patch(route('admin.reservations.status', id), { status });
};

const checkIn = (id: number) => {
    if (confirm('Konfirmasi Check-In pelanggan? Status akan berubah dan meja akan ditandai aktif.')) {
        router.post(route('admin.reservations.checkin', id));
    }
};

const getStatusBadge = (status: string) => {
    switch (status) {
        case 'pending': return 'bg-yellow-100 text-yellow-700';
        case 'confirmed': return 'bg-blue-100 text-blue-700';
        case 'checked_in': return 'bg-green-100 text-green-700';
        case 'cancelled': return 'bg-red-100 text-red-700';
        default: return 'bg-gray-100 text-gray-700';
    }
};

const translateStatus = (status: string) => {
    switch (status) {
        case 'pending': return 'MENUNGGU';
        case 'confirmed': return 'DIKONFIRMASI';
        case 'checked_in': return 'CHECKED IN';
        case 'cancelled': return 'DIBATALKAN';
        default: return status.toUpperCase();
    }
};
</script>

<template>
    <Head title="Manajemen Reservasi" />

    <AuthenticatedLayout>
        <template #header>
            Daftar Reservasi Meja
        </template>

        <div class="space-y-8">
            <!-- Filters -->
            <div class="bg-white p-6 rounded-[32px] border border-slate-200 shadow-sm flex flex-wrap items-end gap-6">
                <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Pilih Tanggal</label>
                    <input type="date" v-model="filterDate" class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold">
                </div>
                <div class="space-y-2">
                    <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Status</label>
                    <select v-model="filterStatus" class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold">
                        <option value="">Semua Status</option>
                        <option value="pending">Menunggu</option>
                        <option value="confirmed">Dikonfirmasi</option>
                        <option value="checked_in">Checked In</option>
                        <option value="cancelled">Dibatalkan</option>
                    </select>
                </div>
                <button @click="handleFilter" class="h-12 px-8 bg-slate-900 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-black transition-all">
                    Filter
                </button>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-[40px] border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-100">
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Pelanggan</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Waktu Reservasi</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Meja / Pax</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Status</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">DP / Bukti</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="r in reservations.data" :key="r.id" class="border-b border-slate-100 last:border-0 hover:bg-slate-50/50 transition-colors">
                                <td class="p-6">
                                    <div class="font-black text-slate-900">{{ r.customer.name }}</div>
                                    <div class="text-[11px] text-slate-400 font-bold tracking-wider">{{ r.customer.phone }}</div>
                                </td>
                                <td class="p-6">
                                    <div class="font-black text-slate-900">{{ dayjs(r.reservation_time).format('DD MMM YYYY') }}</div>
                                    <div class="text-xs font-bold text-blue-600">Jam {{ dayjs(r.reservation_time).format('HH:mm') }} WIB</div>
                                </td>
                                <td class="p-6 text-center">
                                    <span class="px-3 py-1 bg-slate-100 rounded-full text-[10px] font-black text-slate-600 uppercase">
                                        MEJA {{ r.table.table_number }} • {{ r.num_people }} PAX
                                    </span>
                                </td>
                                <td class="p-6 text-center">
                                    <span :class="['px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-wider', getStatusBadge(r.status)]">
                                        {{ translateStatus(r.status) }}
                                    </span>
                                </td>
                                <td class="p-6 text-center">
                                    <div class="flex flex-col items-center gap-1">
                                        <div class="font-black text-slate-900 text-xs">Rp {{ Number(r.dp_amount || 0).toLocaleString('id-ID') }}</div>
                                        <button v-if="r.transfer_proof" @click="openProof(r.transfer_proof)" class="text-[10px] font-black text-blue-600 uppercase hover:underline">
                                            Lihat Bukti
                                        </button>
                                        <span v-else class="text-[10px] font-black text-slate-300 uppercase italic">Tanpa Bukti</span>
                                    </div>
                                </td>
                                <td class="p-6">
                                    <div class="flex justify-center gap-2">
                                        <button v-if="r.status === 'pending'" @click="updateStatus(r.id, 'confirmed')" class="px-4 py-2 bg-blue-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-blue-700 transition-all">
                                            Konfirmasi
                                        </button>
                                        <button v-if="r.status === 'confirmed'" @click="checkIn(r.id)" class="px-4 py-2 bg-green-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-green-700 transition-all">
                                            Check-In
                                        </button>
                                        <button v-if="r.status === 'pending' || r.status === 'confirmed'" @click="updateStatus(r.id, 'cancelled')" class="p-2 bg-red-50 text-red-600 rounded-xl hover:bg-red-100 transition-all">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="reservations.data.length === 0">
                                <td colspan="5" class="p-20 text-center">
                                    <div class="flex flex-col items-center opacity-20">
                                        <svg class="w-16 h-16 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                        <p class="font-black uppercase tracking-widest text-xs">Tidak ada reservasi ditemukan</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Proof Modal -->
        <div v-if="showProof" class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-slate-900/90 backdrop-blur-sm animate-in fade-in duration-200">
            <div class="relative max-w-4xl w-full bg-white rounded-[40px] overflow-hidden shadow-2xl animate-in zoom-in-95 duration-200">
                <div class="p-6 border-b border-slate-100 flex justify-between items-center">
                    <h3 class="font-black text-slate-900 uppercase text-xs tracking-widest">Bukti Transfer Pelanggan</h3>
                    <button @click="showProof = false" class="p-2 hover:bg-slate-100 rounded-xl transition-all">
                        <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                    </button>
                </div>
                <div class="p-8 flex justify-center bg-slate-50">
                    <img :src="selectedProof" class="max-h-[70vh] rounded-2xl shadow-lg border border-slate-200" alt="Bukti Transfer">
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
