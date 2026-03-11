<script setup lang="ts">
import CustomerLayout from '@/Layouts/CustomerLayout.vue';
import { useCartStore } from '@/Stores/cart';
import { router, Head, usePage } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps<{
    table: any;
    categories: any[];
    menus: any[];
    selectedCategory?: string;
}>();

const cart = useCartStore();
const isCartOpen = ref(false);

const selectCategory = (slug?: string) => {
    router.visit(route('order.index', { 
        table_number: props.table.table_number,
        token: props.table.qr_code_token,
        category: slug 
    }), { preserveState: true, preserveScroll: true });
};

const page = usePage();

const submitOrder = () => {
    if (cart.items.length === 0) return;

    router.post(route('order.checkout'), {
        table_id: props.table.id,
        items: cart.items.map(item => ({
            id: item.id,
            quantity: item.quantity,
            notes: item.notes
        })),
        type: 'dine_in'
    }, {
        onSuccess: () => {
            cart.clearCart();
            isCartOpen.value = false;
        },
        onError: (errors) => {
            console.error(errors);
        }
    });
};

const getMenuQuantity = (menuId: number) => {
    return cart.items
        .filter(item => item.id === menuId)
        .reduce((sum, item) => sum + item.quantity, 0);
};

const cartCount = computed(() => cart.items.reduce((sum, i) => sum + i.quantity, 0));

// Customization Modal State
const showCustomModal = ref(false);
const selectedMenuForCustom = ref<any>(null);
const selectedRice = ref('');
const selectedSambal = ref('');

const riceOptions = ['Nasi Merah', 'Nasi Timbel', 'Nasi Cikur'];
const sambalOptions = ['Sambel Goang', 'Sambel Dadak'];

const openCustomModal = (menu: any) => {
    selectedMenuForCustom.value = menu;
    selectedRice.value = '';
    selectedSambal.value = '';
    showCustomModal.value = true;
};

const confirmCustomization = () => {
    if (!selectedMenuForCustom.value) return;
    
    let parts = [];
    if (selectedRice.value) parts.push(selectedRice.value);
    if (selectedSambal.value) parts.push(selectedSambal.value);
    
    const notes = parts.join(', ');
    cart.addItem(selectedMenuForCustom.value, notes);
    
    showCustomModal.value = false;
    selectedMenuForCustom.value = null;
};

const handleAddItem = (menu: any) => {
    const isKumplit = menu.name.toLowerCase().includes('kumplit');
    const isPaket = menu.name.toLowerCase().includes('paket');
    
    if (isKumplit || isPaket) {
        openCustomModal(menu);
    } else {
        cart.addItem(menu);
    }
};
</script>

<template>
    <CustomerLayout 
        :title="`Table ${table.table_number} - Alira Malaka`"
        :show-cart-button="true"
        :cart-count="cartCount"
        @toggle-cart="isCartOpen = !isCartOpen"
    >
        <div class="mb-10">
            <!-- Header Info -->
            <div class="space-y-2">
                <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em]">Welcome To</p>
                <div class="flex items-baseline gap-2 lg:gap-3">
                    <h2 class="text-3xl lg:text-4xl font-black text-slate-900 tracking-tighter">Table {{ table.table_number }}</h2>
                    <div class="h-1.5 w-1.5 rounded-full bg-green-500 animate-pulse"></div>
                </div>
            </div>
        </div>

        <!-- Categories (Sticky at very top) -->
        <div class="sticky -top-[1px] z-40 -mx-6 px-6 bg-slate-50/95 backdrop-blur-xl py-4 border-b border-slate-200 transition-all shadow-sm mb-10" id="category-sticky">
            <div class="flex gap-3 overflow-x-auto no-scrollbar">
                <button 
                    @click="selectCategory()"
                    class="h-12 px-6 rounded-2xl font-black text-[10px] uppercase tracking-widest transition-all whitespace-nowrap border"
                    :class="!selectedCategory ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-100 text-slate-400 border-slate-100'"
                >
                    All Flavors
                </button>
                <button 
                    v-for="cat in categories" 
                    :key="cat.id"
                    @click="selectCategory(cat.slug)"
                    class="h-12 px-6 rounded-2xl font-black text-[10px] uppercase tracking-widest transition-all whitespace-nowrap border"
                    :class="selectedCategory === cat.slug ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-100 text-slate-400 border-slate-100'"
                >
                    {{ cat.name }}
                </button>
            </div>
        </div>

                <div v-for="menu in menus" :key="menu.id" class="group relative bg-white border border-slate-200 rounded-[32px] lg:rounded-[40px] p-2 flex items-center hover:shadow-xl hover:shadow-blue-600/5 transition-all">
                    <!-- No Images or Icons - Text Only Layout -->
                    <div class="flex-1 min-w-0 py-4 px-4 lg:py-6 lg:px-8">
                        <div class="flex justify-between items-start mb-2 lg:mb-3">
                            <div class="min-w-0">
                                <h3 class="font-black text-slate-900 text-lg lg:text-xl tracking-tight leading-tight mb-1">{{ menu.name }}</h3>
                                <p v-if="menu.description" class="text-[10px] lg:text-xs text-slate-400 font-medium leading-relaxed line-clamp-2 max-w-md">
                                    {{ menu.description }}
                                </p>
                            </div>
                            <p class="text-blue-600 font-black text-lg lg:text-xl whitespace-nowrap ml-4">Rp {{ Number(menu.price).toLocaleString('id-ID') }}</p>
                        </div>
                        
                        <div class="flex justify-between items-center mt-4">
                            <!-- Badge for Quantity if active -->
                            <div v-if="getMenuQuantity(menu.id) > 0" class="flex items-center gap-2">
                                <span class="px-3 py-1 bg-blue-600 text-white text-[10px] font-black rounded-full uppercase tracking-widest shadow-lg shadow-blue-600/20 animate-in zoom-in duration-300">
                                    {{ getMenuQuantity(menu.id) }} In Bag
                                </span>
                            </div>
                            <div v-else></div>

                            <div class="flex items-center h-10">
                                <!-- Horizontal Quantity Controls -->
                                <div v-if="getMenuQuantity(menu.id) > 0" class="flex items-center bg-slate-50 rounded-xl border border-slate-100 p-1 animate-in fade-in zoom-in duration-300">
                                    <button 
                                        @click="cart.removeItem(menu.id)"
                                        class="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-red-500 transition-colors font-black text-xl"
                                    >
                                        -
                                    </button>
                                    <span class="w-8 text-center font-black text-sm text-slate-900">{{ getMenuQuantity(menu.id) }}</span>
                                    <button 
                                        @click="handleAddItem(menu)"
                                        class="w-10 h-10 flex items-center justify-center text-slate-400 hover:text-blue-600 transition-colors font-black text-xl"
                                    >
                                        +
                                    </button>
                                </div>

                                <!-- Add To Bag Button -->
                                <button 
                                    v-else
                                    @click="handleAddItem(menu)"
                                    class="h-10 px-8 bg-slate-100 border border-slate-200 rounded-2xl font-black text-[10px] uppercase tracking-widest text-slate-600 hover:bg-blue-600 hover:text-white hover:border-blue-600 transition-all active:scale-95 shadow-sm"
                                >
                                    Add To Bag
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

        <!-- Customization Modal -->
        <Transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="opacity-100"
            leave-to-class="opacity-0"
        >
            <div v-if="showCustomModal" class="fixed inset-0 z-[120] flex items-center justify-center p-6">
                <div @click="showCustomModal = false" class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>
                
                <div class="relative bg-white border border-slate-200 rounded-[40px] w-full max-w-sm overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
                    <!-- Header -->
                    <div class="p-8 border-b border-slate-100 text-center">
                        <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-2">Pilihan Menu</p>
                        <h4 class="text-2xl font-black text-slate-900 tracking-tighter">{{ selectedMenuForCustom?.name }}</h4>
                    </div>

                    <div class="flex-1 overflow-y-auto p-8 space-y-8 no-scrollbar">
                        <!-- Rice Options -->
                        <div class="space-y-4">
                            <h5 class="text-[10px] font-black text-slate-400 uppercase tracking-widest">PILIHAN NASI (Boleh Kosong)</h5>
                            <div class="grid grid-cols-1 gap-2">
                                <button 
                                    v-for="opt in riceOptions" 
                                    :key="opt"
                                    @click="selectedRice = selectedRice === opt ? '' : opt"
                                    class="h-14 px-6 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                    :class="selectedRice === opt ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600'"
                                >
                                    {{ opt }}
                                    <div v-show="selectedRice === opt" class="w-2 h-2 rounded-full bg-white"></div>
                                </button>
                            </div>
                        </div>

                        <!-- Sambal Options -->
                        <div class="space-y-4">
                            <h5 class="text-[10px] font-black text-slate-400 uppercase tracking-widest">PILIHAN SAMBAL (Boleh Kosong)</h5>
                            <div class="grid grid-cols-1 gap-2">
                                <button 
                                    v-for="opt in sambalOptions" 
                                    :key="opt"
                                    @click="selectedSambal = selectedSambal === opt ? '' : opt"
                                    class="h-14 px-6 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                    :class="selectedSambal === opt ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600'"
                                >
                                    {{ opt }}
                                    <div v-show="selectedSambal === opt" class="w-2 h-2 rounded-full bg-white"></div>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="p-8 bg-slate-50 border-t border-slate-100">
                        <button 
                            @click="confirmCustomization"
                            class="w-full h-16 bg-blue-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-[0.98]"
                        >
                            Konfirmasi Pesanan
                        </button>
                    </div>
                </div>
            </div>
        </Transition>

        <!-- Cart Sheet (Glassmorphism Bottom Sheet) -->
        <Transition
            enter-active-class="transition duration-500 ease-out"
            enter-from-class="translate-y-full"
            enter-to-class="translate-y-0"
            leave-active-class="transition duration-400 ease-in"
            leave-from-class="translate-y-0"
            leave-to-class="translate-y-full"
        >
            <div v-if="isCartOpen" class="fixed inset-0 z-[100] flex flex-col justify-end">
                <div @click="isCartOpen = false" class="absolute inset-0 bg-slate-900/40 backdrop-blur-md"></div>
                
                <div class="relative bg-white border-t border-slate-200 rounded-t-[40px] lg:rounded-t-[50px] max-w-lg mx-auto w-full h-[85vh] flex flex-col shadow-2xl p-6 lg:p-10">
                    <!-- Handle -->
                    <div class="absolute top-4 left-1/2 -translate-x-1/2 w-12 h-1.5 bg-slate-100 rounded-full"></div>
                    
                    <div class="flex justify-between items-center mb-10 mt-2">
                        <h4 class="text-3xl font-black text-slate-900 tracking-tighter">Your Bag</h4>
                        <span class="px-4 py-1.5 bg-slate-100 rounded-full text-[10px] font-black text-blue-600 uppercase tracking-widest">{{ cartCount }} Items</span>
                    </div>

                    <!-- Cart Items -->
                    <div class="flex-1 overflow-y-auto space-y-8 no-scrollbar pr-2">
                        <div v-if="cart.items.length === 0" class="h-full flex flex-col items-center justify-center text-center py-20 opacity-20">
                            <span class="text-6xl mb-6">🛒</span>
                            <p class="font-black uppercase tracking-[0.2em] text-xs">Hungry? Fill your bag!</p>
                        </div>

                        <div v-for="item in cart.items" :key="item.id" class="space-y-4">
                            <div class="flex items-center gap-6">
                                <div class="flex-1">
                                    <div class="flex justify-between mb-1">
                                        <h5 class="font-black text-slate-900 text-lg">{{ item.name }}</h5>
                                        <p class="font-black text-blue-600 text-lg">Rp {{ (item.price * item.quantity).toLocaleString() }}</p>
                                    </div>
                                    <div class="flex items-center gap-4 mt-3">
                                        <div class="flex items-center bg-slate-50 rounded-xl border border-slate-100 p-1">
                                            <button @click="cart.removeItem(item.id)" class="w-8 h-8 flex items-center justify-center text-slate-400 hover:text-slate-900 transition-colors">-</button>
                                            <span class="w-8 text-center font-black text-xs text-slate-900">{{ item.quantity }}</span>
                                            <button @click="cart.addItem(item)" class="w-8 h-8 flex items-center justify-center text-slate-400 hover:text-slate-900 transition-colors">+</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <textarea 
                                v-model="item.notes"
                                @input="cart.updateItemNote(item.id, (item.notes as string))"
                                placeholder="Any special requests? (e.g. Extra spicy)"
                                class="w-full bg-slate-50 border border-slate-100 rounded-2xl text-[10px] py-4 px-6 text-slate-600 focus:ring-1 focus:ring-blue-600/30 resize-none font-bold placeholder:text-slate-300"
                            ></textarea>
                        </div>
                    </div>

                    <!-- Checkout -->
                    <div class="pt-8 mt-4 border-t border-slate-100">
                        <div class="flex justify-between items-center mb-10">
                            <span class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Estimate Total</span>
                            <span class="text-3xl font-black text-blue-600 tracking-tighter">Rp {{ cart.totalPrice.toLocaleString('id-ID') }}</span>
                        </div>
                        <button 
                            @click="submitOrder"
                            :disabled="cart.items.length === 0"
                            class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:bg-slate-100 disabled:text-slate-300 disabled:shadow-none transition-all active:scale-[0.98]"
                        >
                            Place Order
                        </button>
                    </div>
                </div>
            </div>
        </Transition>

        <Transition
            enter-active-class="transition duration-300 ease-out"
            enter-from-class="opacity-0 scale-95"
            enter-to-class="opacity-100 scale-100"
            leave-active-class="transition duration-200 ease-in"
            leave-from-class="opacity-100 scale-100"
            leave-to-class="opacity-0 scale-95"
        >
            <div v-if="(page.props.flash as any)?.success" class="fixed inset-0 z-[110] flex items-center justify-center p-6">
                <div @click="(page.props.flash as any).success = null" class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>
                <div class="relative bg-white border border-slate-200 rounded-[40px] w-full max-w-sm p-10 text-center shadow-2xl">
                    <div class="w-20 h-20 bg-green-100 rounded-3xl flex items-center justify-center mx-auto mb-8">
                        <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                    </div>
                    <h3 class="text-2xl font-black text-slate-900 tracking-tighter mb-4">Berhasil!</h3>
                    <p class="text-slate-500 font-medium text-sm leading-relaxed mb-10">
                        {{ (page.props.flash as any)?.success }}
                    </p>
                    <button 
                        @click="(page.props.flash as any).success = null"
                        class="w-full h-16 bg-blue-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-lg shadow-blue-600/20"
                    >
                        Tutup
                    </button>
                </div>
            </div>
        </Transition>

        <!-- Mobile Sticky Bottom Summary -->
        <Transition
            enter-active-class="transition duration-500 ease-out"
            enter-from-class="translate-y-full opacity-0"
            enter-to-class="translate-y-0 opacity-100"
            leave-active-class="transition duration-400 ease-in"
            leave-from-class="translate-y-0 opacity-100"
            leave-to-class="translate-y-full opacity-0"
        >
            <div v-if="cartCount > 0" class="fixed bottom-0 left-0 right-0 z-[60] p-4 lg:hidden">
                <div @click="isCartOpen = true" class="bg-slate-900 border border-slate-800 rounded-[24px] p-4 shadow-2xl flex items-center justify-between cursor-pointer active:scale-[0.98] transition-all overflow-hidden group">
                    <!-- Subtle Glow -->
                    <div class="absolute -top-24 -right-24 w-48 h-48 bg-blue-600/20 rounded-full blur-[80px] group-hover:bg-blue-600/30 transition-colors"></div>
                    
                    <div class="relative flex flex-col">
                        <span class="text-[10px] font-black text-slate-500 uppercase tracking-[0.2em] mb-1">Your Order</span>
                        <div class="flex items-center gap-3">
                            <span class="text-xl font-black text-white tracking-tight">Rp {{ cart.totalPrice.toLocaleString('id-ID') }}</span>
                            <div class="w-1 h-1 rounded-full bg-slate-700"></div>
                            <span class="text-xs font-bold text-slate-400">{{ cartCount }} Items</span>
                        </div>
                    </div>
                    
                    <div class="relative flex items-center gap-3 bg-blue-600 px-6 py-3 rounded-2xl shadow-lg shadow-blue-600/20">
                        <span class="text-[10px] font-black text-white uppercase tracking-widest">Bag</span>
                        <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                    </div>
                </div>
            </div>
        </Transition>
    </CustomerLayout>
</template>

<style scoped>
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>
