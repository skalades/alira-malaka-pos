<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';

const props = defineProps<{
    settings: {
        tax_enabled: string;
        tax_percentage: string;
        shop_name: string;
        shop_address: string;
        shop_footer: string;
        loyalty_points_per_10k: string;
        loyalty_point_value: string;
        bank_name: string;
        bank_account_number: string;
        bank_account_name: string;
        reservation_min_dp: string;
        service_charge_enabled: string;
        service_charge_percentage: string;
    }
}>();

const form = useForm({
    tax_enabled: props.settings.tax_enabled,
    tax_percentage: props.settings.tax_percentage,
    shop_name: props.settings.shop_name,
    shop_address: props.settings.shop_address,
    shop_footer: props.settings.shop_footer,
    loyalty_points_per_10k: props.settings.loyalty_points_per_10k,
    loyalty_point_value: props.settings.loyalty_point_value,
    bank_name: props.settings.bank_name,
    bank_account_number: props.settings.bank_account_number,
    bank_account_name: props.settings.bank_account_name,
    reservation_min_dp: props.settings.reservation_min_dp,
    service_charge_enabled: props.settings.service_charge_enabled,
    service_charge_percentage: props.settings.service_charge_percentage,
});

const submit = () => {
    form.post(route('admin.settings.update'), {
        preserveScroll: true,
    });
};
</script>

<template>
    <Head title="Settings - Admin Alira Malaka" />

    <AuthenticatedLayout>
        <template #header>
            Pengaturan
        </template>

        <div class="max-w-4xl">
            <div class="bg-white border border-slate-200 rounded-[40px] overflow-hidden shadow-sm">
                <div class="p-8 lg:p-12 border-b border-slate-100 bg-slate-50/50">
                    <h3 class="text-2xl font-black text-slate-900 tracking-tighter mb-2 text-blue-600">Pengaturan Pajak (PPN)</h3>
                    <p class="text-slate-500 font-medium text-sm">Konfigurasi bagaimana pajak diterapkan pada pesanan Anda.</p>
                </div>

                <form @submit.prevent="submit" class="p-8 lg:p-12 space-y-10">
                    <!-- Shop Identity Section -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Nama Toko</label>
                            <input 
                                v-model="form.shop_name"
                                type="text" 
                                class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                                placeholder="ALIRA MALAKA"
                            >
                        </div>
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Footer Struk</label>
                            <input 
                                v-model="form.shop_footer"
                                type="text" 
                                class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                                placeholder="Terima Kasih!"
                            >
                        </div>
                    </div>

                    <div class="space-y-4">
                        <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Alamat Toko</label>
                        <textarea 
                            v-model="form.shop_address"
                            rows="2"
                            class="w-full bg-slate-50 border border-slate-200 rounded-3xl px-8 py-4 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                            placeholder="Jl. Malaka No. 123..."
                        ></textarea>
                    </div>

                    <div class="h-[1px] bg-slate-100"></div>

                    <div class="flex items-center justify-between p-6 bg-slate-50 rounded-3xl border border-slate-100">
                        <div class="space-y-1">
                            <label class="font-black text-slate-900 uppercase text-xs tracking-widest">Aktifkan Pajak (PPN)</label>
                            <p class="text-slate-400 text-xs font-bold leading-tight">Saat aktif, pajak akan ditambahkan ke setiap pesanan.</p>
                        </div>
                        <button 
                            type="button"
                            @click="form.tax_enabled = form.tax_enabled === '1' ? '0' : '1'"
                            class="relative inline-flex h-8 w-14 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none"
                            :class="form.tax_enabled === '1' ? 'bg-blue-600' : 'bg-slate-200'"
                        >
                            <span 
                                class="pointer-events-none inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                                :class="form.tax_enabled === '1' ? 'translate-x-6' : 'translate-x-0'"
                            ></span>
                        </button>
                    </div>

                    <div v-if="form.tax_enabled === '1'" class="space-y-4 animate-in slide-in-from-top-4 duration-300">
                        <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Persentase Pajak (%)</label>
                        <div class="relative group">
                            <input 
                                v-model="form.tax_percentage"
                                type="number" 
                                step="0.5"
                                min="0"
                                max="100"
                                class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-xl font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                            >
                            <span class="absolute right-8 top-1/2 -translate-y-1/2 font-black text-slate-400 text-xl">%</span>
                        </div>
                    </div>

                    <div class="h-[1px] bg-slate-100"></div>

                    <div class="flex items-center justify-between p-6 bg-slate-50 rounded-3xl border border-slate-100">
                        <div class="space-y-1">
                            <label class="font-black text-slate-900 uppercase text-xs tracking-widest">Aktifkan Tax Service (Service Charge)</label>
                            <p class="text-slate-400 text-xs font-bold leading-tight">Biaya layanan akan ditambahkan secara otomatis.</p>
                        </div>
                        <button 
                            type="button"
                            @click="form.service_charge_enabled = form.service_charge_enabled === '1' ? '0' : '1'"
                            class="relative inline-flex h-8 w-14 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none"
                            :class="form.service_charge_enabled === '1' ? 'bg-blue-600' : 'bg-slate-200'"
                        >
                            <span 
                                class="pointer-events-none inline-block h-7 w-7 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
                                :class="form.service_charge_enabled === '1' ? 'translate-x-6' : 'translate-x-0'"
                            ></span>
                        </button>
                    </div>

                    <div v-if="form.service_charge_enabled === '1'" class="space-y-4 animate-in slide-in-from-top-4 duration-300">
                        <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Persentase Service Charge (%)</label>
                        <div class="relative group">
                            <input 
                                v-model="form.service_charge_percentage"
                                type="number" 
                                step="0.5"
                                min="0"
                                max="100"
                                class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-xl font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                            >
                            <span class="absolute right-8 top-1/2 -translate-y-1/2 font-black text-slate-400 text-xl">%</span>
                        </div>
                    </div>

                    <div class="h-[1px] bg-slate-100 mt-10"></div>

                    <div class="p-8 lg:p-12 -mx-8 lg:-mx-12 border-b border-slate-100 bg-slate-50/50">
                        <h3 class="text-2xl font-black text-slate-900 tracking-tighter mb-2 text-blue-600">Pengaturan Loyalty Point</h3>
                        <p class="text-slate-500 font-medium text-sm">Konfigurasi bagaimana pelanggan mendapatkan dan menukarkan poin.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Poin per Kelipatan Rp 10.000</label>
                            <input 
                                v-model="form.loyalty_points_per_10k"
                                type="number" 
                                min="0"
                                class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-xl font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                                placeholder="1"
                            >
                        </div>
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Nilai 1 Poin (Rupiah)</label>
                            <div class="relative group">
                                <span class="absolute left-8 top-1/2 -translate-y-1/2 font-black text-slate-400 text-lg">Rp</span>
                                <input 
                                    v-model="form.loyalty_point_value"
                                    type="number" 
                                    min="0"
                                    class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl pl-16 pr-8 text-xl font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all"
                                    placeholder="100"
                                >
                            </div>
                        </div>
                    </div>
    
                    <div class="h-[1px] bg-slate-100 mt-10"></div>

                    <div class="p-8 lg:p-12 -mx-8 lg:-mx-12 border-b border-slate-100 bg-slate-50/50">
                        <h3 class="text-2xl font-black text-slate-900 tracking-tighter mb-2 text-blue-600">Pengaturan Reservasi & DP</h3>
                        <p class="text-slate-500 font-medium text-sm">Konfigurasi info rekening bank untuk pembayaran DP reservasi.</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Nama Bank</label>
                            <input v-model="form.bank_name" type="text" placeholder="Contoh: BCA / Mandiri" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all">
                        </div>
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Atas Nama (Rekening)</label>
                            <input v-model="form.bank_account_name" type="text" placeholder="Contoh: PT Alira Malaka" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all">
                        </div>
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Nomor Rekening</label>
                            <input v-model="form.bank_account_number" type="text" placeholder="000000000" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl px-8 text-lg font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all">
                        </div>
                        <div class="space-y-4">
                            <label class="block font-black text-slate-400 uppercase text-[10px] tracking-[0.2em] ml-4">Minimal DP Reservasi</label>
                            <div class="relative group">
                                <span class="absolute left-8 top-1/2 -translate-y-1/2 font-black text-slate-400 text-lg">Rp</span>
                                <input v-model="form.reservation_min_dp" type="number" class="w-full h-16 bg-slate-50 border border-slate-200 rounded-3xl pl-16 pr-8 text-xl font-black text-slate-900 focus:outline-none focus:ring-4 focus:ring-blue-600/10 transition-all">
                            </div>
                        </div>
                    </div>

                    <div class="flex justify-end pt-6">
                        <button 
                            type="submit"
                            :disabled="form.processing"
                            class="px-10 h-16 bg-blue-600 text-white rounded-3xl font-black uppercase text-xs tracking-[0.2em] shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:bg-slate-100 disabled:text-slate-300 disabled:shadow-none transition-all active:scale-95"
                        >
                            Simpan Pengaturan
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
