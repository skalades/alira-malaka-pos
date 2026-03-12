<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { ref, computed } from 'vue';
import { useForm, router, Head } from '@inertiajs/vue3';
import QrcodeVue from 'qrcode.vue';

const props = defineProps<{
    menus: any[];
    categories: any[];
    tables: any[];
}>();

const activeTab = ref('menus');
const isCategoryModalOpen = ref(false);
const isMenuModalOpen = ref(false);
const selectedItem = ref<any>(null);

// Search & Filter State
const searchQuery = ref('');
const selectedCategoryId = ref<number | null>(null);

const filteredMenus = computed(() => {
    return props.menus.filter(m => {
        const matchesCategory = !selectedCategoryId.value || m.category_id === selectedCategoryId.value;
        const matchesSearch = !searchQuery.value || m.name.toLowerCase().includes(searchQuery.value.toLowerCase());
        return matchesCategory && matchesSearch;
    });
});

const categoryForm = useForm({
    name: ''
});

const menuForm = useForm({
    category_id: '',
    name: '',
    price: 0,
    stock: 0,
    description: '',
    image_file: null as any
});

const openCategoryModal = (cat: any = null) => {
    selectedItem.value = cat;
    categoryForm.name = cat ? cat.name : '';
    isCategoryModalOpen.value = true;
};

const submitCategory = () => {
    if (selectedItem.value) {
        categoryForm.patch(route('admin.categories.update', selectedItem.value.id), {
            onSuccess: () => (isCategoryModalOpen.value = false)
        });
    } else {
        categoryForm.post(route('admin.categories.store'), {
            onSuccess: () => (isCategoryModalOpen.value = false)
        });
    }
};

const openMenuModal = (menu: any = null) => {
    selectedItem.value = menu;
    menuForm.category_id = menu ? menu.category_id : '';
    menuForm.name = menu ? menu.name : '';
    menuForm.price = menu ? menu.price : 0;
    menuForm.stock = menu ? menu.stock : 0;
    menuForm.description = menu ? menu.description : '';
    isMenuModalOpen.value = true;
};

const submitMenu = () => {
    if (selectedItem.value) {
        menuForm.post(route('admin.menus.update', selectedItem.value.id), {
            onSuccess: () => (isMenuModalOpen.value = false),
            forceFormData: true
        });
    } else {
        menuForm.post(route('admin.menus.store'), {
            onSuccess: () => (isMenuModalOpen.value = false)
        });
    }
};

const deleteItem = (type: string, id: number) => {
    if (confirm('Apakah Anda yakin ingin menghapus data ini?')) {
        router.delete(route(`admin.${type}.delete`, id));
    }
};

const regenerateQR = (id: number) => {
    router.post(route('admin.table.qr', id), {}, { preserveScroll: true });
};

const isQRModalOpen = ref(false);
const tableToPrint = ref<any>(null);

const openPrintModal = (table: any) => {
    tableToPrint.value = table;
    isQRModalOpen.value = true;
};

const triggerPrintQR = () => {
    setTimeout(() => {
        window.print();
    }, 500);
};

const getBaseUrl = () => window.location.origin;
</script>

<style>
@media print {
    .no-print { display: none !important; }
    .print-only { display: block !important; }
    body { background: white !important; color: black !important; }
}
.print-only { display: none; }
</style>

<template>
    <Head title="Management - Alira Malaka" />

    <AuthenticatedLayout>
        <template #header>
            Manajemen Produk & Sumber Daya
        </template>

        <!-- Hidden Print Section -->
        <div v-if="tableToPrint" class="print-only fixed inset-0 bg-white z-[9999] p-20 text-center font-['Outfit']">
            <div class="max-w-md mx-auto border-[10px] border-black p-10 rounded-[60px]">
                <h1 class="text-4xl font-black mb-2 uppercase tracking-[0.2em] text-black">ALIRA MALAKA</h1>
                <p class="text-xl font-bold mb-10 text-black/60 uppercase tracking-widest">Premium Coffee & Eatery</p>
                
                <div class="bg-white p-6 border-4 border-black rounded-[40px] inline-block mb-10 shadow-2xl">
                    <qrcode-vue 
                        :value="getBaseUrl() + '/order/' + tableToPrint.table_number + '?token=' + tableToPrint.qr_code_token" 
                        :size="300" 
                        level="H" 
                        render-as="svg" 
                    />
                </div>

                <div class="space-y-4">
                    <h2 class="text-6xl font-black text-black">MEJA {{ tableToPrint.table_number }}</h2>
                    <p class="text-sm font-bold text-black/40 uppercase tracking-[0.3em]">Scan to explore our menu</p>
                </div>

                <div class="mt-20 pt-10 border-t-2 border-dashed border-black/20">
                    <p class="text-xs font-black text-black/30 uppercase tracking-widest">Powered by Alira POS System</p>
                </div>
            </div>
        </div>

        <div class="space-y-8 no-print">
            <!-- Header section with Tab Switching -->
            <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-6">
                <div class="flex flex-wrap bg-slate-100 p-1.5 rounded-2xl border border-slate-200 w-full lg:w-auto">
                    <button 
                        v-for="tab in ['menus', 'categories', 'tables']" 
                        :key="tab"
                        @click="activeTab = tab"
                        class="flex-1 lg:flex-none px-6 lg:px-8 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest transition-all duration-300"
                        :class="activeTab === tab ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20' : 'text-slate-400 hover:text-slate-600'"
                    >
                        {{ tab === 'menus' ? 'Menu' : (tab === 'categories' ? 'Kategori' : 'Meja') }}
                    </button>
                </div>
                
                <div v-if="activeTab === 'menus'" class="w-full lg:w-auto">
                    <button @click="openMenuModal()" class="w-full lg:w-auto h-14 px-8 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-blue-700 transition-all active:scale-95 flex items-center justify-center gap-2 shadow-lg shadow-blue-600/20">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"></path></svg>
                        Tambah Menu Baru
                    </button>
                </div>
 
                <div v-if="activeTab === 'categories'" class="w-full lg:w-auto">
                    <button @click="openCategoryModal()" class="w-full lg:w-auto h-14 px-8 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-blue-700 transition-all active:scale-95 flex items-center justify-center gap-2 shadow-lg shadow-blue-600/20">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"></path></svg>
                        Tambah Kategori
                    </button>
                </div>
            </div>

            <!-- Search & Filter Area (Active only for Menus) -->
            <div v-if="activeTab === 'menus'" class="flex flex-col lg:flex-row gap-6 animate-in fade-in slide-in-from-top-4 duration-500">
                <div class="flex-1 relative">
                    <svg class="absolute left-6 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                    <input 
                        v-model="searchQuery"
                        type="text" 
                        placeholder="Cari menu berdasarkan nama..." 
                        class="w-full bg-white border-slate-200 rounded-[28px] py-5 pl-16 pr-8 text-sm font-bold focus:border-blue-600 focus:ring-0 transition-all outline-none shadow-sm"
                    >
                </div>
                <div class="flex flex-nowrap overflow-x-auto gap-2 no-scrollbar pb-2">
                    <button 
                        @click="selectedCategoryId = null"
                        class="px-8 h-16 rounded-[24px] text-[10px] font-black uppercase tracking-[0.2em] border transition-all whitespace-nowrap"
                        :class="selectedCategoryId === null ? 'bg-slate-900 border-slate-900 text-white shadow-xl' : 'bg-white border-slate-200 text-slate-400 hover:border-slate-300'"
                    >
                        Semua Kategori
                    </button>
                    <button 
                        v-for="cat in categories" 
                        :key="cat.id"
                        @click="selectedCategoryId = cat.id"
                        class="px-8 h-16 rounded-[24px] text-[10px] font-black uppercase tracking-[0.2em] border transition-all whitespace-nowrap"
                        :class="selectedCategoryId === cat.id ? 'bg-slate-900 border-slate-900 text-white shadow-xl' : 'bg-white border-slate-200 text-slate-400 hover:border-slate-300'"
                    >
                        {{ cat.name }}
                    </button>
                </div>
            </div>

            <!-- Menus Content -->
            <div v-if="activeTab === 'menus'" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
                <div v-for="menu in filteredMenus" :key="menu.id" class="bg-white border border-slate-200 rounded-[32px] p-6 group hover:shadow-xl hover:shadow-blue-600/5 transition-all relative overflow-hidden">
                    <div class="relative mb-6 overflow-hidden rounded-2xl">
                        <img :src="menu.image" class="w-full h-44 object-cover group-hover:scale-110 transition-transform duration-700">
                        <div class="absolute top-4 left-4 bg-white/80 backdrop-blur-md border border-slate-200 px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest text-blue-600">
                            {{ menu.category.name }}
                        </div>
                    </div>
                    <h3 class="font-black text-xl text-slate-900 mb-1 group-hover:text-blue-600 transition-colors">{{ menu.name }}</h3>
                    <p class="text-slate-400 font-bold mb-6">Rp {{ Number(menu.price).toLocaleString('id-ID') }}</p>
                    
                    <div class="flex justify-between items-center bg-slate-50 rounded-2xl p-4">
                        <div class="flex items-center gap-2">
                            <span class="w-1.5 h-1.5 rounded-full" :class="menu.stock <= 5 ? 'bg-red-500 animate-pulse' : 'bg-green-500'"></span>
                            <span class="text-[10px] font-black uppercase tracking-widest" :class="menu.stock <= 5 ? 'text-red-600' : 'text-slate-400'">Stok: {{ menu.stock }}</span>
                        </div>
                        <div class="flex gap-2">
                            <button @click="openMenuModal(menu)" class="p-2.5 bg-white border border-slate-200 text-slate-400 rounded-xl hover:text-blue-600 hover:border-blue-600/30 transition-all shadow-sm"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg></button>
                            <button @click="deleteItem('menus', menu.id)" class="p-2.5 bg-white border border-slate-200 text-slate-400 rounded-xl hover:text-red-500 hover:border-red-500/30 transition-all shadow-sm"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Categories Content -->
            <div v-if="activeTab === 'categories'" class="bg-white border border-slate-200 rounded-[32px] lg:rounded-[40px] overflow-hidden animate-in fade-in duration-500 shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left min-w-[600px]">
                    <thead class="bg-slate-50 border-b border-slate-200">
                        <tr>
                            <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Nama Kategori</th>
                            <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Slug</th>
                            <th class="px-10 py-6 text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] text-right">Manajemen</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <tr v-for="cat in categories" :key="cat.id" class="hover:bg-slate-50 transition-colors">
                            <td class="px-10 py-6 font-black text-lg text-slate-900">{{ cat.name }}</td>
                            <td class="px-10 py-6 font-mono text-xs text-slate-400">{{ cat.slug }}</td>
                            <td class="px-10 py-6 text-right">
                                <div class="flex justify-end gap-3">
                                    <button @click="openCategoryModal(cat)" class="h-10 px-4 bg-slate-100 text-xs font-bold rounded-xl hover:text-blue-600 hover:bg-white border border-transparent hover:border-slate-200 transition-all">Edit</button>
                                    <button @click="deleteItem('categories', cat.id)" class="h-10 px-4 bg-red-50 text-xs font-bold rounded-xl hover:text-red-600 hover:bg-white border border-transparent hover:border-red-100 transition-all text-red-500/50">Hapus</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </div>
            </div>

            <!-- Tables Content -->
            <div v-if="activeTab === 'tables'" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 animate-in fade-in duration-500">
                <div v-for="table in tables" :key="table.id" class="bg-white border border-slate-200 rounded-[32px] p-8 text-center hover:shadow-xl hover:shadow-blue-600/5 transition-all group overflow-hidden relative">
                    <div class="absolute -top-12 -right-12 w-32 h-32 bg-blue-600/5 rounded-full blur-2xl group-hover:bg-blue-600/10 transition-all"></div>
                    
                    <div class="mb-8 flex justify-center scale-90 sm:scale-100 cursor-pointer" @click="openPrintModal(table)">
                        <div class="bg-white p-3 rounded-[32px] shadow-2xl relative transition-transform group-hover:scale-105 duration-500 border border-slate-100">
                            <qrcode-vue 
                                :value="getBaseUrl() + '/order/' + table.table_number + '?token=' + table.qr_code_token" 
                                :size="160" 
                                level="H" 
                                render-as="svg" 
                                class="bg-white" 
                            />
                        </div>
                    </div>
                    <h3 class="font-black text-2xl text-slate-900 mb-1">Meja {{ table.table_number }}</h3>
                    <p class="text-[10px] text-slate-400 font-mono mb-8 bg-slate-50 py-1.5 rounded-full mx-4 uppercase tracking-tighter border border-slate-100">TOKEN: {{ table.qr_code_token }}</p>
                    <div class="grid grid-cols-2 gap-2">
                        <button 
                            @click="regenerateQR(table.id)"
                            class="py-4 bg-slate-100 text-[10px] font-black uppercase tracking-widest text-slate-600 hover:bg-slate-200 transition-all active:scale-95 rounded-2xl"
                        >
                            Reset
                        </button>
                        <button 
                            @click="openPrintModal(table)"
                            class="py-4 bg-blue-600 text-white text-[10px] font-black uppercase tracking-widest hover:bg-blue-700 transition-all active:scale-95 rounded-2xl shadow-lg shadow-blue-600/20"
                        >
                            Print
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modals -->
        <!-- Category Modal -->
        <div v-if="isCategoryModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-4 lg:p-6">
            <div class="bg-white border border-slate-200 rounded-[32px] lg:rounded-[48px] w-full max-w-md p-8 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-200">
                <h3 class="text-3xl font-black text-slate-900 tracking-tighter mb-10">{{ selectedItem ? 'Perbarui' : 'Tambah' }} Kategori</h3>
                <form @submit.prevent="submitCategory" class="space-y-8">
                    <div class="space-y-3">
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] ml-2">Nama Kategori</label>
                        <input v-model="categoryForm.name" type="text" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-6 font-bold text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50" placeholder="e.g. Refreshing Drinks" required>
                    </div>
                    <div class="flex gap-4">
                        <button type="button" @click="isCategoryModalOpen = false" class="flex-1 h-16 bg-slate-100 text-slate-400 rounded-3xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">Batal</button>
                        <button type="submit" class="flex-1 h-16 bg-blue-600 text-white rounded-3xl font-black text-xs tracking-widest uppercase shadow-lg shadow-blue-600/20" :disabled="categoryForm.processing">Simpan Data</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Menu Modal -->
        <div v-if="isMenuModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-4 lg:p-6 text-slate-900">
            <div class="bg-white border border-slate-200 rounded-[32px] lg:rounded-[48px] w-full max-w-lg p-8 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-200 overflow-y-auto max-h-[90vh]">
                <h3 class="text-3xl font-black text-slate-900 tracking-tighter mb-10">{{ selectedItem ? 'Perbarui' : 'Tambah' }} Menu</h3>
                <form @submit.prevent="submitMenu" class="space-y-6">
                    <div class="grid grid-cols-2 gap-6">
                        <div class="col-span-2 space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Category</label>
                            <select v-model="menuForm.category_id" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-2xl px-6 font-bold text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50 appearance-none" required>
                                <option value="" disabled>Pilih Kategori</option>
                                <option v-for="cat in categories" :key="cat.id" :value="cat.id" class="bg-white">{{ cat.name }}</option>
                            </select>
                        </div>
                        <div class="col-span-2 space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Nama Menu</label>
                            <input v-model="menuForm.name" type="text" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-2xl px-6 font-bold text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50" placeholder="e.g. Espresso Romano" required>
                        </div>
                        <div class="space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Harga (IDR)</label>
                            <input v-model.number="menuForm.price" type="number" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-2xl px-6 font-bold text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50" required>
                        </div>
                        <div class="space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Stok Tersedia</label>
                            <input v-model.number="menuForm.stock" type="number" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-2xl px-6 font-bold text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50" required>
                        </div>
                        <div class="col-span-2 space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Deskripsi</label>
                            <textarea v-model="menuForm.description" class="w-full bg-slate-50 border border-slate-200 rounded-2xl p-6 font-medium text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-600/50" rows="2" placeholder="Tell the story of this dish..."></textarea>
                        </div>
                        <div class="col-span-2 space-y-3">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Foto Menu</label>
                            <input type="file" @input="menuForm.image_file = ($event.target as any).files[0]" class="w-full p-4 bg-slate-50 border border-slate-200 rounded-2xl text-[10px] font-black text-slate-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:bg-blue-600 file:text-white">
                        </div>
                    </div>
                    <div class="flex gap-4 pt-6">
                        <button type="button" @click="isMenuModalOpen = false" class="flex-1 h-16 bg-slate-100 text-slate-400 rounded-3xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">Batal</button>
                        <button type="submit" class="flex-1 h-16 bg-blue-600 text-white rounded-3xl font-black text-xs tracking-widest uppercase shadow-lg shadow-blue-600/20" :disabled="menuForm.processing">Simpan Menu</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- QR Preview & Print Modal -->
        <div v-if="isQRModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-6 no-print">
            <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-sm p-12 shadow-2xl animate-in zoom-in-95 duration-200 text-center">
                <h3 class="text-2xl font-black text-slate-900 tracking-tighter mb-8 uppercase tracking-widest">Pratinjau QR</h3>
                
                <div class="bg-white p-6 border border-slate-100 rounded-[40px] inline-block mb-10 shadow-2xl shadow-blue-600/10">
                    <qrcode-vue 
                        :value="getBaseUrl() + '/order/' + tableToPrint.table_number + '?token=' + tableToPrint.qr_code_token" 
                        :size="200" 
                        level="H" 
                        render-as="svg" 
                    />
                </div>

                <h4 class="text-4xl font-black text-slate-900 mb-10 tracking-tighter">MEJA {{ tableToPrint.table_number }}</h4>

                <div class="flex gap-4">
                    <button type="button" @click="isQRModalOpen = false" class="flex-1 h-16 bg-slate-100 text-slate-400 rounded-3xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">Batal</button>
                    <button type="button" @click="triggerPrintQR" class="flex-1 h-16 bg-blue-600 text-white rounded-3xl font-black text-xs tracking-widest uppercase shadow-lg shadow-blue-600/20 flex items-center justify-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                        Cetak QR
                    </button>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
