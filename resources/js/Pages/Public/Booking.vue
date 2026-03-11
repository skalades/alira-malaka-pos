<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps<{
    tables: any[];
    categories: any[];
    menus: any[];
    bankSettings: {
        bank_name: string;
        bank_account_number: string;
        bank_account_name: string;
        min_dp: string;
    };
    taxSettings: {
        enabled: boolean;
        percentage: number;
    };
    serviceChargeSettings: {
        enabled: boolean;
        percentage: number;
    };
}>();

import { computed } from 'vue';

const selectedCategoryId = ref<number | null>(null);
const searchQuery = ref('');
const cart = ref<any[]>([]);
const isVariantModalOpen = ref(false);
const isCustomModalOpen = ref(false);
const selectedMenuForVariant = ref<any>(null);
const selectedMenuForCustom = ref<any>(null);
const selectedRice = ref('');
const selectedSambal = ref('');

const riceOptions = ['Nasi Merah', 'Nasi Timbel', 'Nasi Cikur'];
const sambalOptions = ['Sambel Goang', 'Sambel Dadak'];

const filteredMenus = computed(() => {
    return props.menus.filter(m => {
        const matchesCategory = !selectedCategoryId.value || m.category_id === selectedCategoryId.value;
        const matchesSearch = !searchQuery.value || m.name.toLowerCase().includes(searchQuery.value.toLowerCase());
        return matchesCategory && matchesSearch;
    });
});

const handleMenuClick = (menu: any) => {
    if (menu.variants && menu.variants.length > 0) {
        selectedMenuForVariant.value = menu;
        isVariantModalOpen.value = true;
        return;
    }

    const isKumplit = menu.name.toLowerCase().includes('kumplit');
    const isPaket = menu.name.toLowerCase().includes('paket');
    
    if (isKumplit || isPaket) {
        selectedMenuForCustom.value = menu;
        selectedRice.value = '';
        selectedSambal.value = '';
        isCustomModalOpen.value = true;
    } else {
        addToCart(menu);
    }
};

const selectVariant = (variant: any) => {
    if (!selectedMenuForVariant.value) return;
    
    const menu = selectedMenuForVariant.value;
    const isKumplit = menu.name.toLowerCase().includes('kumplit');
    const isPaket = menu.name.toLowerCase().includes('paket');

    if (isKumplit || isPaket) {
        selectedMenuForCustom.value = { ...menu, selected_variant: variant };
        selectedRice.value = '';
        selectedSambal.value = '';
        isVariantModalOpen.value = false;
        isCustomModalOpen.value = true;
    } else {
        addToCart(menu, variant);
        isVariantModalOpen.value = false;
        selectedMenuForVariant.value = null;
    }
};

const confirmCustomization = () => {
    if (!selectedMenuForCustom.value) return;
    
    let parts = [];
    if (selectedRice.value) parts.push(selectedRice.value);
    if (selectedSambal.value) parts.push(selectedSambal.value);
    
    const variant = (selectedMenuForCustom.value as any).selected_variant || null;
    addToCart(selectedMenuForCustom.value, variant, parts.join(', '));
    
    isCustomModalOpen.value = false;
    selectedMenuForCustom.value = null;
};

const addToCart = (menu: any, variant: any = null, initialNotes: string = '') => {
    const variantId = variant?.id || null;
    
    const existing = cart.value.find(i => i.id === menu.id && i.variant_id === variantId && i.notes === initialNotes);
    if (existing) {
        existing.quantity++;
    } else {
        cart.value.push({ 
            ...menu, 
            variant_id: variantId,
            variant_name: variant?.name || null,
            price: variant ? variant.price : menu.price,
            quantity: 1, 
            notes: initialNotes 
        });
    }
    isVariantModalOpen.value = false;
    selectedMenuForVariant.value = null;
};

const removeFromCart = (menuId: number, variantId: number | null = null) => {
    const index = cart.value.findIndex(i => i.id === menuId && i.variant_id === variantId);
    if (index > -1) {
        if (cart.value[index].quantity > 1) {
            cart.value[index].quantity--;
        } else {
            cart.value.splice(index, 1);
        }
    }
};

const cartTotal = computed(() => cart.value.reduce((sum, i) => sum + (Number(i.price) * i.quantity), 0));
const cartCount = computed(() => cart.value.reduce((sum, i) => sum + i.quantity, 0));

const grandTotal = computed(() => {
    const total = cartTotal.value;
    const service = props.serviceChargeSettings.enabled ? (total * props.serviceChargeSettings.percentage / 100) : 0;
    const tax = props.taxSettings.enabled ? (total * props.taxSettings.percentage / 100) : 0;
    return Math.round(total + service + tax);
});

const form = useForm({
    name: '',
    phone: '',
    table_id: '',
    reservation_time: '',
    num_people: 1,
    notes: '',
    transfer_proof: null as any,
    items: [] as any[],
});

const isSubmitted = ref(false);
const activeStep = ref(1); // 1: Form, 2: Payment
const reservationId = ref<number | null>(null);

const submit = () => {
    form.items = cart.value.map(i => ({
        id: i.id,
        variant_id: i.variant_id,
        quantity: i.quantity,
        notes: i.notes
    }));
    
    form.post(route('booking.store'), {
        forceFormData: true,
        onSuccess: (page) => {
            isSubmitted.value = true;
            activeStep.value = 1;
            reservationId.value = (page.props as any).flash.reservation?.id || null;
            form.reset();
            cart.value = [];
        },
        onError: (errors) => {
            console.error('Validation errors:', errors);
            // Alert user about the error
            if (errors.transfer_proof) {
                alert('Gagal mengupload bukti transfer: ' + errors.transfer_proof);
            } else {
                alert('Terdapat kesalahan pada isian form Anda. Mohon periksa kembali.');
            }
        }
    });
};

const handleFile = (e: any) => {
    form.transfer_proof = e.target.files[0];
};

const formattedReservationTime = computed(() => {
    if (!form.reservation_time) return 'Belum dipilih';
    try {
        const date = new Date(form.reservation_time);
        return new Intl.DateTimeFormat('id-ID', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
        }).format(date) + ' WIB';
    } catch (e) {
        return form.reservation_time;
    }
});

const downloadReceipt = () => {
    if (reservationId.value) {
        window.location.href = route('booking.receipt', reservationId.value);
    }
};
</script>

<template>
    <Head title="Reservasi Meja - Alira Malaka" />

    <div class="min-h-screen bg-slate-50 font-sans selection:bg-blue-600 selection:text-white p-6 md:p-12 flex items-center justify-center">
        <div class="w-full max-w-2xl">
            <!-- Logo -->
            <div class="flex flex-col items-center mb-12">
                <div class="h-16 w-16 bg-blue-600 rounded-[28px] flex items-center justify-center shadow-2xl shadow-blue-600/20 mb-6 animate-bounce">
                    <span class="text-3xl font-black text-white">A</span>
                </div>
                <h1 class="text-3xl font-black text-slate-900 tracking-tighter">ALIRA MALAKA</h1>
                <p class="text-[10px] text-blue-600 font-black uppercase tracking-[0.3em] mt-1">Sistem Reservasi Online</p>
            </div>

            <!-- Success State -->
            <div v-if="isSubmitted" class="bg-white rounded-[48px] p-12 shadow-2xl shadow-slate-200/50 border border-slate-100 text-center space-y-6 animate-in fade-in zoom-in duration-500">
                <div class="w-20 h-20 bg-green-50 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                </div>
                <h2 class="text-2xl font-black text-slate-900">Reservasi Terkirim!</h2>
                <p class="text-slate-500 font-medium leading-relaxed">Terima kasih telah melakukan reservasi. Tim kami akan segera memproses booking Anda. Silakan unduh struk di bawah sebagai bukti reservasi.</p>
                <div class="flex flex-col gap-4">
                    <button @click="downloadReceipt" class="w-full h-16 bg-blue-600 text-white rounded-3xl font-black uppercase text-xs tracking-widest hover:bg-blue-700 transition-all flex items-center justify-center gap-3">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                        Unduh Struk PDF
                    </button>
                    <button @click="isSubmitted = false" class="w-full h-16 bg-slate-100 text-slate-600 rounded-3xl font-black uppercase text-xs tracking-widest hover:bg-slate-200 transition-all">
                        Buat Reservasi Baru
                    </button>
                </div>
            </div>

            <!-- Form State -->
            <div v-else class="bg-white rounded-[48px] p-8 md:p-12 shadow-2xl shadow-slate-200/50 border border-slate-100 space-y-10 animate-in fade-in slide-in-from-bottom-8 duration-700">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 tracking-tight">Booking Meja Anda</h2>
                    <p class="text-sm text-slate-400 font-bold mt-1">Silakan isi formulir di bawah ini dengan lengkap.</p>
                </div>

                <form @submit.prevent="submit" class="grid grid-cols-1 md:grid-cols-2 gap-8 text-left">
                    <template v-if="activeStep === 1">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nama Lengkap</label>
                        <input v-model="form.name" type="text" required placeholder="Contoh: Budi Santoso" class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold h-16 px-6 transition-all placeholder:text-slate-300">
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Nomor Handphone (WhatsApp)</label>
                        <input v-model="form.phone" type="tel" required placeholder="0812xxxxxx" class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold h-16 px-6 transition-all placeholder:text-slate-300">
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Pilih Meja</label>
                        <select v-model="form.table_id" required class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold h-16 px-6 transition-all">
                            <option value="">Pilih Meja Favorit</option>
                            <option v-for="t in tables" :key="t.id" :value="t.id">MEJA {{ t.table_number }}</option>
                        </select>
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Jumlah Orang (Pax)</label>
                        <input v-model="form.num_people" type="number" min="1" required class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold h-16 px-6 transition-all">
                    </div>
                    <div class="space-y-2 md:col-span-2">
                        <div class="flex justify-between items-end ml-1">
                            <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest">Waktu Kedatangan</label>
                            <span class="text-[10px] font-black text-blue-600 uppercase">{{ formattedReservationTime }}</span>
                        </div>
                        <input v-model="form.reservation_time" type="datetime-local" required class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold h-16 px-6 transition-all">
                    </div>
                    <div class="space-y-4 md:col-span-2">
                        <label class="text-[10px] font-black uppercase text-slate-400 tracking-widest ml-1">Catatan Tambahan (Opsional)</label>
                        <textarea v-model="form.notes" rows="2" placeholder="Contoh: Dekat jendela, Kursi bayi, Rayakan ulang tahun..." class="block w-full rounded-3xl border-slate-100 bg-slate-50/50 focus:bg-white focus:border-blue-600 focus:ring-blue-600 font-bold p-6 transition-all placeholder:text-slate-300"></textarea>
                    </div>

                    <!-- Menu Selection -->
                    <div class="md:col-span-2 space-y-6 pt-4">
                        <div class="flex items-center justify-between">
                            <h3 class="text-xl font-black text-slate-900 tracking-tight uppercase">Pilih Menu (Pre-order)</h3>
                            <span class="bg-blue-50 text-blue-600 px-4 py-2 rounded-full text-[10px] font-black">OPSIONAL</span>
                        </div>
                        
                        <div class="space-y-4">
                            <!-- Categories & Search -->
                            <div class="flex flex-col gap-4">
                                <div class="flex gap-2 overflow-x-auto pb-2 custom-scrollbar">
                                    <button 
                                        type="button"
                                        @click="selectedCategoryId = null"
                                        class="px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest transition-all whitespace-nowrap"
                                        :class="!selectedCategoryId ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'"
                                    >
                                        Semua
                                    </button>
                                    <button 
                                        v-for="cat in categories" 
                                        :key="cat.id"
                                        type="button"
                                        @click="selectedCategoryId = cat.id"
                                        class="px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest transition-all whitespace-nowrap"
                                        :class="selectedCategoryId === cat.id ? 'bg-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'"
                                    >
                                        {{ cat.name }}
                                    </button>
                                </div>
                                <div class="relative">
                                    <svg class="absolute left-6 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                    <input v-model="searchQuery" type="text" placeholder="Cari menu favorit..." class="w-full bg-slate-50 border-slate-100 rounded-3xl py-4 pl-14 pr-6 text-sm font-bold focus:bg-white focus:border-blue-600 transition-all outline-none">
                                </div>
                            </div>

                            <!-- Menu Grid -->
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
                                <div v-for="menu in filteredMenus" :key="menu.id" class="bg-slate-50/50 border border-slate-100 p-6 rounded-[32px] flex items-center gap-6 group hover:bg-white hover:border-blue-200 transition-all">
                                    <div class="flex-1 min-w-0">
                                        <p class="font-black text-slate-900 truncate text-base">{{ menu.name }}</p>
                                        <div class="flex items-center gap-3 mt-1">
                                            <p class="text-blue-600 font-black text-sm">Rp {{ Number(menu.price).toLocaleString('id-ID') }}</p>
                                            <span class="w-1 h-1 bg-slate-200 rounded-full"></span>
                                            <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest">{{ menu.category?.name || 'Menu' }}</p>
                                        </div>
                                    </div>
                                    <button 
                                        type="button" 
                                        @click="handleMenuClick(menu)"
                                        class="w-12 h-12 bg-white border border-slate-100 rounded-2xl flex items-center justify-center text-blue-600 hover:bg-blue-600 hover:text-white transition-all shadow-sm active:scale-90"
                                    >
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"></path></svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Cart Summary -->
                            <div v-if="cart.length > 0" class="bg-blue-600 rounded-[32px] p-8 text-white space-y-6 shadow-2xl shadow-blue-600/30">
                                <div class="flex items-center justify-between border-b border-white/10 pb-4">
                                    <h4 class="font-black uppercase text-xs tracking-[0.2em]">Ringkasan Pre-order</h4>
                                    <span class="bg-white/20 px-3 py-1 rounded-full text-[10px] font-black">{{ cartCount }} Item</span>
                                </div>
                                <div class="space-y-4 max-h-[200px] overflow-y-auto pr-2 custom-scrollbar">
                                    <div v-for="item in cart" :key="item.id + (item.variant_id || '')" class="flex items-center justify-between gap-4">
                                        <div class="flex-1 min-w-0">
                                            <p class="font-black text-sm truncate">
                                                {{ item.name }}
                                                <span v-if="item.variant_name" class="text-[10px] text-blue-200 ml-1">({{ item.variant_name }})</span>
                                            </p>
                                            <div class="flex items-center gap-4 mt-1">
                                                <p class="text-[10px] font-bold text-blue-200">Rp {{ (Number(item.price) * item.quantity).toLocaleString('id-ID') }}</p>
                                                <input v-model="item.notes" type="text" placeholder="Catatan..." class="bg-white/10 border-0 rounded-lg text-[10px] px-2 py-1 placeholder:text-white/30 focus:bg-white/20 outline-none flex-1">
                                            </div>
                                        </div>
                                        <div class="flex items-center gap-3">
                                            <button type="button" @click="removeFromCart(item.id, item.variant_id)" class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center hover:bg-white/20 transition-all">-</button>
                                            <span class="font-black text-sm w-4 text-center">{{ item.quantity }}</span>
                                            <button type="button" @click="addToCart(item, { id: item.variant_id, name: item.variant_name, price: item.price })" class="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center hover:bg-white/20 transition-all">+</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-y-2 pt-4 border-t border-white/10">
                                    <div class="flex justify-between items-center opacity-60">
                                        <p class="text-[10px] font-black uppercase tracking-[0.2em]">Subtotal Pesanan</p>
                                        <p class="font-bold">Rp {{ Number(cartTotal).toLocaleString('id-ID') }}</p>
                                    </div>
                                    <div v-if="props.serviceChargeSettings.enabled" class="flex justify-between items-center text-amber-200">
                                        <p class="text-[10px] font-black uppercase tracking-[0.2em]">Tax Service ({{ props.serviceChargeSettings.percentage }}%)</p>
                                        <p class="font-bold text-sm">Rp {{ Math.round(cartTotal * props.serviceChargeSettings.percentage / 100).toLocaleString('id-ID') }}</p>
                                    </div>
                                    <div v-if="props.taxSettings.enabled" class="flex justify-between items-center text-blue-200">
                                        <p class="text-[10px] font-black uppercase tracking-[0.2em]">PPN ({{ props.taxSettings.percentage }}%)</p>
                                        <p class="font-bold text-sm">Rp {{ Math.round(cartTotal * props.taxSettings.percentage / 100).toLocaleString('id-ID') }}</p>
                                    </div>
                                    <div class="flex justify-between items-end pt-2">
                                        <p class="text-[10px] font-black uppercase tracking-[0.2em]">Total Pre-order</p>
                                        <p class="text-2xl font-black tracking-tighter">
                                            Rp {{ 
                                                Math.round(cartTotal + 
                                                (props.serviceChargeSettings.enabled ? (cartTotal * props.serviceChargeSettings.percentage / 100) : 0) +
                                                (props.taxSettings.enabled ? (cartTotal * props.taxSettings.percentage / 100) : 0)).toLocaleString('id-ID') 
                                            }}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        <div class="md:col-span-2 pt-6 border-t border-slate-100 space-y-4">
                            <!-- Min Spend Warning -->
                            <div v-if="cart.length > 0 && grandTotal < Number(props.bankSettings.min_dp)" class="bg-rose-50 border border-rose-100 p-4 rounded-2xl flex items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-300">
                                <div class="h-10 w-10 bg-rose-500 rounded-xl flex items-center justify-center shrink-0 shadow-lg shadow-rose-500/20">
                                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                                </div>
                                <div>
                                    <p class="text-[10px] font-black text-rose-900 uppercase tracking-widest">Pesanan Belum Mencukupi</p>
                                    <p class="text-xs font-bold text-rose-600 mt-0.5">Minimal pesanan untuk booking adalah Rp {{ Number(props.bankSettings.min_dp).toLocaleString('id-ID') }}. Silakan tambahkan menu lagi.</p>
                                </div>
                            </div>

                            <button 
                                type="button" 
                                @click="activeStep = 2"
                                :disabled="!form.name || !form.phone || !form.table_id || !form.reservation_time || cart.length === 0 || grandTotal < Number(props.bankSettings.min_dp)"
                                class="w-full h-20 bg-blue-600 text-white rounded-[32px] font-black uppercase text-sm tracking-widest hover:bg-blue-700 transition-all shadow-2xl shadow-blue-600/30 flex items-center justify-center gap-4 group disabled:bg-slate-200 disabled:text-slate-400 disabled:shadow-none"
                            >
                                <span>PESAN MEJA SEKARANG</span>
                                <svg class="w-6 h-6 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M13 7l5 5m0 0l-5 5m5-5H6"></path></svg>
                            </button>
                        </div>
                    </template>

                    <template v-else-if="activeStep === 2">
                        <!-- Redesigned DP Section -->

                    <div class="md:col-span-2 p-8 bg-blue-50/50 rounded-[32px] border-2 border-blue-600/20 space-y-6 shadow-xl shadow-blue-600/5 relative overflow-hidden">
                        <div class="absolute -right-12 -top-12 w-32 h-32 bg-blue-600/5 rounded-full blur-2xl"></div>
                        
                        <div class="flex items-center gap-4 relative z-10">
                            <div class="h-12 w-12 bg-blue-600 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-600/20">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7h-4v4h4V7z"></path></svg>
                            </div>
                            <div>
                                <h3 class="font-black text-blue-900 uppercase text-xs tracking-[0.2em]">Konfirmasi Pembayaran DP</h3>
                                <p class="text-[10px] text-blue-600 font-bold uppercase mt-0.5">Minimal Transfer: Rp {{ Number(props.bankSettings.min_dp).toLocaleString('id-ID') }}</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 p-6 bg-white/50 rounded-3xl border border-blue-100 relative z-10">
                            <div class="space-y-1">
                                <p class="text-[9px] font-black text-blue-400 uppercase tracking-widest">Nama Bank</p>
                                <p class="text-lg font-black text-slate-900">{{ props.bankSettings.bank_name || 'BELUM DIATUR' }}</p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-[9px] font-black text-blue-400 uppercase tracking-widest">Nomor Rekening</p>
                                <p class="text-xl font-black text-slate-900 tracking-tighter">{{ props.bankSettings.bank_account_number || '-' }}</p>
                            </div>
                            <div class="space-y-1 sm:col-span-2 pt-2 border-t border-blue-50">
                                <p class="text-[9px] font-black text-blue-400 uppercase tracking-widest">Atas Nama</p>
                                <p class="font-black text-slate-900 uppercase">{{ props.bankSettings.bank_account_name || '-' }}</p>
                            </div>
                        </div>
                        
                        <div class="pt-2 relative z-10">
                            <label class="text-[10px] font-black uppercase text-blue-400 tracking-widest block mb-4 ml-1">Upload Bukti Transfer (WAJIB)</label>
                            <label class="relative flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-blue-200 rounded-[28px] bg-white hover:border-blue-600 transition-all cursor-pointer group">
                                <div class="flex flex-col items-center justify-center pt-5 pb-6">
                                    <svg class="w-8 h-8 mb-3 text-blue-400 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path></svg>
                                    <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest">{{ form.transfer_proof ? form.transfer_proof.name : 'Klik untuk Pilih File Gambar' }}</p>
                                </div>
                                <input @change="handleFile" type="file" accept="image/*" class="hidden">
                            </label>
                        </div>
                    </div>
                    
                    
                        <div class="md:col-span-2 flex flex-col gap-4 pt-4">
                            <button type="submit" :disabled="form.processing || !form.transfer_proof" class="w-full h-20 bg-blue-600 text-white rounded-[32px] font-black uppercase text-sm tracking-widest hover:bg-blue-700 transition-all shadow-2xl shadow-blue-600/30 flex items-center justify-center gap-4 group disabled:bg-slate-200 disabled:text-slate-400 disabled:shadow-none">
                                <span v-if="form.processing">MENGIRIM...</span>
                                <span v-else>KONFIRMASI & SELESAI</span>
                                <svg v-if="!form.processing" class="w-6 h-6 group-hover:translate-x-2 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M13 7l5 5m0 0l-5 5m5-5H6"></path></svg>
                            </button>
                            <button type="button" @click="activeStep = 1" :disabled="form.processing" class="w-full h-14 bg-slate-100 text-slate-500 rounded-[24px] font-black uppercase text-[10px] tracking-widest hover:bg-slate-200 transition-all">
                                KEMBALI KE DATA PESANAN
                            </button>
                        </div>
                    </template>
                </form>
            </div>
            
            <!-- Variant Modal for Public -->
            <div v-if="isVariantModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-6 text-slate-900">
                <div class="bg-white border-slate-200 rounded-[48px] w-full max-w-sm p-10 shadow-2xl animate-in zoom-in-95 duration-300">
                    <div class="text-center mb-8">
                        <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest mb-2">Pilih Varian</p>
                        <h4 class="text-2xl font-black text-slate-900 tracking-tighter">{{ selectedMenuForVariant?.name }}</h4>
                    </div>
                    
                    <div class="space-y-3">
                        <button 
                            v-for="v in selectedMenuForVariant?.variants" 
                            :key="v.id"
                            @click="selectVariant(v)"
                            class="w-full h-16 px-6 rounded-2xl bg-slate-50 border-2 border-transparent hover:border-blue-600 hover:bg-white flex items-center justify-between transition-all group"
                        >
                            <span class="font-bold text-slate-900 group-hover:text-blue-600">{{ v.name }}</span>
                            <span class="font-black text-blue-600">Rp {{ Number(v.price).toLocaleString('id-ID') }}</span>
                        </button>
                    </div>
                    
                    <button @click="isVariantModalOpen = false; selectedMenuForVariant = null" class="w-full mt-6 text-slate-400 font-black text-[10px] uppercase tracking-widest">Batal</button>
                </div>
            </div>

            <!-- Customization Modal (Rice & Sambal) -->
            <div v-if="isCustomModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[110] flex items-center justify-center p-6 text-slate-900 leading-normal">
                <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-md overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
                    <div class="p-10 border-b border-slate-100 text-center">
                        <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-2">Pilihan Menu</p>
                        <h4 class="text-2xl font-black text-slate-900 tracking-tighter">{{ selectedMenuForCustom?.name }}</h4>
                    </div>

                    <div class="flex-1 overflow-y-auto p-10 space-y-10 custom-scrollbar">
                        <!-- Rice Options -->
                        <div class="space-y-4 text-left">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">PILIHAN NASI (Boleh Kosong)</label>
                            <div class="grid grid-cols-1 gap-2">
                                <button 
                                    v-for="opt in riceOptions" 
                                    :key="opt"
                                    type="button"
                                    @click="selectedRice = selectedRice === opt ? '' : opt"
                                    class="h-16 px-8 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                    :class="selectedRice === opt ? 'bg-blue-600 border-blue-600 text-white shadow-xl shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600 text-left'"
                                >
                                    {{ opt }}
                                    <div v-show="selectedRice === opt" class="w-2 h-2 rounded-full bg-white"></div>
                                </button>
                            </div>
                        </div>

                        <!-- Sambal Options -->
                        <div class="space-y-4 text-left">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">PILIHAN SAMBAL (Boleh Kosong)</label>
                            <div class="grid grid-cols-1 gap-2">
                                <button 
                                    v-for="opt in sambalOptions" 
                                    :key="opt"
                                    type="button"
                                    @click="selectedSambal = selectedSambal === opt ? '' : opt"
                                    class="h-16 px-8 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                    :class="selectedSambal === opt ? 'bg-blue-600 border-blue-600 text-white shadow-xl shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600 text-left'"
                                >
                                    {{ opt }}
                                    <div v-show="selectedSambal === opt" class="w-2 h-2 rounded-full bg-white"></div>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="p-10 bg-slate-50 border-t border-slate-100 flex flex-col gap-4">
                        <button 
                            type="button"
                            @click="confirmCustomization"
                            class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-[0.98]"
                        >
                            Konfirmasi
                        </button>
                        <button @click="isCustomModalOpen = false; selectedMenuForCustom = null" class="w-full text-slate-400 font-black text-[10px] uppercase tracking-widest">Batal</button>
                    </div>
                </div>
            </div>
            
            <p class="text-center mt-12 text-slate-400 text-[10px] font-black uppercase tracking-widest">© 2026 Alira Malaka POS System. All Rights Reserved.</p>
        </div>
    </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap');

body {
    font-family: 'Outfit', sans-serif;
}
</style>
