<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps<{
    customers: {
        data: any[];
        links: any[];
    };
    filters: {
        search: string;
    };
}>();

const showAddModal = ref(false);
const showEditModal = ref(false);
const selectedCustomer = ref<any>(null);
const searchTerm = ref(props.filters.search || '');

const form = useForm({
    name: '',
    phone: '',
    points: 0,
});

const openAddModal = () => {
    form.reset();
    showAddModal.value = true;
};

const openEditModal = (customer: any) => {
    selectedCustomer.value = customer;
    form.name = customer.name;
    form.phone = customer.phone;
    form.points = customer.points;
    showEditModal.value = true;
};

const submitAdd = () => {
    form.post(route('admin.customers.store'), {
        onSuccess: () => {
            showAddModal.value = false;
            form.reset();
        }
    });
};

const submitEdit = () => {
    form.patch(route('admin.customers.update', selectedCustomer.value.id), {
        onSuccess: () => {
            showEditModal.value = false;
        }
    });
};

const deleteCustomer = (id: number) => {
    if (confirm('Apakah Anda yakin ingin menghapus pelanggan ini?')) {
        router.delete(route('admin.customers.delete', id));
    }
};

const handleSearch = () => {
    router.get(route('admin.customers.index'), { search: searchTerm.value }, { preserveState: true });
};

const formatNumber = (num: number) => {
    return new Intl.NumberFormat('id-ID').format(num);
};
</script>

<template>
    <Head title="Manajemen Pelanggan" />

    <AuthenticatedLayout>
        <template #header>
            Manajemen Pelanggan & Loyalty
        </template>

        <div class="space-y-8">
            <!-- Header & Search -->
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                <div class="relative w-full md:w-96">
                    <input 
                        v-model="searchTerm"
                        @keyup.enter="handleSearch"
                        type="text" 
                        placeholder="Cari Nama atau No. HP..." 
                        class="w-full pl-12 pr-4 h-14 bg-white border-slate-200 rounded-2xl focus:ring-blue-600 focus:border-blue-600 font-bold shadow-sm"
                    >
                    <svg class="w-6 h-6 absolute left-4 top-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </div>
                <button @click="openAddModal" class="h-14 px-8 bg-blue-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/20 flex items-center gap-3">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                    Tambah Pelanggan
                </button>
            </div>

            <!-- Table -->
            <div class="bg-white rounded-[40px] border border-slate-200 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-50 border-b border-slate-100">
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest">Nama / No. HP</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Poin Terkumpul</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-right">Total Belanja</th>
                                <th class="p-6 text-[10px] font-black uppercase text-slate-400 tracking-widest text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="c in customers.data" :key="c.id" class="border-b border-slate-100 last:border-0 hover:bg-slate-50/50 transition-colors">
                                <td class="p-6">
                                    <div class="font-black text-slate-900">{{ c.name }}</div>
                                    <div class="text-[11px] text-slate-400 font-bold tracking-wider">{{ c.phone }}</div>
                                </td>
                                <td class="p-6 text-center">
                                    <div class="inline-flex items-center gap-2 px-4 py-1.5 bg-yellow-50 text-yellow-700 rounded-full text-xs font-black">
                                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                                        {{ formatNumber(c.points) }} PTS
                                    </div>
                                </td>
                                <td class="p-6 text-right">
                                    <div class="font-black text-slate-900">Rp {{ formatNumber(c.total_spent) }}</div>
                                </td>
                                <td class="p-6">
                                    <div class="flex justify-center gap-2">
                                        <button @click="openEditModal(c)" class="p-2 bg-blue-50 text-blue-600 rounded-xl hover:bg-blue-100 transition-colors">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                                        </button>
                                        <button @click="deleteCustomer(c.id)" class="p-2 bg-red-50 text-red-600 rounded-xl hover:bg-red-100 transition-colors">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Add Modal -->
        <div v-if="showAddModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <div class="bg-white w-full max-w-lg rounded-[48px] shadow-2xl overflow-hidden p-10 animate-in fade-in zoom-in duration-300">
                <h3 class="text-2xl font-black text-slate-900 tracking-tight mb-8">Tambah Pelanggan Baru</h3>
                <form @submit.prevent="submitAdd" class="space-y-6">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nama Lengkap</label>
                        <input v-model="form.name" type="text" required class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold h-12">
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nomor Handphone</label>
                        <input v-model="form.phone" type="text" required class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold h-12">
                    </div>
                    <div class="flex gap-4 pt-4">
                        <button type="submit" :disabled="form.processing" class="flex-1 h-14 bg-blue-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/20">
                            Simpan Pelanggan
                        </button>
                        <button type="button" @click="showAddModal = false" class="px-8 h-14 bg-slate-100 text-slate-600 rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">
                            Batal
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit Modal -->
        <div v-if="showEditModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <div class="bg-white w-full max-w-lg rounded-[48px] shadow-2xl overflow-hidden p-10 animate-in fade-in zoom-in duration-300">
                <h3 class="text-2xl font-black text-slate-900 tracking-tight mb-8">Edit Pelanggan</h3>
                <form @submit.prevent="submitEdit" class="space-y-6">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nama Lengkap</label>
                        <input v-model="form.name" type="text" required class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold h-12">
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nomor Handphone</label>
                        <input v-model="form.phone" type="text" required class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold h-12">
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Poin Loyalty</label>
                        <input v-model="form.points" type="number" required class="block w-full rounded-2xl border-slate-200 focus:border-blue-600 focus:ring-blue-600 font-bold h-12">
                    </div>
                    <div class="flex gap-4 pt-4">
                        <button type="submit" :disabled="form.processing" class="flex-1 h-14 bg-blue-600 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/20">
                            Update Data
                        </button>
                        <button type="button" @click="showEditModal = false" class="px-8 h-14 bg-slate-100 text-slate-600 rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">
                            Batal
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
