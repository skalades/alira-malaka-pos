<script setup lang="ts">
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { router, Head, usePage } from '@inertiajs/vue3';
import { ref, computed, onMounted, watch } from 'vue';
import { printOrderRawBT, printOrderBatchRawBT } from '@/Utils/RawBT';

const props = defineProps<{
    tables: any[];
    menus: any[];
    pendingOrders: any[];
    dailyStats: {
        revenue: number;
        orders: number;
    };
    taxSettings: {
        enabled: boolean;
        percentage: number;
    };
    shopSettings: {
        name: string;
        address: string;
        footer: string;
    };
    activeShift: any | null;
    loyaltySettings: {
        points_per_10k: number;
        point_value: number;
    };
    serviceChargeSettings: {
        enabled: boolean;
        percentage: number;
    };
}>();

const page = usePage();

const orders = ref([...props.pendingOrders]);
const tables = ref([...props.tables]);

// Sync props when Inertia refresh happens
watch(() => props.pendingOrders, (newOrders) => {
    orders.value = [...newOrders];
}, { deep: true });

watch(() => props.tables, (newTables) => {
    tables.value = [...newTables];
}, { deep: true });
const isPaymentModalOpen = ref(false);
const isOrderModalOpen = ref(false);
const orderType = ref<'dine_in' | 'takeaway'>('takeaway');
const selectedTableForOrder = ref<any>(null);
const audioEnabled = ref(true);
const selectedOrder = ref<any>(null);
const paymentForm = ref({
    method: 'cash',
    amount: 0,
    customer_id: null as number | null,
    points_redeemed: 0,
    points_earned: 0,
    discount_amount: 0,
    discount_notes: '',
});

// Customer & Loyalty State
const customerSearch = ref('');
const customerResults = ref<any[]>([]);
const selectedCustomer = ref<any>(null);
const isSearchingCustomer = ref(false);
const isAddCustomerModalOpen = ref(false);
const isLoyaltyExpanded = ref(false);
const isDiscountManualExpanded = ref(false);

const newCustomerForm = ref({
    name: '',
    phone: '',
});

const searchCustomer = async () => {
    if (customerSearch.value.length < 3) {
        customerResults.value = [];
        return;
    }
    
    isSearchingCustomer.value = true;
    try {
        const response = await fetch(route('cashier.customers.search', { q: customerSearch.value }));
        customerResults.value = await response.json();
    } catch (e) {
        console.error('Search failed', e);
    } finally {
        isSearchingCustomer.value = false;
    }
};

const selectCustomer = (customer: any) => {
    selectedCustomer.value = customer;
    paymentForm.value.customer_id = customer.id;
    customerSearch.value = '';
    customerResults.value = [];
};

const addNewCustomer = async () => {
    if (!newCustomerForm.value.name || !newCustomerForm.value.phone) return;
    
    try {
        // @ts-ignore
        const response = await window.axios.post(route('cashier.customers.store'), newCustomerForm.value);
        
        if (response.data) {
            // result is the created customer
            selectCustomer(response.data);
            isAddCustomerModalOpen.value = false;
            newCustomerForm.value = { name: '', phone: '' };
        }
    } catch (e: any) {
        console.error('Failed to add customer', e);
        const message = e.response?.data?.message || 'Gagal menambahkan pelanggan. Pastikan Nomor HP belum terdaftar.';
        alert(message);
    }
};

const deselectCustomer = () => {
    selectedCustomer.value = null;
    paymentForm.value.customer_id = null;
    paymentForm.value.points_redeemed = 0;
};

const maxPointsAllowed = computed(() => {
    if (!selectedCustomer.value) return 0;
    const orderTotalValue = selectedOrderGrandTotal.value;
    const pointsNeededForTotal = Math.floor(orderTotalValue / props.loyaltySettings.point_value);
    return Math.min(selectedCustomer.value.points, pointsNeededForTotal);
});

const discountFromPoints = computed(() => {
    return paymentForm.value.points_redeemed * props.loyaltySettings.point_value;
});

const finalTotalAfterDiscount = computed(() => {
    const dp = Number(selectedOrder.value?.dp_amount || 0);
    const manualDiscount = Number(paymentForm.value.discount_amount || 0);
    return Math.max(0, selectedOrderGrandTotal.value - discountFromPoints.value - dp - manualDiscount);
});

const pointsToEarn = computed(() => {
    const total = finalTotalAfterDiscount.value;
    return Math.floor(total / 10000) * props.loyaltySettings.points_per_10k;
});

// Reservation State
const isReservationModalOpen = ref(false);
const activeReservation = ref<any>(null);
const activeReservationId = ref<number | null>(null);
const activeDP = ref(0);

const checkReservation = async (table: any) => {
    if (!table.has_reservation) {
        openOrderModal('dine_in', table);
        return;
    }

    try {
        const response = await fetch(route('admin.reservations.table', table.id));
        const reservation = await response.json();
        if (reservation) {
            activeReservation.value = reservation;
            selectedTableForOrder.value = table;
            isReservationModalOpen.value = true;
        } else {
            openOrderModal('dine_in', table);
        }
    } catch (e) {
        console.error('Failed to fetch reservation', e);
        openOrderModal('dine_in', table);
    }
};

const handleCheckIn = () => {
    if (!activeReservation.value) return;
    
    router.post(route('admin.reservations.checkin', activeReservation.value.id), {}, {
        onSuccess: () => {
            selectCustomer(activeReservation.value.customer);
            activeReservationId.value = activeReservation.value.id;
            activeDP.value = Number(activeReservation.value.dp_amount || 0);
            isReservationModalOpen.value = false;
            openOrderModal('dine_in', selectedTableForOrder.value);
        }
    });
};

const includeQcInPrint = ref(true);
const includeKitchenInPrint = ref(true);
const includeCustomerInPrint = ref(true);
const printOnlyUnprinted = ref(false);
const useRawBT = ref(localStorage.getItem('useRawBT') === 'true');

watch(useRawBT, (val) => {
    localStorage.setItem('useRawBT', val.toString());
});

const isEndShiftModalOpen = ref(false);
const openingCashForm = ref({
    opening_cash: 0
});
const closingCashForm = ref({
    closing_cash: 0,
    notes: ''
});

const orderCart = ref<any[]>([]);
const isCartExpanded = ref(false);
const isQuickActionModalOpen = ref(false);
const selectedOrderForQuickAction = ref<any>(null);
const selectedCategoryId = ref<number | null>(null);
const searchQuery = ref('');

const uniqueCategories = computed(() => {
    const cats: any[] = [];
    props.menus.forEach(m => {
        if (m.category && !cats.find(c => c.id === m.category.id)) {
            cats.push(m.category);
        }
    });
    return cats;
});

const filteredMenus = computed(() => {
    return props.menus.filter(m => {
        const matchesCategory = !selectedCategoryId.value || m.category_id === selectedCategoryId.value;
        const matchesSearch = !searchQuery.value || m.name.toLowerCase().includes(searchQuery.value.toLowerCase());
        return matchesCategory && matchesSearch;
    });
});

const addToOrderCart = (menu: any, initialNotes: string = '', variant: any = null) => {
    // Unique key: menu ID + variant ID + notes
    const variantId = variant?.id || null;
    const existing = orderCart.value.find(i => i.id === menu.id && i.variant_id === variantId && i.notes === initialNotes);
    
    if (existing) {
        existing.quantity++;
    } else {
        orderCart.value.push({ 
            ...menu, 
            variant_id: variantId,
            variant_name: variant?.name || null,
            price: variant ? variant.price : menu.price, // Use variant price if exists
            quantity: 1, 
            notes: initialNotes 
        });
    }
};

// Customization Modal State (Cashier)
const showCustomModal = ref(false);
const isVariantModalOpen = ref(false);
const selectedMenuForVariant = ref<any>(null);
const selectedMenuForCustom = ref<any>(null);
const selectedRice = ref('');
const selectedSambal = ref('');

const riceOptions = ['Nasi Merah', 'Nasi Timbel', 'Nasi Cikur'];
const sambalOptions = ['Sambel Goang', 'Sambel Dadak'];

const handleMenuClick = (menu: any) => {
    if (menu.variants && menu.variants.length > 0) {
        selectedMenuForVariant.value = menu;
        isVariantModalOpen.value = true;
        return;
    }

    const isKumplit = menu.name.toLowerCase().includes('kumplit');
    const isPaket = menu.name.toLowerCase().includes('paket');
    
    if (menu.stock <= 0) {
        alert(`Maaf, stok ${menu.name} sedang habis.`);
        return;
    }

    if (isKumplit || isPaket) {
        selectedMenuForCustom.value = menu;
        selectedRice.value = '';
        selectedSambal.value = '';
        showCustomModal.value = true;
    } else {
        addToOrderCart(menu);
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
        showCustomModal.value = true;
    } else {
        addToOrderCart(menu, '', variant);
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
    addToOrderCart(selectedMenuForCustom.value, parts.join(', '), variant);
    
    showCustomModal.value = false;
    selectedMenuForCustom.value = null;
};

const getMenuQuantity = (menuId: number) => {
    return orderCart.value
        .filter(item => item.id === menuId)
        .reduce((sum, item) => sum + item.quantity, 0);
};

const orderTotal = computed(() => orderCart.value.reduce((sum, i) => sum + (i.price * i.quantity), 0));

const selectedOrderGrandTotal = computed(() => {
    if (!selectedOrder.value) return 0;
    const subtotal = Number(selectedOrder.value.total_price);
    let total = subtotal;
    
    if (props.serviceChargeSettings.enabled) {
        total += (subtotal * props.serviceChargeSettings.percentage / 100);
    }
    
    if (props.taxSettings.enabled) {
        total += (subtotal * props.taxSettings.percentage / 100);
    }
    return total;
});

const triggerPrint = (order: any, mode: 'full' | 'kitchen' | 'customer' | 'kitchen_qc' = 'full') => {
    // Extract unique categories from order items, default to 'DAPUR' if no category
    const categoriesInOrder = [...new Set((order.order_items || []).map((i: any) => i.menu?.category?.name || 'DAPUR'))];

    if (useRawBT.value) {
        const prints: { mode: 'customer' | 'kitchen' | 'qc', category?: string }[] = [];

        if (mode === 'full') {
            // Sequence: QC -> Kitchen Tickets (Dynamic) -> Customer
            prints.push({ mode: 'qc' });
            categoriesInOrder.forEach((cat: any) => {
                prints.push({ mode: 'kitchen', category: cat });
            });
            prints.push({ mode: 'customer' });
        } else if (mode === 'kitchen') {
            categoriesInOrder.forEach((cat: any) => {
                prints.push({ mode: 'kitchen', category: cat });
            });
        } else if (mode === 'kitchen_qc') {
            prints.push({ mode: 'qc' });
            categoriesInOrder.forEach((cat: any) => {
                prints.push({ mode: 'kitchen', category: cat });
            });
        } else {
            prints.push({ mode: 'customer' });
        }

        if (prints.length > 0) {
            printOrderBatchRawBT(order, props.shopSettings, props.taxSettings, props.serviceChargeSettings, prints);
        }
        return;
    }

    selectedOrder.value = order;
    printOnlyUnprinted.value = mode === 'kitchen';
    includeQcInPrint.value = mode === 'full' || mode === 'kitchen' || mode === 'kitchen_qc';
    includeKitchenInPrint.value = mode === 'full' || mode === 'kitchen' || mode === 'kitchen_qc';
    includeCustomerInPrint.value = mode === 'full' || mode === 'customer';
    
    // For Vue/Browser rendering we expose the dynamic categories so the template can loop them
    selectedOrderCategories.value = categoriesInOrder as string[];

    setTimeout(() => {
        window.print();
    }, 500);
};

const handleKitchenPrint = (order: any) => {
    const hasUnprinted = order.order_items.some((i: any) => !i.is_printed);
    
    // Choose print mode based on whether there are new items
    const printMode = hasUnprinted ? 'kitchen' : 'kitchen_qc';
    
    if (useRawBT.value) {
        // Selective printing: only unprinted items if they exist, otherwise everything (reprint)
        const categoriesInOrder = [...new Set((order.order_items || [])
            .filter((i: any) => !hasUnprinted || !i.is_printed)
            .map((i: any) => i.menu?.category?.name || 'DAPUR'))];

        const prints: { mode: 'customer' | 'kitchen' | 'qc', category?: string }[] = [];
        
        prints.push({ mode: 'qc' }); // Always include QC
        
        categoriesInOrder.forEach((cat: any) => {
            prints.push({ mode: 'kitchen', category: cat });
        });

        const onlyUnprinted = hasUnprinted;
        printOrderBatchRawBT(order, props.shopSettings, props.taxSettings, props.serviceChargeSettings, prints, onlyUnprinted);
    } else {
        // Browser print
        triggerPrint(order, printMode);
    }

    // If there were unprinted items, mark them as printed in backend
    if (hasUnprinted) {
        router.post(route('cashier.order.mark-printed', order.id), {}, {
            preserveScroll: true,
            onSuccess: () => {
                console.log('Items marked as printed');
            }
        });
    }
};

const selectedOrderCategories = ref<string[]>([]);
const getItemsByCategory = (orderItems: any[], categoryName: string) => {
    return (orderItems || []).filter(item => {
        const itemCat = item.menu?.category?.name || 'DAPUR';
        return itemCat.toLowerCase() === categoryName.toLowerCase();
    });
};

const processPayment = () => {
    if (!selectedOrder.value) return;
    const orderId = selectedOrder.value.id;
    const finalTotal = finalTotalAfterDiscount.value;

    // For non-cash payments, the amount paid is always the exact total
    const amountPaid = paymentForm.value.method === 'cash' 
        ? paymentForm.value.amount 
        : finalTotal;

    const changeAmount = paymentForm.value.method === 'cash'
        ? Math.max(0, paymentForm.value.amount - finalTotal)
        : 0;

    router.post(route('order.pay', orderId), {
        payment_method: paymentForm.value.method,
        amount_paid: amountPaid,
        change_amount: changeAmount,
        customer_id: paymentForm.value.customer_id,
        points_redeemed: paymentForm.value.points_redeemed,
        points_earned: pointsToEarn.value,
        discount_amount: paymentForm.value.discount_amount,
        discount_notes: paymentForm.value.discount_notes
    }, {
        onSuccess: (page) => {
            const updatedOrder = (page.props.pendingOrders as any[]).find(o => o.id === orderId);
            isPaymentModalOpen.value = false;
            deselectCustomer(); // Reset loyalty state
            if (updatedOrder) {
                triggerPrint(updatedOrder, 'customer');
            }
        }
    });
};

const startShift = () => {
    router.post(route('shift.start'), {
        opening_cash: openingCashForm.value.opening_cash
    }, {
        onSuccess: () => {
            openingCashForm.value.opening_cash = 0;
        }
    });
};

const endShift = () => {
    router.post(route('shift.end'), {
        closing_cash: closingCashForm.value.closing_cash,
        notes: closingCashForm.value.notes
    }, {
        onSuccess: () => {
            isEndShiftModalOpen.value = false;
            closingCashForm.value.closing_cash = 0;
            closingCashForm.value.notes = '';
        }
    });
};

const formattedOpeningCash = computed({
    get: () => openingCashForm.value.opening_cash ? openingCashForm.value.opening_cash.toLocaleString('id-ID') : '',
    set: (val: string) => {
        openingCashForm.value.opening_cash = parseInt(val.replace(/\D/g, '')) || 0;
    }
});

const formattedClosingCash = computed({
    get: () => closingCashForm.value.closing_cash ? closingCashForm.value.closing_cash.toLocaleString('id-ID') : '',
    set: (val: string) => {
        closingCashForm.value.closing_cash = parseInt(val.replace(/\D/g, '')) || 0;
    }
});

const openOrderModal = (type: 'dine_in' | 'takeaway', table: any = null) => {
    if (table && table.status === 'occupied') {
        const activeOrder = orders.value.find(o => 
            (o.table_id == table.id || (o.table && o.table.id == table.id)) && 
            o.status !== 'completed' && 
            o.status !== 'cancelled'
        );
        if (activeOrder) {
            selectedOrderForQuickAction.value = activeOrder;
            isQuickActionModalOpen.value = true;
            return;
        }
    }

    // Check for reservation if not occupied
    if (table && table.status === 'available' && table.has_reservation && !activeReservation.value) {
        checkReservation(table);
        return;
    }

    orderType.value = type;
    selectedTableForOrder.value = table;
    orderCart.value = [];
    isOrderModalOpen.value = true;
};

const continueOrder = (order: any) => {
    selectedTableForOrder.value = props.tables.find(t => t.id === order.table_id);
    orderType.value = 'dine_in';
    orderCart.value = []; // Reset cart for new additions
    isQuickActionModalOpen.value = false;
    isOrderModalOpen.value = true;
};

const selectOrderAction = (order: any) => {
    isQuickActionModalOpen.value = false;
    openPaymentModal(order);
};

const confirmOrder = (order: any) => {
    updateOrderStatus(order.id, 'processing');
    isQuickActionModalOpen.value = false;
};

const openPaymentModal = (order: any) => {
    selectedOrder.value = order;
    paymentForm.value.amount = 0;
    paymentForm.value.discount_amount = 0;
    paymentForm.value.discount_notes = '';
    isLoyaltyExpanded.value = false;
    isDiscountManualExpanded.value = false;
    isPaymentModalOpen.value = true;
};

const formattedPaymentAmount = computed({
    get: () => {
        if (!paymentForm.value.amount) return '';
        return paymentForm.value.amount.toLocaleString('id-ID');
    },
    set: (val: string) => {
        // Strip non-digits and convert to number
        const numeric = parseInt(val.replace(/\D/g, '')) || 0;
        paymentForm.value.amount = numeric;
    }
});

const submitOrderAction = () => {
    if (orderCart.value.length === 0) return;

    router.post(route('order.checkout'), {
        table_id: selectedTableForOrder.value?.id || null,
        items: orderCart.value.map(i => ({ 
            id: i.id, 
            variant_id: i.variant_id,
            quantity: i.quantity,
            notes: i.notes || ''
        })),
        type: orderType.value,
        reservation_id: activeReservationId.value,
        dp_amount: activeDP.value
    }, {
        onSuccess: (page) => {
            isOrderModalOpen.value = false;
            orderCart.value = [];
            activeReservationId.value = null;
            activeDP.value = 0;
            
            // Trigger print for the new order from the fresh page props
            const newOrder = (page.props.flash as any)?.new_order;
            if (newOrder) {
                triggerPrint(newOrder, 'kitchen');
            }
        }
    });
};

const playNotificationSound = () => {
    if (!audioEnabled.value) return;
    const audio = new Audio('/sounds/notification.mp3');
    audio.play().catch(e => console.log('Sound blocked by browser or missing file.'));
};

const toggleAudio = () => {
    audioEnabled.value = !audioEnabled.value;
    if (audioEnabled.value) {
        // Play a short silent sound or the notification to "unlock" audio in browser
        const audio = new Audio('/sounds/notification.mp3');
        audio.play().catch(e => console.log('Initial unlock failed (expected if file missing)'));
    }
};

const updateOrderStatus = (orderId: number, status: string, printMode?: 'full' | 'kitchen' | 'customer' | 'kitchen_qc') => {
    router.patch(route('cashier.order.status', orderId), { status }, {
        preserveScroll: true,
        onSuccess: (page) => {
            if (printMode) {
                // Find the updated order in the new props
                const updatedOrder = (page.props.pendingOrders as any[]).find(o => o.id === orderId);
                if (updatedOrder) {
                    triggerPrint(updatedOrder, printMode);
                }
            }
        }
    });
};

onMounted(() => {
    // @ts-ignore
    if (window.Echo) {
        // @ts-ignore
        window.Echo.channel('orders')
            .listen('.order.placed', (e: any) => {
                console.log('New Order Received:', e);
                if (!orders.value.find(o => o.id === e.order.id)) {
                    orders.value.unshift(e.order);
                    
                    // Mark table as occupied locally
                    if (e.order.table_id) {
                        const table = tables.value.find(t => t.id == e.order.table_id);
                        if (table) table.status = 'occupied';
                    }
                    
                    playNotificationSound();
                }
            })
            .listen('.order.status.updated', (e: any) => {
                console.log('Order Status Updated:', e);
                const idx = orders.value.findIndex(o => o.id === e.order.id);
                if (idx !== -1) {
                    if (['completed', 'cancelled'].includes(e.order.status)) {
                        // Mark table as available locally first
                        const order = orders.value[idx];
                        const tid = e.order.table_id || order.table_id || order.table?.id;
                        if (tid) {
                            const table = tables.value.find(t => t.id == tid);
                            if (table) table.status = 'available';
                        }
                        // Remove from active queue
                        orders.value.splice(idx, 1);
                    } else {
                        // Simply update status (e.g. to 'paid')
                        orders.value[idx].status = e.order.status;
                    }
                }
            });
    }
});

const getStatusColor = (status: string) => {
    switch (status) {
        case 'pending': return 'bg-amber-50 text-amber-600 border-amber-100';
        case 'processing': return 'bg-blue-50 text-blue-600 border-blue-100';
        case 'paid': return 'bg-indigo-50 text-indigo-600 border-indigo-100';
        case 'cancelled': return 'bg-red-50 text-red-600 border-red-100';
        case 'ready': return 'bg-green-50 text-green-600 border-green-100';
        case 'completed': return 'bg-slate-50 text-slate-400 border-slate-100';
        default: return 'bg-slate-50 text-slate-400 border-slate-100';
    }
};

const getStatusLabel = (status: string) => {
    switch (status) {
        case 'pending': return 'Menunggu';
        case 'processing': return 'Diproses';
        case 'paid': return 'Dibayar';
        case 'ready': return 'Siap';
        case 'cancelled': return 'Dibatalkan';
        case 'completed': return 'Selesai';
        default: return status;
    }
};
</script>

<style>
@media print {
    body * { visibility: hidden; }
    #print-section, #print-section * { visibility: visible; }
    #print-section { 
        position: absolute; 
        left: 0; 
        top: 0; 
        width: 100%; 
    }
    .print-page-break { 
        page-break-before: always; 
        break-before: page;
    }
    #print-section > div > .print-page-break:first-of-type {
        page-break-before: avoid;
        break-before: avoid;
    }
    
    /* Global overrides to prevent empty blank pages */
    body, html, main, #app, .min-h-screen {
        min-height: 0 !important;
        height: auto !important;
        padding: 0 !important;
        margin: 0 !important;
        background: white !important;
    }
    aside, header, .print-hide-bg { 
        display: none !important; 
    }
}
</style>

<template>
    <Head :title="'Cashier Desk - ' + props.shopSettings.name" />

    <AuthenticatedLayout :hide-sidebar="true">
        <template #header>
            Point of Sale (POS)
        </template>

        <div class="space-y-6 lg:space-y-10 print:space-y-0">
            <!-- Hidden Print Section -->
            <div id="print-section" class="hidden print:block font-mono text-sm p-4 text-black">
                <div v-if="selectedOrder">
                    <!-- 0. QC Checklist (HIDDEN if not included) -->
                    <div v-if="includeQcInPrint && selectedOrder.order_items.some((i: any) => !printOnlyUnprinted || !i.is_printed)" class="print-page-break mb-10 border-b pb-8">
                        <div class="text-center mb-6">
                            <h2 class="text-xl font-bold uppercase">QC CHECKLIST {{ printOnlyUnprinted && selectedOrder.order_items.some((i: any) => i.is_printed) ? '(BARU)' : '' }}</h2>
                            <p>{{ new Date().toLocaleDateString('id-ID') }} {{ new Date().toLocaleTimeString('id-ID') }}</p>
                            <p>#{{ selectedOrder.order_number }}</p>
                            <p class="text-3xl font-black border-2 border-black inline-block px-4 py-2 mt-2">{{ selectedOrder.table ? 'MEJA ' + selectedOrder.table.table_number : 'TAKEAWAY ' }}</p>
                        </div>
                        <div class="border-t border-black py-4 text-left">
                            <div v-for="item in selectedOrder.order_items.filter((i: any) => !printOnlyUnprinted || !i.is_printed)" :key="item.id" class="flex items-start mb-3 border-b border-dashed border-slate-200 pb-2 last:border-0">
                                <span class="mr-4 text-xl font-bold">[ ]</span>
                                <div class="flex-1">
                                    <p class="text-lg font-bold leading-none">
                                        {{ (item as any).quantity }}x {{ (item as any).menu.name }}
                                        <span v-if="(item as any).variant" class="text-sm">({{ (item as any).variant.name }})</span>
                                    </p>
                                    <p v-if="(item as any).notes" class="text-xs mt-1">    * {{ (item as any).notes }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Kitchen/Bar Receipts (HIDDEN if not included) -->
                    <template v-if="includeKitchenInPrint">
                        <template v-for="cat in selectedOrderCategories" :key="cat">
                            <div v-if="getItemsByCategory(selectedOrder.order_items.filter((i: any) => !printOnlyUnprinted || !i.is_printed), cat).length > 0" class="print-page-break mb-10 border-b pb-8">
                                <div class="text-center mb-6">
                                    <h2 class="text-xl font-bold uppercase">TIKET {{ cat }} {{ printOnlyUnprinted && selectedOrder.order_items.some((i: any) => i.is_printed) ? '(BARU)' : '' }}</h2>
                                    <p>{{ new Date().toLocaleDateString('id-ID') }} {{ new Date().toLocaleTimeString('id-ID') }}</p>
                                    <p>#{{ selectedOrder.order_number }}</p>
                                    <p class="text-3xl font-black border-2 border-black inline-block px-4 py-2 mt-2">{{ selectedOrder.table ? 'MEJA ' + selectedOrder.table.table_number : 'TAKEAWAY ' }}</p>
                                </div>
                                <div class="border-t border-black py-4">
                                    <div v-for="item in getItemsByCategory(selectedOrder.order_items.filter((i: any) => !printOnlyUnprinted || !i.is_printed), cat)" :key="item.id" class="mb-4">
                                        <p class="text-2xl font-bold">
                                            {{ (item as any).quantity }}x {{ (item as any).menu.name }}
                                            <span v-if="(item as any).variant" class="text-lg">({{ (item as any).variant.name }})</span>
                                        </p>
                                        <p v-if="(item as any).notes" class="text-sm italic">  Catatan: {{ (item as any).notes }}</p>
                                    </div>
                                </div>
                            </div>
                        </template>
                    </template>

                    <!-- 1. Customer Receipt (HIDDEN if not included) -->
                    <div v-if="includeCustomerInPrint" class="print-page-break mb-10 border-b pb-8">
                        <div class="text-center mb-6">
                            <h2 class="text-xl font-bold uppercase">{{ props.shopSettings.name }}</h2>
                            <p v-if="props.shopSettings.address" class="text-[10px]">{{ props.shopSettings.address }}</p>
                            <p class="mt-2">STRUK PELANGGAN</p>
                            <p>{{ new Date().toLocaleDateString('id-ID') }} {{ new Date().toLocaleTimeString('id-ID') }}</p>
                            <p>Pesanan: #{{ selectedOrder.order_number }}</p>
                            <p class="text-3xl font-black border-2 border-black inline-block px-4 py-2 mt-2">{{ selectedOrder.table ? 'MEJA ' + selectedOrder.table.table_number : 'BUNGKUS ' }}</p>
                            <p v-if="selectedOrder.customer" class="font-bold">Pelanggan: {{ selectedOrder.customer.name }}</p>
                            <p v-if="selectedOrder.transaction" class="font-bold uppercase mt-1">Metode: {{ selectedOrder.transaction.payment_method }}</p>
                        </div>
                        <div class="border-t border-b border-black py-2 mb-2">
                            <div v-for="item in selectedOrder.order_items" :key="item.id" class="mb-1">
                                <div class="flex justify-between">
                                    <span>
                                        {{ item.quantity }}x {{ item.menu.name }}
                                        <span v-if="item.variant" class="text-[10px]">({{ item.variant.name }})</span>
                                    </span>
                                    <span>{{ (item.price_at_time * item.quantity).toLocaleString('id-ID') }}</span>
                                </div>
                                <p v-if="item.notes" class="text-xs mt-0.5 ml-4">  * {{ item.notes }}</p>
                            </div>
                        </div>
                        <!-- Subtotal, Tax, Total -->
                        <div class="border-t border-black pt-2 space-y-1 mb-2">
                            <div v-if="props.taxSettings.enabled || props.serviceChargeSettings.enabled" class="flex justify-between text-[10px]">
                                <span>Subtotal</span>
                                <span>{{ Number(selectedOrder.total_price).toLocaleString('id-ID') }}</span>
                            </div>
                            <div v-if="props.serviceChargeSettings.enabled" class="flex justify-between text-[10px]">
                                <span>Service Chg ({{ props.serviceChargeSettings.percentage }}%)</span>
                                <span>{{ (selectedOrder.total_price * props.serviceChargeSettings.percentage / 100).toLocaleString('id-ID') }}</span>
                            </div>
                            <div v-if="props.taxSettings.enabled" class="flex justify-between text-[10px]">
                                <span>Pajak ({{ props.taxSettings.percentage }}%)</span>
                                <span>{{ (selectedOrder.total_price * props.taxSettings.percentage / 100).toLocaleString('id-ID') }}</span>
                            </div>
                            <div v-if="selectedOrder.loyalty_discount > 0" class="flex justify-between text-[10px] text-red-600">
                                <span>Diskon Poin ({{ selectedOrder.points_redeemed }} pts)</span>
                                <span>- {{ Number(selectedOrder.loyalty_discount).toLocaleString('id-ID') }}</span>
                            </div>
                        </div>

                        <div class="flex justify-between font-bold border-b border-black pb-1 mb-1">
                            <span>TOTAL TERTAGIH</span>
                            <span>Rp {{ 
                                (
                                    Number(selectedOrder.total_price) + 
                                    (props.serviceChargeSettings.enabled ? (selectedOrder.total_price * props.serviceChargeSettings.percentage / 100) : 0) +
                                    (props.taxSettings.enabled ? (selectedOrder.total_price * props.taxSettings.percentage / 100) : 0) - 
                                    Number(selectedOrder.loyalty_discount || 0)
                                ).toLocaleString('id-ID') 
                            }}</span>
                        </div>
                        <div v-if="selectedOrder.transaction" class="text-[10px] space-y-0.5 pt-1">
                            <div class="flex justify-between uppercase">
                                <span>Bayar ({{ selectedOrder.transaction.payment_method }})</span>
                                <span>{{ Number(selectedOrder.transaction.amount_paid).toLocaleString('id-ID') }}</span>
                            </div>
                            <div class="flex justify-between font-bold uppercase">
                                <span>Kembalian</span>
                                <span>{{ Number(selectedOrder.transaction.change_amount).toLocaleString('id-ID') }}</span>
                            </div>
                            <div v-if="selectedOrder.points_earned > 0" class="flex justify-between font-bold pt-2 border-t border-dashed mt-2">
                                <span>Poin Didapat</span>
                                <span>+{{ selectedOrder.points_earned }} PTS</span>
                            </div>
                        </div>
                        <div class="text-center mt-6">
                            <p class="font-bold">--- TERIMA KASIH ---</p>
                            <p>{{ props.shopSettings.footer || 'Selamat Menikmati' }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table Map Section -->
            <div class="print-hide-bg bg-white border border-slate-200 p-6 lg:p-10 rounded-[32px] lg:rounded-[40px] relative overflow-hidden shadow-sm">
                <div class="absolute -top-24 -right-24 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl"></div>
                
                <h2 class="text-lg lg:text-xl font-black mb-6 lg:mb-8 tracking-tighter uppercase tracking-[0.2em] text-slate-400">Peta Meja</h2>
                <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 lg:grid-cols-8 gap-3 lg:gap-4">
                    <div 
                        v-for="table in tables" 
                        :key="table.id" 
                        @click="openOrderModal('dine_in', table)"
                        class="aspect-square rounded-[24px] lg:rounded-[32px] flex flex-col items-center justify-center border transition-all cursor-pointer relative group"
                        :class="table.status === 'occupied' ? 'bg-blue-600 border-blue-600 shadow-lg shadow-blue-600/20' : 'bg-slate-50 border-slate-100 hover:border-slate-300 hover:bg-white text-slate-400'"
                    >
                        <span class="text-[8px] font-black uppercase tracking-widest mb-1" :class="table.status === 'occupied' ? 'text-white/60' : 'text-slate-400'">Meja</span>
                        <span class="text-xl lg:text-2xl font-black" :class="table.status === 'occupied' ? 'text-white' : 'text-slate-900'">
                            {{ table.table_number }}
                        </span>
                        
                        <!-- Reservation Indicator -->
                        <div v-if="table.has_reservation && table.status === 'available'" class="absolute -top-2 -right-2 px-2 py-0.5 bg-amber-500 text-white text-[7px] font-black rounded-lg uppercase tracking-widest shadow-lg shadow-amber-500/20 animate-bounce">
                            RESERVED
                        </div>

                        <div v-if="table.status === 'occupied'" class="mt-2 h-1 w-1 lg:h-1.5 lg:w-1.5 rounded-full bg-white/60 animate-pulse"></div>
                        <div v-else class="mt-2 h-1 w-1 lg:h-1.5 lg:w-1.5 rounded-full bg-green-500 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                    </div>
                </div>
            </div>

            <!-- Active Orders Grid -->
            <div class="print-hide-bg">
                <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-6 mb-8">
                    <div>
                        <h2 class="text-2xl lg:text-3xl font-black text-slate-900 tracking-tighter">Antrean Aktif</h2>
                        <p class="text-slate-500 font-medium text-sm">Kelola pesanan masuk dan proses pembayaran.</p>
                    </div>
                    <div class="flex flex-wrap gap-3 lg:gap-4">
                        <button 
                            @click="toggleAudio"
                            class="flex-1 lg:flex-none h-12 lg:h-14 px-4 lg:px-8 border rounded-2xl font-black text-base uppercase tracking-widest transition-all flex items-center justify-center gap-3"
                            :class="audioEnabled ? 'bg-green-500/10 border-green-500/20 text-green-500' : 'bg-red-500/10 border-red-500/20 text-red-500'"
                        >
                            <svg v-if="audioEnabled" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z"></path></svg>
                            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M17 10l5 5m0-5l-5 5" /></svg>
                            <span class="text-[10px]">{{ audioEnabled ? 'Suara AKTIF' : 'Suara MATI' }}</span>
                        </button>

                        <button 
                            @click="useRawBT = !useRawBT"
                            class="flex-1 lg:flex-none h-12 lg:h-14 px-4 lg:px-8 border rounded-2xl font-black text-base uppercase tracking-widest transition-all flex items-center justify-center gap-3"
                            :class="useRawBT ? 'bg-indigo-500/10 border-indigo-500/20 text-indigo-500' : 'bg-slate-500/10 border-slate-500/20 text-slate-500'"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071a9.5 9.5 0 0113.435 0"></path></svg>
                            <span class="text-[10px]">{{ useRawBT ? 'RawBT AKTIF' : 'RawBT MATI' }}</span>
                        </button>
                        
                        <button 
                            v-if="props.activeShift"
                            @click="isEndShiftModalOpen = true"
                            class="flex-1 lg:flex-none h-12 lg:h-14 px-4 lg:px-8 bg-red-50 text-red-500 border border-red-100 rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-red-100 transition-all flex items-center justify-center gap-3"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                            <span class="text-[10px]">Tutup Shift</span>
                        </button>

                        <button 
                            @click="openOrderModal('takeaway')"
                            class="flex-1 lg:flex-none h-12 lg:h-14 px-4 lg:px-8 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest hover:bg-blue-700 shadow-lg shadow-blue-600/20 transition-all flex items-center justify-center gap-3"
                        >
                            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"></path></svg>
                            <span class="text-[10px]">Bungkus</span>
                        </button>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div v-for="order in orders" :key="order.id" class="bg-white border border-slate-200 rounded-[32px] lg:rounded-[40px] p-6 lg:p-8 hover:shadow-xl hover:shadow-blue-600/5 transition-all group flex flex-col">
                        <!-- Responsive Header -->
                        <div class="space-y-6 mb-6">
                            <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
                                <div>
                                    <div class="flex flex-wrap items-center gap-2 lg:gap-3 mb-2">
                                        <span class="font-black text-xl lg:text-2xl text-slate-900 tracking-tighter">#{{ order.order_number }}</span>
                                        <span v-if="order.type === 'takeaway'" class="px-2 py-0.5 bg-blue-100 text-blue-700 text-[8px] font-black rounded uppercase tracking-widest whitespace-nowrap">Bungkus</span>
                                        <span v-if="order.type === 'dine_in' && order.table" class="px-2 py-0.5 bg-blue-600 text-white text-[8px] font-black rounded uppercase tracking-widest whitespace-nowrap">Meja {{ order.table.table_number }}</span>
                                    </div>
                                    <span class="inline-block px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-widest border" :class="getStatusColor(order.status)">
                                        {{ getStatusLabel(order.status) }}
                                    </span>
                                </div>
                                <div class="flex flex-col items-end gap-1">
                                    <div class="px-3 py-1 bg-slate-100 rounded-full text-[10px] font-black text-slate-500 uppercase tracking-widest whitespace-nowrap">
                                        {{ order.order_items.length }} Produk
                                    </div>
                                    <div v-if="order.user" class="text-[9px] font-bold text-blue-600/60 uppercase tracking-widest bg-blue-50/50 px-2 py-0.5 rounded-lg border border-blue-100/30">
                                        Oleh: {{ order.user.name }}
                                    </div>
                                </div>
                            </div>

                            <div class="bg-blue-50/50 border border-blue-100/50 rounded-2xl p-4">
                                <div class="flex justify-between items-end">
                                    <div class="space-y-1">
                                        <template v-if="props.serviceChargeSettings.enabled || props.taxSettings.enabled">
                                            <span class="block text-[10px] font-black text-slate-400 uppercase tracking-widest leading-none">Subtotal: Rp {{ Number(order.total_price).toLocaleString() }}</span>
                                            <span v-if="props.serviceChargeSettings.enabled" class="block text-[10px] font-black text-amber-600 uppercase tracking-widest leading-none">Tax Service ({{ props.serviceChargeSettings.percentage }}%): Rp {{ (order.total_price * props.serviceChargeSettings.percentage / 100).toLocaleString() }}</span>
                                            <span v-if="props.taxSettings.enabled" class="block text-[10px] font-black text-blue-600 uppercase tracking-widest leading-none">PPN ({{ props.taxSettings.percentage }}%): Rp {{ (order.total_price * props.taxSettings.percentage / 100).toLocaleString() }}</span>
                                        </template>
                                        <span class="block text-2xl lg:text-3xl font-black text-slate-900 tracking-tighter leading-none mt-1">
                                            Rp {{ 
                                                (Number(order.total_price) + 
                                                (props.serviceChargeSettings.enabled ? (order.total_price * props.serviceChargeSettings.percentage / 100) : 0) +
                                                (props.taxSettings.enabled ? (order.total_price * props.taxSettings.percentage / 100) : 0)).toLocaleString() 
                                            }}
                                        </span>
                                    </div>
                                    <div class="sm:hidden text-[8px] font-black text-blue-600 uppercase tracking-widest opacity-40">Total</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="bg-slate-50 rounded-[28px] p-5 lg:p-6 mb-8 flex-1">
                            <ul class="space-y-4">
                                <li v-for="item in order.order_items" :key="item.id" class="border-b border-slate-200 pb-4 last:border-0 last:pb-0">
                                    <div class="flex justify-between items-start text-sm">
                                        <div class="flex-1">
                                            <p class="text-slate-900 font-bold leading-tight">
                                                <span class="text-blue-600 font-black mr-2">{{ item.quantity }}x</span>
                                                {{ item.menu.name }}
                                                <span v-if="item.variant" class="text-blue-600 font-bold ml-1">({{ item.variant.name }})</span>
                                                <span v-if="!item.is_printed" class="ml-2 px-1.5 py-0.5 bg-amber-100 text-amber-600 text-[8px] font-black rounded uppercase tracking-widest animate-pulse">BARU</span>
                                            </p>
                                            <p v-if="item.notes" class="text-[9px] text-blue-600/70 font-black uppercase tracking-tighter mt-1 bg-blue-600/10 px-2 py-1 rounded-lg w-fit">
                                                Catatan: {{ item.notes }}
                                            </p>
                                        </div>
                                        <span class="text-slate-400 font-bold ml-4 text-xs whitespace-nowrap">Rp {{ (item.price_at_time * item.quantity).toLocaleString('id-ID') }}</span>
                                    </div>
                                </li>
                            </ul>
                        </div>

                        <div class="grid grid-cols-2 gap-3 mt-auto">
                            <button 
                                v-if="order.status === 'paid'"
                                @click="updateOrderStatus(order.id, 'completed')"
                                class="col-span-2 h-12 lg:h-14 bg-indigo-600 text-white rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-lg shadow-indigo-600/10 hover:bg-indigo-700 transition-all active:scale-95"
                            >
                                Selesaikan / Kosongkan Meja
                            </button>
                            
                            <button 
                                v-if="order.status === 'pending'"
                                @click="updateOrderStatus(order.id, 'processing', 'kitchen')"
                                class="col-span-2 h-12 lg:h-14 bg-blue-600 text-white rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-95"
                            >
                                Konfirmasi Pesanan
                            </button>

                            <button 
                                v-if="['pending', 'processing'].includes(order.status)"
                                @click="openPaymentModal(order)"
                                class="h-12 lg:h-14 bg-slate-100 text-slate-600 rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-slate-200 transition-all active:scale-95"
                            >
                                Pembayaran
                            </button>

                            <button 
                                v-if="['pending', 'processing', 'paid'].includes(order.status)"
                                @click="triggerPrint(order, 'customer')"
                                class="h-12 lg:h-14 bg-slate-50 text-slate-400 rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-slate-100 transition-all active:scale-95 flex items-center justify-center gap-2"
                            >
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                                Bill Sementara
                            </button>

                            <button 
                                v-if="['pending', 'processing', 'paid'].includes(order.status)"
                                @click="triggerPrint(order, 'customer')"
                                class="h-12 lg:h-14 bg-blue-50 text-blue-600 rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-blue-100 transition-all active:scale-95 flex items-center justify-center gap-2"
                            >
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071a9.5 9.5 0 0113.435 0"></path></svg>
                                CETAK BT
                            </button>

                            <button 
                                v-if="['pending', 'processing', 'paid'].includes(order.status)"
                                @click="handleKitchenPrint(order)"
                                class="h-12 lg:h-14 bg-amber-50 text-amber-600 rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-amber-100 transition-all active:scale-95 flex items-center justify-center gap-2"
                            >
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11l-8 8-4-4m0-8l8 8 4-4"></path></svg>
                                {{ 
                                    (order.order_items as any[]).every((i: any) => !i.is_printed) || (order.order_items as any[]).every((i: any) => i.is_printed)
                                    ? 'CETAK DAPUR' 
                                    : `CETAK ITEM BARU (${(order.order_items as any[]).filter((i: any) => !i.is_printed).length})` 
                                }}
                            </button>

                            <button 
                                v-if="['pending', 'processing'].includes(order.status)"
                                @click="updateOrderStatus(order.id, 'cancelled')"
                                class="col-span-2 h-12 lg:h-14 bg-red-50 text-red-500 rounded-2xl font-black uppercase text-[10px] tracking-widest hover:bg-red-100 transition-all active:scale-95"
                            >
                                Batalkan Pesanan
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Modal Redesign -->
            <Teleport to="body">
                <div v-if="isPaymentModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-2 lg:p-6 text-slate-900">
                    <div class="bg-white border border-slate-200 rounded-[32px] lg:rounded-[48px] w-full max-w-lg p-6 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-300 overflow-y-auto max-h-[95vh] custom-scrollbar">
                        <div class="flex justify-between items-center mb-6 lg:mb-10 text-slate-900">
                            <h3 class="text-xl lg:text-3xl font-black text-slate-900 tracking-tighter uppercase">Checkout</h3>
                            <button @click="isPaymentModalOpen = false" class="text-slate-300 hover:text-slate-600 transition-colors">
                                <svg class="w-6 h-6 lg:w-8 lg:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                            </button>
                        </div>

                        <div class="bg-blue-600 rounded-[32px] lg:rounded-[40px] p-6 lg:p-10 text-white shadow-2xl shadow-blue-600/30 relative overflow-hidden group mb-6 lg:mb-10">
                            <!-- Decorative background icon -->
                            <div class="absolute -right-6 -bottom-6 opacity-[0.07] group-hover:scale-110 transition-transform duration-700 pointer-events-none">
                                <svg class="w-32 h-32 lg:w-48 lg:h-48" fill="currentColor" viewBox="0 0 24 24"><path d="M21 18L21 6C21 4.89543 20.1046 4 19 4L5 4C3.89543 4 3 4.89543 3 6L3 18C3 19.1046 3.89543 20 5 20L19 20C20.1046 20 21 19.1046 21 18ZM19 18L5 18L5 8L19 8L19 18ZM5 6L19 6L19 7L5 7L5 6ZM14 13C14 14.1046 13.1046 15 12 15C10.8954 15 10 14.1046 10 13C10 11.8954 10.8954 11 12 11C13.1046 11 14 11.8954 14 13Z"/></svg>
                            </div>

                            <div class="relative z-10">
                                <div class="flex flex-col gap-4 lg:gap-6">
                                    <div v-if="props.taxSettings.enabled || props.serviceChargeSettings.enabled" class="space-y-1 lg:space-y-2 pb-4 lg:pb-6 border-b border-white/10">
                                        <div class="flex justify-between items-center opacity-60">
                                            <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">Subtotal</span>
                                            <span class="font-bold text-xs lg:text-base">Rp {{ Number(selectedOrder?.total_price).toLocaleString() }}</span>
                                        </div>
                                        <div v-if="props.serviceChargeSettings.enabled" class="flex justify-between items-center text-amber-200">
                                            <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">Tax Service ({{ props.serviceChargeSettings.percentage }}%)</span>
                                            <span class="font-bold text-xs lg:text-base">Rp {{ (selectedOrder?.total_price * props.serviceChargeSettings.percentage / 100).toLocaleString() }}</span>
                                        </div>
                                        <div v-if="props.taxSettings.enabled" class="flex justify-between items-center text-blue-100">
                                            <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">PPN ({{ props.taxSettings.percentage }}%)</span>
                                            <span class="font-bold text-xs lg:text-base">Rp {{ (selectedOrder?.total_price * props.taxSettings.percentage / 100).toLocaleString() }}</span>
                                        </div>
                                    </div>

                                    <div v-if="discountFromPoints > 0" class="flex justify-between items-center text-green-300 font-bold border-t border-white/10 pt-4">
                                        <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">Diskon Poin</span>
                                        <span>- Rp {{ discountFromPoints.toLocaleString() }}</span>
                                    </div>

                                    <div v-if="Number(selectedOrder?.dp_amount) > 0" class="flex justify-between items-center text-blue-200 font-bold border-t border-white/10 pt-4 animate-in fade-in duration-500">
                                        <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">Uang Muka (DP)</span>
                                        <span>- Rp {{ Number(selectedOrder?.dp_amount).toLocaleString() }}</span>
                                    </div>

                                    <div v-if="paymentForm.discount_amount > 0" class="flex justify-between items-center text-amber-200 font-bold border-t border-white/10 pt-4 animate-in fade-in duration-500">
                                        <span class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em]">Diskon Manual</span>
                                        <span>- Rp {{ Number(paymentForm.discount_amount).toLocaleString() }}</span>
                                    </div>

                                    <div>
                                        <div class="flex justify-between items-end mb-1 lg:mb-2">
                                            <p class="text-[9px] lg:text-[10px] font-black uppercase tracking-[0.2em] opacity-60">Total Lunas</p>
                                            <p v-if="pointsToEarn > 0" class="text-[8px] font-black uppercase tracking-widest text-blue-200">+ {{ pointsToEarn }} POIN</p>
                                        </div>
                                        <h4 class="text-3xl lg:text-6xl font-black tracking-tighter leading-none">
                                            Rp {{ finalTotalAfterDiscount.toLocaleString() }}
                                        </h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Customer & Loyalty Section -->
                        <div class="mb-6 lg:mb-8">
                            <button 
                                @click="isLoyaltyExpanded = !isLoyaltyExpanded"
                                class="w-full flex items-center justify-between p-4 lg:p-6 bg-slate-50 border border-slate-100 rounded-[28px] lg:rounded-[32px] hover:bg-slate-100 transition-all group mb-4"
                            >
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 bg-blue-100 text-blue-600 rounded-xl flex items-center justify-center">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                                    </div>
                                    <span class="text-[9px] lg:text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Loyalty Pelanggan</span>
                                </div>
                                <div class="flex items-center gap-3">
                                    <span v-if="selectedCustomer" class="text-[9px] font-black text-blue-600 uppercase tracking-widest bg-blue-100 px-3 py-1 rounded-full">{{ selectedCustomer.name }}</span>
                                    <svg 
                                        class="w-5 h-5 text-slate-300 transition-transform duration-300" 
                                        :class="isLoyaltyExpanded ? 'rotate-180' : ''"
                                        fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                    >
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                            </button>
                            
                            <div v-if="isLoyaltyExpanded || selectedCustomer" class="space-y-4 animate-in fade-in slide-in-from-top-2 duration-300">
                                <!-- Selected Customer Card -->
                                <div v-if="selectedCustomer" class="bg-blue-50 border border-blue-200 rounded-[32px] p-6 flex items-center justify-between">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 bg-blue-600 rounded-2xl flex items-center justify-center text-white font-black text-xl">
                                            {{ selectedCustomer.name.charAt(0) }}
                                        </div>
                                        <div>
                                            <p class="font-black text-slate-900 leading-none">{{ selectedCustomer.name }}</p>
                                            <p class="text-[10px] text-blue-600 font-bold mt-1 uppercase tracking-widest">{{ selectedCustomer.points }} Poin Tersedia</p>
                                        </div>
                                    </div>
                                    <button @click="deselectCustomer" class="text-slate-400 hover:text-red-500 transition-colors">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                                    </button>
                                </div>

                                <!-- Customer Search Input -->
                                <div v-else class="flex gap-2">
                                    <div class="relative group flex-1">
                                        <svg class="absolute left-6 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                        <input 
                                            v-model="customerSearch"
                                            @input="searchCustomer"
                                            type="text" 
                                            placeholder="Cari Member / No. HP..." 
                                            class="w-full bg-slate-50 border-slate-100 rounded-[28px] py-4 pl-14 pr-6 text-sm font-bold focus:bg-white focus:border-blue-600 transition-all outline-none"
                                        >
                                        
                                        <!-- Search Results Dropdown -->
                                        <div v-if="customerResults.length > 0" class="absolute top-full left-0 right-0 mt-2 bg-white border border-slate-200 rounded-3xl shadow-2xl z-50 overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
                                            <button 
                                                v-for="c in customerResults" 
                                                :key="c.id"
                                                @click="selectCustomer(c)"
                                                class="w-full p-4 flex items-center gap-4 hover:bg-slate-50 text-left transition-colors border-b border-slate-50 last:border-0"
                                            >
                                                <div class="w-8 h-8 bg-slate-100 rounded-lg flex items-center justify-center font-black text-xs text-slate-400">
                                                    {{ c.name.charAt(0) }}
                                                </div>
                                                <div>
                                                    <p class="font-bold text-slate-900 leading-none">{{ c.name }}</p>
                                                    <p class="text-[10px] text-slate-400 mt-1">{{ c.phone }} • {{ c.points }} Poin</p>
                                                </div>
                                            </button>
                                        </div>
                                    </div>
                                    <button 
                                        @click="isAddCustomerModalOpen = true"
                                        class="w-14 h-14 bg-blue-50 text-blue-600 rounded-[24px] flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all shadow-sm group"
                                        title="Tambah Pelanggan Baru"
                                    >
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                                    </button>
                                </div>

                                <!-- Point Redemption -->
                                <div v-if="selectedCustomer && selectedCustomer.points > 0" class="bg-slate-50 border border-slate-100 rounded-[32px] p-6 space-y-4 shadow-inner">
                                    <div class="flex justify-between items-end">
                                        <div>
                                            <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest mb-1">Tukarkan Poin</p>
                                            <p class="text-[8px] text-slate-400 font-bold uppercase italic">Maks: {{ maxPointsAllowed }} Poin (Rp {{ (maxPointsAllowed * props.loyaltySettings.point_value).toLocaleString() }})</p>
                                        </div>
                                        <div class="font-black text-blue-600 text-sm">
                                            - Rp {{ discountFromPoints.toLocaleString() }}
                                        </div>
                                    </div>
                                    <div class="relative flex items-center gap-4">
                                        <input 
                                            v-model="paymentForm.points_redeemed"
                                            type="range"
                                            min="0"
                                            :max="maxPointsAllowed"
                                            step="1"
                                            class="flex-1 h-2 bg-slate-200 rounded-full appearance-none cursor-pointer accent-blue-600"
                                        >
                                        <div class="w-16 text-center font-black text-slate-900 border-b-2 border-slate-200 pb-1">
                                            {{ paymentForm.points_redeemed }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Manual Discount Section -->
                        <div class="mb-8 text-left">
                            <button 
                                @click="isDiscountManualExpanded = !isDiscountManualExpanded"
                                class="w-full flex items-center justify-between p-4 lg:p-6 bg-slate-50 border border-slate-100 rounded-[28px] lg:rounded-[32px] hover:bg-slate-100 transition-all group mb-4"
                            >
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 bg-amber-100 text-amber-600 rounded-xl flex items-center justify-center">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"></path></svg>
                                    </div>
                                    <span class="text-[9px] lg:text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Potongan / Diskon Manual</span>
                                </div>
                                <div class="flex items-center gap-3">
                                    <span v-if="paymentForm.discount_amount > 0" class="text-[9px] font-black text-amber-600 uppercase tracking-widest bg-amber-100 px-3 py-1 rounded-full">- Rp {{ Number(paymentForm.discount_amount).toLocaleString() }}</span>
                                    <svg 
                                        class="w-5 h-5 text-slate-300 transition-transform duration-300" 
                                        :class="isDiscountManualExpanded ? 'rotate-180' : ''"
                                        fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                    >
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                            </button>

                            <div v-if="isDiscountManualExpanded || paymentForm.discount_amount > 0" class="bg-slate-50 border border-slate-200 rounded-[32px] p-6 space-y-4 animate-in fade-in slide-in-from-top-2 duration-300">
                                <div class="relative">
                                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-sm font-bold text-slate-400">Rp</span>
                                    <input 
                                        v-model="paymentForm.discount_amount"
                                        type="number"
                                        placeholder="Jumlah Diskon..."
                                        class="w-full bg-white border-slate-100 rounded-2xl py-3 pl-12 pr-4 text-sm font-bold focus:border-blue-600 transition-all outline-none"
                                    >
                                </div>
                                <input 
                                    v-model="paymentForm.discount_notes"
                                    type="text"
                                    placeholder="Catatan Diskon (misal: Diskon Ultah, Promo Jumat)"
                                    class="w-full bg-white border-slate-100 rounded-2xl py-3 px-4 text-xs font-medium focus:border-blue-600 transition-all outline-none"
                                >
                            </div>
                        </div>

                        <!-- Payment Method Select -->
                        <div class="space-y-3 lg:space-y-4 mb-6 lg:mb-10">
                            <label class="block text-[9px] lg:text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] ml-2 lg:ml-4">Metode Pembayaran</label>
                            <div class="grid grid-cols-3 gap-3 lg:gap-4">
                                <button 
                                    v-for="m in ['cash', 'qris', 'transfer']" 
                                    :key="m"
                                    @click="paymentForm.method = m"
                                    class="h-12 lg:h-20 rounded-xl lg:rounded-[28px] border-2 font-black uppercase text-[9px] lg:text-[10px] tracking-widest transition-all relative overflow-hidden group/btn"
                                    :class="paymentForm.method === m ? 'bg-blue-600 border-blue-600 text-white shadow-xl shadow-blue-600/20 scale-[1.02]' : 'bg-white border-slate-100 text-slate-400 hover:border-blue-600/30'"
                                >
                                    <span class="relative z-10">{{ m }}</span>
                                    <div v-if="paymentForm.method === m" class="absolute inset-0 bg-gradient-to-tr from-blue-700 to-blue-500 opacity-100"></div>
                                </button>
                            </div>
                        </div>

                        <div v-if="paymentForm.method === 'cash'" class="space-y-6 lg:space-y-8 mb-6 lg:mb-10 animate-in fade-in slide-in-from-top-4 duration-500">
                            <div class="bg-slate-50 border border-slate-200 rounded-3xl lg:rounded-[32px] p-6 lg:p-10">
                                <div class="space-y-4 lg:space-y-6">
                                    <div class="space-y-2 lg:space-y-3">
                                        <label class="block text-[9px] lg:text-[10px] font-black text-slate-400 uppercase tracking-widest">Tunai Diterima</label>
                                        <div class="relative">
                                            <span class="absolute left-0 top-1/2 -translate-y-1/2 text-xl lg:text-2xl font-black text-slate-300">Rp</span>
                                            <input 
                                                v-model="formattedPaymentAmount"
                                                type="text" 
                                                class="w-full bg-transparent border-0 border-b-2 border-slate-200 focus:border-blue-600 focus:ring-0 px-8 lg:px-10 py-2 lg:py-4 text-2xl lg:text-5xl font-black text-slate-900 transition-all placeholder:text-slate-200"
                                                placeholder="0"
                                            >
                                        </div>
                                    </div>
                                    <div class="flex justify-between items-center bg-white rounded-2xl lg:rounded-3xl p-4 lg:p-6 border border-slate-100 shadow-sm">
                                        <div class="space-y-0.5 lg:space-y-1">
                                            <span class="block text-[9px] lg:text-[10px] font-black text-slate-400 uppercase tracking-widest">Kembalian</span>
                                            <span class="block text-xl lg:text-2xl font-black text-green-600 tracking-tighter">
                                                Rp {{ Math.max(0, paymentForm.amount - finalTotalAfterDiscount).toLocaleString('id-ID') }}
                                            </span>
                                        </div>
                                        <div class="h-10 w-10 lg:h-12 lg:w-12 bg-green-50 rounded-xl lg:rounded-2xl flex items-center justify-center text-green-600">
                                            <svg class="w-5 h-5 lg:w-6 lg:h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <button 
                            @click="processPayment"
                            :disabled="paymentForm.method === 'cash' && paymentForm.amount < finalTotalAfterDiscount"
                            class="w-full h-14 lg:h-20 bg-blue-600 text-white rounded-2xl lg:rounded-3xl font-black text-base lg:text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:bg-slate-100 disabled:text-slate-300 disabled:shadow-none transition-all active:scale-[0.98]"
                        >
                            Selesaikan Pembayaran
                        </button>
                    </div>
                </div>
            </Teleport>

            <!-- Reservation Check-in Modal -->
            <Teleport to="body">
                <div v-if="isReservationModalOpen" class="fixed inset-0 bg-slate-900/60 backdrop-blur-xl z-[200] flex items-center justify-center p-4 text-slate-900 leading-normal">
                    <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-md p-10 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-500">
                        <div class="text-center mb-10">
                            <div class="w-20 h-20 bg-amber-500 rounded-[32px] flex items-center justify-center mx-auto mb-6 shadow-xl shadow-amber-500/20 text-white">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            </div>
                            <h3 class="text-3xl font-black tracking-tighter mb-2">Konfirmasi Reservasi</h3>
                            <p class="text-slate-500 font-medium">Meja {{ selectedTableForOrder?.table_number }} telah dipesan untuk saat ini.</p>
                        </div>

                        <div class="bg-amber-50 border border-amber-100 rounded-[32px] p-8 mb-10 text-left">
                            <div class="space-y-4">
                                <div>
                                    <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-1">Nama Pelanggan</p>
                                    <p class="text-xl font-black text-slate-900 tracking-tighter">{{ activeReservation?.customer?.name }}</p>
                                </div>
                                <div>
                                    <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-1">Nomor Telepon</p>
                                    <p class="font-bold text-slate-600">{{ activeReservation?.customer?.phone }}</p>
                                </div>
                                <div class="grid grid-cols-2 gap-4 pt-4 border-t border-amber-100">
                                    <div>
                                        <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-1">Jam</p>
                                        <p class="font-bold text-slate-900">{{ new Date(activeReservation?.reservation_time).toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' }) }}</p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-black text-amber-600 uppercase tracking-widest mb-1">Jumlah Orang</p>
                                        <p class="font-bold text-slate-900">{{ activeReservation?.num_people }} Orang</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 gap-4">
                            <button 
                                @click="handleCheckIn"
                                class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-[0.98]"
                            >
                                Check-in Sekarang
                            </button>
                            <button 
                                @click="isReservationModalOpen = false; activeReservation = null; openOrderModal('dine_in', selectedTableForOrder)"
                                class="w-full h-14 text-slate-400 font-black text-xs uppercase tracking-[0.2em] hover:text-slate-600 transition-colors"
                            >
                                Abaikan & Buka Meja
                            </button>
                        </div>
                    </div>
                </div>
            </Teleport>

            <!-- Unified Order Modal -->
            <Teleport to="body">
                <div v-if="isOrderModalOpen" class="fixed inset-0 bg-slate-900/40 backdrop-blur-md z-[100] flex items-center justify-center p-0 lg:p-6 text-slate-900">
                    <div class="bg-white border-slate-200 rounded-none lg:rounded-[56px] w-full max-w-6xl h-full lg:h-[85vh] flex flex-col lg:flex-row overflow-hidden shadow-2xl animate-in zoom-in-95 duration-300">
                        <!-- Main Content (Menu Side) -->
                        <div class="flex-1 p-4 lg:p-12 overflow-y-auto custom-scrollbar flex flex-col h-full">
                            <div class="flex justify-between items-center mb-4 lg:mb-10 text-slate-900">
                                <div>
                                    <h3 class="text-lg lg:text-3xl font-black text-slate-900 tracking-tighter">{{ orderType === 'takeaway' ? 'Pesanan Bungkus' : `Pesanan Meja ${selectedTableForOrder?.table_number}` }}</h3>
                                    <p class="text-slate-400 text-[9px] font-bold uppercase tracking-widest mt-1">Pilih menu untuk ditambahkan</p>
                                </div>
                                <button @click="isOrderModalOpen = false" class="text-slate-400 hover:text-slate-600">
                                    <svg class="w-6 h-6 lg:w-8 lg:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                                </button>
                            </div>

                            <!-- Search & Filter Area -->
                            <div class="space-y-4 lg:space-y-6 mb-6 lg:mb-8">
                                <!-- Search Input -->
                                <div class="relative">
                                    <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 lg:w-5 lg:h-5 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                    <input 
                                        v-model="searchQuery"
                                        type="text" 
                                        placeholder="Cari menu..." 
                                        class="w-full bg-slate-50 border-slate-100 rounded-xl lg:rounded-2xl py-3 lg:py-4 pl-10 lg:pl-14 pr-4 text-xs lg:text-sm font-bold focus:bg-white focus:border-blue-600 transition-all outline-none placeholder:text-slate-300"
                                    >
                                </div>

                                <!-- Category Filter -->
                                <div class="flex flex-nowrap overflow-x-auto gap-2 pb-2 custom-scrollbar -mx-2 px-2 scroll-smooth no-scrollbar">
                                    <button 
                                        @click="selectedCategoryId = null"
                                        class="px-5 py-2 rounded-full text-[9px] font-black uppercase tracking-widest border transition-all whitespace-nowrap"
                                        :class="selectedCategoryId === null ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-white border-slate-100 text-slate-400 hover:border-slate-300'"
                                    >
                                        Semua
                                    </button>
                                    <button 
                                        v-for="cat in uniqueCategories" 
                                        :key="cat.id"
                                        @click="selectedCategoryId = cat.id"
                                        class="px-5 py-2 rounded-full text-[9px] font-black uppercase tracking-widest border transition-all whitespace-nowrap"
                                        :class="selectedCategoryId === cat.id ? 'bg-blue-600 border-blue-600 text-white shadow-lg shadow-blue-600/20' : 'bg-white border-slate-100 text-slate-400 hover:border-slate-300'"
                                    >
                                        {{ cat.name }}
                                    </button>
                                </div>
                            </div>

                            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-3 lg:gap-6 pb-24 lg:pb-0">
                                <div 
                                    v-for="menu in filteredMenus" 
                                    :key="menu.id"
                                    @click="handleMenuClick(menu)"
                                    class="bg-white border border-slate-100 rounded-[18px] lg:rounded-[24px] p-3 lg:p-4 flex flex-col hover:border-blue-600 hover:shadow-xl transition-all cursor-pointer group relative h-full min-h-[100px] lg:min-h-[140px]"
                                    :class="menu.stock <= 0 ? 'opacity-60 grayscale-[0.5] cursor-not-allowed' : ''"
                                >
                                    <div v-if="menu.stock <= 0" class="absolute inset-0 z-20 flex items-center justify-center pointer-events-none">
                                        <span class="bg-red-600 text-white text-[8px] lg:text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest shadow-lg">Stok Habis</span>
                                    </div>
                                    <div v-if="getMenuQuantity(menu.id) > 0" class="absolute -top-1 -right-1 w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-[9px] font-black shadow-lg shadow-blue-600/20 border-2 border-white z-10 animate-in zoom-in duration-300">
                                        {{ getMenuQuantity(menu.id) }}
                                    </div>
                                    <div class="flex-1">
                                        <h4 class="font-black text-slate-900 text-[11px] lg:text-base mb-1 tracking-tight leading-tight group-hover:text-blue-600 transition-colors">{{ menu.name }}</h4>
                                        <p v-if="menu.description" class="text-[8px] lg:text-[10px] text-slate-400 font-medium leading-relaxed line-clamp-2 mb-1">
                                            {{ menu.description }}
                                        </p>
                                    </div>
                                    <div class="mt-auto border-t border-slate-50 pt-2 lg:pt-3 flex justify-between items-center">
                                        <p class="text-blue-600 font-black text-[11px] lg:text-sm">Rp {{ Number(menu.price).toLocaleString('id-ID') }}</p>
                                        <p class="text-[8px] font-bold uppercase tracking-tighter" :class="menu.stock <= 5 ? 'text-red-500' : 'text-slate-300'">Stok: {{ menu.stock }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Cart Drawer / Side (Scenario A) -->
                        <div>
                            <!-- Overlay to close cart on mobile -->
                            <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0" enter-to-class="opacity-100" leave-active-class="transition duration-200 ease-in" leave-from-class="opacity-100" leave-to-class="opacity-0">
                                <div v-if="isCartExpanded" @click="isCartExpanded = false" class="lg:hidden fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-[110]"></div>
                            </Transition>

                            <div 
                                class="fixed lg:relative bottom-0 right-0 w-full lg:w-[400px] transition-all duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] z-[120] lg:z-auto"
                                :class="[
                                    isCartExpanded ? 'translate-y-0 h-[80vh] lg:h-full' : 'translate-y-full h-0 lg:h-full lg:translate-y-0'
                                ]"
                            >
                                <div class="h-full bg-white lg:bg-slate-50 border-t lg:border-t-0 lg:border-l border-slate-200 p-6 lg:p-12 flex flex-col relative overflow-hidden text-slate-900 rounded-t-[40px] lg:rounded-none shadow-[0_-20px_50px_-12px_rgba(0,0,0,0.15)] lg:shadow-none">
                                    <div class="hidden lg:block absolute -top-24 -right-24 w-64 h-64 bg-blue-600/5 rounded-full blur-3xl"></div>
                                    
                                    <!-- Mobile Drawer Handle -->
                                    <div class="lg:hidden w-12 h-1.5 bg-slate-200 rounded-full mx-auto mb-8 cursor-pointer" @click="isCartExpanded = false"></div>

                                    <h4 class="font-black text-slate-400 mb-6 lg:mb-8 uppercase tracking-[0.2em] text-[10px] relative z-10">Ringkasan Pesanan</h4>
                                    
                                    <!-- Customer Selection in Order Phase -->
                                    <div class="mb-8 relative z-20">
                                        <div v-if="selectedCustomer" class="bg-blue-600 text-white rounded-3xl p-5 flex items-center justify-between shadow-lg shadow-blue-600/20 animate-in zoom-in duration-300">
                                            <div class="flex items-center gap-4">
                                                <div class="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center font-black text-sm">
                                                    {{ selectedCustomer.name.charAt(0) }}
                                                </div>
                                                <div>
                                                    <p class="font-black text-sm tracking-tight leading-none mb-1">{{ selectedCustomer.name }}</p>
                                                    <p class="text-[10px] text-blue-100 font-bold opacity-80">{{ selectedCustomer.phone }} • {{ selectedCustomer.points }} Poin</p>
                                                </div>
                                            </div>
                                            <button @click="deselectCustomer" class="text-white/60 hover:text-white transition-colors">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                                            </button>
                                        </div>
                                        <div v-else class="flex gap-2">
                                            <div class="relative group flex-1">
                                                <svg class="absolute left-4 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                                                <input 
                                                    v-model="customerSearch"
                                                    @input="searchCustomer"
                                                    type="text" 
                                                    placeholder="Pilih Member..." 
                                                    class="w-full bg-white border border-slate-100 rounded-2xl py-3 pl-10 pr-4 text-[10px] lg:text-xs font-bold focus:border-blue-600 transition-all outline-none"
                                                >
                                                <!-- Search Results -->
                                                <div v-if="customerResults.length > 0" class="absolute top-full left-0 right-0 mt-2 bg-white border border-slate-200 rounded-2xl shadow-2xl z-50 overflow-hidden">
                                                    <button 
                                                        v-for="c in customerResults" 
                                                        :key="c.id"
                                                        @click="selectCustomer(c)"
                                                        class="w-full p-3 flex items-center gap-3 hover:bg-slate-50 text-left transition-colors border-b border-slate-50 last:border-0"
                                                    >
                                                        <div class="w-6 h-6 bg-slate-100 rounded flex items-center justify-center font-black text-[10px] text-slate-400">
                                                            {{ c.name.charAt(0) }}
                                                        </div>
                                                        <div>
                                                            <p class="font-bold text-slate-900 text-[11px] leading-none">{{ c.name }}</p>
                                                            <p class="text-[9px] text-slate-400 mt-0.5">{{ c.phone }}</p>
                                                        </div>
                                                    </button>
                                                </div>
                                            </div>
                                            <button 
                                                @click="isAddCustomerModalOpen = true"
                                                class="w-10 h-10 lg:w-11 lg:h-11 bg-slate-100 text-slate-400 rounded-2xl flex items-center justify-center hover:bg-blue-600 hover:text-white transition-all group"
                                            >
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="flex-1 overflow-y-auto space-y-4 lg:space-y-6 relative z-10 custom-scrollbar pr-2">
                                        <div v-if="orderCart.length === 0" class="h-full flex flex-col items-center justify-center text-center py-8">
                                            <span class="text-3xl lg:text-4xl mb-4 opacity-20">🛒</span>
                                            <p class="text-slate-300 font-bold uppercase tracking-widest text-[10px]">Keranjang masih kosong</p>
                                        </div>
                                        <div v-for="item in orderCart" :key="item.id" class="flex justify-between items-center group animate-in slide-in-from-bottom-2 duration-300">
                                            <div class="flex-1">
                                                <p class="text-slate-900 font-bold text-xs lg:text-sm tracking-tight leading-none mb-1">
                                                    {{ item.quantity }}x {{ item.name }}
                                                    <span v-if="item.variant_name" class="text-[10px] text-blue-600 ml-1">({{ item.variant_name }})</span>
                                                </p>
                                                <p class="text-[9px] lg:text-[10px] font-mono text-slate-400 whitespace-nowrap">@ Rp {{ Number(item.price).toLocaleString() }}</p>
                                            </div>
                                            <div class="flex flex-col items-end">
                                                <span class="text-xs lg:text-sm font-black text-blue-600/50">Rp {{ (item.price * item.quantity).toLocaleString('id-ID') }}</span>
                                                <div class="flex items-center gap-2 mt-2">
                                                    <button @click.stop="item.quantity > 1 ? item.quantity-- : orderCart = orderCart.filter(i => i.id !== item.id)" class="w-7 h-7 rounded-xl bg-white border border-slate-200 flex items-center justify-center text-slate-400 hover:text-red-500 active:scale-95 transition-all shadow-sm">-</button>
                                                    <button @click.stop="item.quantity++" class="w-7 h-7 rounded-xl bg-white border border-slate-200 flex items-center justify-center text-slate-400 hover:text-blue-600 active:scale-95 transition-all shadow-sm">+</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="pt-6 lg:pt-10 mt-6 lg:mt-10 border-t border-slate-200 relative z-10">
                                        <div class="flex justify-between mb-6 lg:mb-8">
                                            <span class="font-black text-slate-400 text-[10px] uppercase tracking-widest">Total Harga</span>
                                            <span class="font-black text-2xl lg:text-3xl text-blue-600 tracking-tighter">Rp {{ orderTotal.toLocaleString('id-ID') }}</span>
                                        </div>
                                        <div class="flex flex-col lg:flex-none gap-3">
                                            <button 
                                                @click="submitOrderAction"
                                                :disabled="orderCart.length === 0"
                                                class="w-full h-14 lg:h-16 bg-blue-600 text-white rounded-2xl font-black text-xs tracking-widest uppercase shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:bg-slate-200 disabled:text-slate-400 disabled:shadow-none transition-all active:scale-[0.98]"
                                            >
                                                Konfirmasi Pesanan
                                            </button>
                                            <button @click="isCartExpanded = false" class="lg:hidden w-full h-10 text-slate-400 font-black text-[10px] uppercase tracking-[0.2em] hover:text-slate-600 transition-colors">Tambah Menu Lagi</button>
                                            <button @click="isOrderModalOpen = false" class="hidden lg:block w-full h-10 text-slate-400 font-black text-[10px] uppercase tracking-[0.2em] hover:text-slate-600 transition-colors">Batalkan & Tutup</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Horizontal Floating Bar (Scenario A) -->
                            <div 
                                v-if="orderCart.length > 0 && !isCartExpanded" 
                                class="lg:hidden fixed bottom-6 left-6 right-6 z-[105] animate-in slide-in-from-bottom-6 transition-all duration-300"
                            >
                                <div 
                                    @click="isCartExpanded = true"
                                    class="bg-blue-600 border border-blue-500 rounded-[28px] p-4 flex items-center justify-between shadow-2xl shadow-blue-600/40 text-white cursor-pointer active:scale-[0.98] transition-all"
                                >
                                    <div class="flex items-center gap-4">
                                        <div class="w-10 h-10 bg-white/20 rounded-2xl flex items-center justify-center font-black">
                                            {{ orderCart.reduce((sum, item) => sum + item.quantity, 0) }}
                                        </div>
                                        <div>
                                            <p class="text-[9px] font-black uppercase tracking-widest text-white/60 mb-0.5">Ringkasan Pesanan</p>
                                            <p class="text-lg font-black tracking-tighter">Rp {{ orderTotal.toLocaleString('id-ID') }}</p>
                                        </div>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span class="text-[9px] font-black uppercase tracking-widest">Review</span>
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 15l7-7 7 7"></path></svg>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </Teleport>

            <!-- Open Shift Modal (Mandatory) -->
            <Teleport to="body">
                <div v-if="!props.activeShift" class="fixed inset-0 bg-slate-900/60 backdrop-blur-xl z-[200] flex items-center justify-center p-4 text-slate-900 leading-normal">
                    <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-md p-10 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-500">
                        <div class="text-center mb-10">
                            <div class="w-20 h-20 bg-blue-600 rounded-[32px] flex items-center justify-center mx-auto mb-6 shadow-xl shadow-blue-600/20 text-white">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                            </div>
                            <h3 class="text-3xl font-black tracking-tighter mb-2">Buka Shift Kasir</h3>
                            <p class="text-slate-500 font-medium">Masukkan modal awal untuk memulai shift hari ini.</p>
                        </div>

                        <div class="space-y-8 mb-10">
                            <div class="space-y-4 text-left">
                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Uang Modal Awal</label>
                                <div class="relative items-center flex">
                                    <span class="absolute left-0 text-2xl font-black text-slate-300">Rp</span>
                                    <input 
                                        v-model="formattedOpeningCash"
                                        type="text" 
                                        class="w-full bg-transparent border-0 border-b-2 border-slate-200 focus:border-blue-600 focus:ring-0 px-10 py-4 text-4xl font-black text-slate-900 transition-all placeholder:text-slate-200"
                                        placeholder="0"
                                    >
                                </div>
                            </div>
                        </div>

                        <button 
                            @click="startShift"
                            :disabled="openingCashForm.opening_cash < 0"
                            class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-[0.98]"
                        >
                            Mulai Kasir
                        </button>
                    </div>
                </div>
            </Teleport>

            <!-- End Shift Modal -->
            <Teleport to="body">
                <div v-if="isEndShiftModalOpen" class="fixed inset-0 bg-slate-900/60 backdrop-blur-xl z-[200] flex items-center justify-center p-4 text-slate-900 leading-normal">
                    <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-lg p-10 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-500 overflow-y-auto max-h-[90vh] custom-scrollbar">
                        <div class="flex justify-between items-center mb-10">
                            <h3 class="text-3xl font-black tracking-tighter uppercase">Tutup Shift</h3>
                            <button @click="isEndShiftModalOpen = false" class="text-slate-300 hover:text-slate-600 transition-colors">
                                <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                            </button>
                        </div>

                        <div class="bg-slate-50 border border-slate-100 rounded-[40px] p-8 mb-10 text-left">
                            <div class="space-y-4">
                                <div class="flex justify-between items-center pb-4 border-b border-slate-200">
                                    <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Modal Awal</span>
                                    <span class="font-bold">Rp {{ Number(props.activeShift?.opening_cash).toLocaleString() }}</span>
                                </div>
                                <div class="flex justify-between items-center pb-4 border-b border-slate-200">
                                    <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Pendapatan Tunai</span>
                                    <span class="font-bold text-green-600">+ Rp {{ Number(dailyStats.revenue).toLocaleString('id-ID') }}</span>
                                </div>
                                <div class="flex justify-between items-center pt-2">
                                    <span class="text-[10px] font-black text-blue-600 uppercase tracking-widest">Ekspektasi Kas</span>
                                    <span class="text-2xl font-black">Rp {{ (Number(props.activeShift?.opening_cash) + Number(dailyStats.revenue)).toLocaleString('id-ID') }}</span>
                                </div>
                            </div>
                        </div>

                        <div class="space-y-8 mb-10 text-left">
                            <div class="space-y-4">
                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Total Uang Fisik Di Laci</label>
                                <div class="relative items-center flex">
                                    <span class="absolute left-0 text-2xl font-black text-slate-300">Rp</span>
                                    <input 
                                        v-model="formattedClosingCash"
                                        type="text" 
                                        class="w-full bg-transparent border-0 border-b-2 border-slate-200 focus:border-blue-600 focus:ring-0 px-10 py-4 text-4xl font-black text-slate-900 transition-all placeholder:text-slate-200"
                                        placeholder="0"
                                    >
                                </div>
                            </div>

                            <div class="space-y-4">
                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">Catatan Shift (Opsional)</label>
                                <textarea 
                                    v-model="closingCashForm.notes"
                                    rows="2"
                                    class="w-full bg-slate-50 border-0 rounded-2xl focus:ring-2 focus:ring-blue-600 p-4 text-sm font-medium"
                                    placeholder="Tulis catatan jika ada selisih uang..."
                                ></textarea>
                            </div>
                        </div>

                        <button 
                            @click="endShift"
                            class="w-full h-20 bg-slate-900 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-xl shadow-slate-900/20 hover:bg-slate-800 transition-all active:scale-[0.98]"
                        >
                            Tutup Kasir
                        </button>
                    </div>
                </div>
            </Teleport>

            <!-- Variant Selection Modal -->
            <Teleport to="body">
                <Transition
                    enter-active-class="transition duration-300 ease-out"
                    enter-from-class="opacity-0"
                    enter-to-class="opacity-100"
                    leave-active-class="transition duration-200 ease-in"
                    leave-from-class="opacity-100"
                    leave-to-class="opacity-0"
                >
                    <div v-if="isVariantModalOpen" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[250] flex items-center justify-center p-6 text-slate-900 leading-normal">
                        <div class="relative bg-white border border-slate-200 rounded-[48px] w-full max-w-md overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
                            <div class="p-10 border-b border-slate-100 text-center">
                                <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-2">Pilih Varian</p>
                                <h4 class="text-3xl font-black text-slate-900 tracking-tighter">{{ selectedMenuForVariant?.name }}</h4>
                            </div>

                            <div class="p-10 space-y-3 custom-scrollbar overflow-y-auto">
                                <button 
                                    v-for="v in selectedMenuForVariant?.variants" 
                                    :key="v.id"
                                    @click="selectVariant(v)"
                                    class="w-full h-20 px-8 rounded-[24px] bg-slate-50 border-2 border-transparent hover:border-blue-600 hover:bg-white flex items-center justify-between transition-all group"
                                >
                                    <span class="font-black text-slate-900 group-hover:text-blue-600 transition-colors">{{ v.name }}</span>
                                    <span class="font-black text-blue-600">Rp {{ Number(v.price).toLocaleString('id-ID') }}</span>
                                </button>
                            </div>

                            <div class="p-8 bg-slate-50 border-t border-slate-100 text-center">
                                <button @click="isVariantModalOpen = false; selectedMenuForVariant = null" class="text-slate-400 font-black text-[10px] uppercase tracking-widest hover:text-slate-600">Batal</button>
                            </div>
                        </div>
                    </div>
                </Transition>
            </Teleport>

            <!-- Customization Modal (Cashier) -->
            <Teleport to="body">
                <Transition
                    enter-active-class="transition duration-300 ease-out"
                    enter-from-class="opacity-0"
                    enter-to-class="opacity-100"
                    leave-active-class="transition duration-200 ease-in"
                    leave-from-class="opacity-100"
                    leave-to-class="opacity-0"
                >
                    <div v-if="showCustomModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[250] flex items-center justify-center p-6 text-slate-900 leading-normal">
                        <div class="relative bg-white border border-slate-200 rounded-[48px] w-full max-w-md overflow-hidden shadow-2xl flex flex-col max-h-[90vh]">
                            <!-- Header -->
                            <div class="p-10 border-b border-slate-100 text-center">
                                <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-2">Pilihan Menu</p>
                                <h4 class="text-3xl font-black text-slate-900 tracking-tighter">{{ selectedMenuForCustom?.name }}</h4>
                            </div>

                            <div class="flex-1 overflow-y-auto p-10 space-y-10 custom-scrollbar">
                                <!-- Rice Options -->
                                <div class="space-y-4 text-left">
                                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-2">PILIHAN NASI (Boleh Kosong)</label>
                                    <div class="grid grid-cols-1 gap-2">
                                        <button 
                                            v-for="opt in riceOptions" 
                                            :key="opt"
                                            @click="selectedRice = selectedRice === opt ? '' : opt"
                                            class="h-16 px-8 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                            :class="selectedRice === opt ? 'bg-blue-600 border-blue-600 text-white shadow-xl shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600'"
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
                                            @click="selectedSambal = selectedSambal === opt ? '' : opt"
                                            class="h-16 px-8 rounded-2xl flex items-center justify-between transition-all border-2 text-sm font-bold"
                                            :class="selectedSambal === opt ? 'bg-blue-600 border-blue-600 text-white shadow-xl shadow-blue-600/20' : 'bg-slate-50 border-transparent text-slate-600'"
                                        >
                                            {{ opt }}
                                            <div v-show="selectedSambal === opt" class="w-2 h-2 rounded-full bg-white"></div>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Footer -->
                            <div class="p-10 bg-slate-50 border-t border-slate-100">
                                <button 
                                    @click="confirmCustomization"
                                    class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 transition-all active:scale-[0.98]"
                                >
                                    Konfirmasi
                                </button>
                            </div>
                        </div>
                    </div>
                </Transition>
            </Teleport>
        </div>

        <template #summary>
            <div class="space-y-10">
                <div>
                    <h3 class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] mb-6">Denyut Hari Ini</h3>
                    <div class="space-y-4">
                        <div class="bg-white border border-slate-200 p-6 rounded-[28px] relative overflow-hidden group shadow-sm">
                            <div class="absolute -top-12 -right-12 w-24 h-24 bg-blue-600/5 rounded-full blur-xl group-hover:bg-blue-600/10 transition-all"></div>
                            <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest mb-1">Total Penjualan</p>
                            <p class="text-2xl font-black text-slate-900 tracking-tighter">Rp {{ dailyStats.revenue.toLocaleString('id-ID') }}</p>
                        </div>
                        <div class="bg-white border border-slate-200 p-6 rounded-[28px] relative overflow-hidden group shadow-sm">
                            <div class="absolute -top-12 -right-12 w-24 h-24 bg-indigo-500/5 rounded-full blur-xl group-hover:bg-indigo-500/10 transition-all"></div>
                            <p class="text-[10px] font-black text-indigo-600 uppercase tracking-widest mb-1">Pesanan Selesai</p>
                            <p class="text-2xl font-black text-slate-900 tracking-tighter">{{ dailyStats.orders }}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-blue-50 border border-blue-100 p-8 rounded-[32px] text-center">
                    <div class="w-12 h-12 bg-blue-100 rounded-2xl flex items-center justify-center mx-auto mb-4">
                        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <h4 class="font-black text-blue-600 text-[10px] uppercase tracking-widest mb-2">Pengingat Shift</h4>
                    <p class="text-slate-400 text-[10px] leading-relaxed font-bold uppercase tracking-tighter">
                        Pastikan semua pesanan berstatus "Dibayar" sebelum pembersihan server pada jam 23:00.
                    </p>
                </div>
            </div>
        </template>
        <!-- Quick Action Modal for Occupied Table -->
        <Teleport to="body">
            <Transition
                enter-active-class="transition duration-300 ease-out"
                enter-from-class="translate-y-full lg:translate-y-0 lg:scale-95 lg:opacity-0"
                enter-to-class="translate-y-0 lg:scale-100 lg:opacity-100"
                leave-active-class="transition duration-200 ease-in"
                leave-from-class="translate-y-0 lg:scale-100 lg:opacity-100"
                leave-to-class="translate-y-full lg:translate-y-0 lg:scale-95 lg:opacity-0"
            >
                <div v-show="isQuickActionModalOpen" class="fixed inset-0 z-[150] flex items-end lg:items-center justify-center p-0 lg:p-6">
                    <div @click="isQuickActionModalOpen = false" class="absolute inset-0 bg-slate-900/40 backdrop-blur-md"></div>
                    
                    <div class="relative bg-white border border-slate-200 rounded-t-[40px] lg:rounded-[48px] w-full max-w-lg overflow-hidden shadow-2xl flex flex-col max-h-[90vh] animate-in slide-in-from-bottom duration-500">
                        <!-- Handle for Mobile -->
                        <div class="lg:hidden absolute top-4 left-1/2 -translate-x-1/2 w-12 h-1.5 bg-slate-100 rounded-full"></div>

                        <!-- Header -->
                        <div class="p-8 border-b border-slate-100 flex justify-between items-start mt-2 lg:mt-0">
                            <div class="space-y-1">
                                <div class="flex items-center gap-2">
                                    <p class="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em]">Meja {{ selectedOrderForQuickAction?.table?.table_number }}</p>
                                    <span class="w-1.5 h-1.5 rounded-full bg-green-500 animate-pulse"></span>
                                </div>
                                <h4 class="text-2xl font-black text-slate-900 tracking-tighter">#{{ selectedOrderForQuickAction?.order_number }}</h4>
                            </div>
                            <button @click="isQuickActionModalOpen = false" class="w-10 h-10 flex items-center justify-center bg-slate-50 rounded-2xl text-slate-400 hover:text-slate-600 transition-colors">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                            </button>
                        </div>

                        <div class="flex-1 overflow-y-auto p-8 space-y-8 no-scrollbar">
                            <!-- Order Stats -->
                            <div class="grid grid-cols-2 gap-4">
                                <div class="bg-blue-600/5 border border-blue-600/10 p-5 rounded-3xl">
                                    <p class="text-[9px] font-black text-blue-600/60 uppercase tracking-widest mb-1">Total Tunai</p>
                                    <p class="text-xl font-black text-slate-900 tracking-tighter">Rp {{ Number(selectedOrderForQuickAction?.total_price || 0).toLocaleString('id-ID') }}</p>
                                </div>
                                <div class="bg-slate-50 border border-slate-100 p-5 rounded-3xl">
                                    <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest mb-1">Status</p>
                                    <span class="inline-flex px-2.5 py-1 bg-white border border-slate-200 rounded-full text-[8px] font-black text-slate-900 uppercase tracking-widest">
                                        {{ selectedOrderForQuickAction?.status }}
                                    </span>
                                </div>
                            </div>

                            <!-- Detail Items -->
                            <div class="space-y-4">
                                <h5 class="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Ringkasan Pesanan</h5>
                                <div class="space-y-3 bg-white border border-slate-100 p-6 rounded-[32px]">
                                    <div v-for="item in selectedOrderForQuickAction?.order_items" :key="item.id" class="flex justify-between items-start gap-4 text-sm">
                                        <div class="flex-1">
                                            <p class="font-bold text-slate-900 leading-tight">
                                                {{ item.quantity }}x {{ item.menu?.name }}
                                                <span v-if="item.variant" class="text-blue-600 ml-1">({{ item.variant.name }})</span>
                                            </p>
                                            <p v-if="item.notes" class="text-[10px] text-blue-600 font-medium mt-0.5">* {{ item.notes }}</p>
                                        </div>
                                        <span class="font-black text-slate-900 whitespace-nowrap">Rp {{ (item.price_at_time * item.quantity).toLocaleString('id-ID') }}</span>
                                    </div>
                                    <div class="pt-4 border-t border-slate-50 flex justify-between items-center">
                                        <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Estimasi</span>
                                        <span class="text-lg font-black text-slate-900">Rp {{ Number(selectedOrderForQuickAction?.total_price || 0).toLocaleString('id-ID') }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Actions Area -->
                        <div class="p-8 bg-slate-50 border-t border-slate-100 space-y-4">
                            <!-- Primary Actions -->
                            <div class="grid grid-cols-2 gap-3">
                                <button 
                                    @click="selectOrderAction(selectedOrderForQuickAction)"
                                    class="h-16 bg-blue-600 text-white rounded-2xl font-black text-[10px] uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 active:scale-95 transition-all flex flex-col items-center justify-center gap-1"
                                >
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                                    <span>BAYAR SEKARANG</span>
                                </button>
                                <button 
                                    @click="continueOrder(selectedOrderForQuickAction)"
                                    class="h-16 bg-white border-2 border-slate-200 text-slate-900 rounded-2xl font-black text-[10px] uppercase tracking-widest hover:border-blue-600 hover:text-blue-600 active:scale-95 transition-all flex flex-col items-center justify-center gap-1 shadow-sm"
                                >
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                    <span>TAMBAH MENU</span>
                                </button>
                            </div>
                            
                            <!-- Secondary Actions -->
                            <div class="grid grid-cols-3 gap-3">
                                <button 
                                    @click="triggerPrint(selectedOrderForQuickAction, 'customer')"
                                    class="h-14 bg-white border border-slate-200 text-slate-600 rounded-2xl font-black text-[8px] uppercase tracking-widest transition-all hover:bg-slate-100 flex flex-col items-center justify-center gap-1"
                                >
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
                                    <span>Bill Sementara</span>
                                </button>
                                <button 
                                    @click="triggerPrint(selectedOrderForQuickAction, 'customer')"
                                    class="h-14 bg-white border border-slate-200 text-slate-600 rounded-2xl font-black text-[8px] uppercase tracking-widest transition-all hover:bg-slate-100 flex flex-col items-center justify-center gap-1"
                                >
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.111 16.404a5.5 5.5 0 017.778 0M12 20h.01m-7.08-7.071a9.5 9.5 0 0113.435 0"></path></svg>
                                    <span>CETAK BT</span>
                                </button>
                                <button 
                                    @click="triggerPrint(selectedOrderForQuickAction, 'kitchen_qc')"
                                    class="h-14 bg-white border border-slate-200 text-slate-600 rounded-2xl font-black text-[8px] uppercase tracking-widest transition-all hover:bg-slate-100 flex flex-col items-center justify-center gap-1"
                                >
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11l-8 8-4-4m0-8l8 8 4-4"></path></svg>
                                    <span>CETAK DAPUR</span>
                                </button>
                                <button 
                                    @click="confirmOrder(selectedOrderForQuickAction)"
                                    v-if="selectedOrderForQuickAction?.status === 'pending'"
                                    class="h-14 bg-green-50 text-green-600 border border-green-200 rounded-2xl font-black text-[8px] uppercase tracking-widest transition-all hover:bg-green-100 flex flex-col items-center justify-center gap-1"
                                >
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                                    <span>KONFIRMASI</span>
                                </button>
                                <div v-else class="h-14 flex flex-col items-center justify-center bg-slate-50 border border-slate-100 rounded-2xl opacity-50">
                                    <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                    <span class="text-[7px] font-black text-slate-400 uppercase tracking-widest mt-1">SIAP</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </Transition>
        </Teleport>

        <!-- Add Customer Modal -->
        <Teleport to="body">
            <div v-if="isAddCustomerModalOpen" class="fixed inset-0 bg-slate-900/60 backdrop-blur-xl z-[300] flex items-center justify-center p-4 text-slate-900 leading-normal">
                <div class="bg-white border border-slate-200 rounded-[48px] w-full max-w-md p-10 lg:p-12 shadow-2xl animate-in zoom-in-95 duration-500">
                    <div class="text-center mb-10">
                        <div class="w-20 h-20 bg-blue-600 rounded-[32px] flex items-center justify-center mx-auto mb-6 shadow-xl shadow-blue-600/20 text-white">
                            <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path></svg>
                        </div>
                        <h3 class="text-3xl font-black tracking-tighter mb-2">Tambah Member</h3>
                        <p class="text-slate-500 font-medium text-sm">Daftarkan pelanggan baru untuk mulai mengumpulkan poin loyalty.</p>
                    </div>

                    <div class="space-y-6 mb-10">
                        <div class="space-y-2 text-left">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-4">Nama Pelanggan</label>
                            <input 
                                v-model="newCustomerForm.name"
                                type="text" 
                                class="w-full bg-slate-50 border-0 border-b-2 border-slate-100 focus:border-blue-600 focus:ring-0 px-6 py-4 rounded-2xl text-lg font-bold transition-all placeholder:text-slate-200"
                                placeholder="Masukkan Nama Lengkap..."
                            >
                        </div>
                        <div class="space-y-2 text-left">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-4">Nomor WhatsApp / HP</label>
                            <input 
                                v-model="newCustomerForm.phone"
                                type="tel" 
                                class="w-full bg-slate-50 border-0 border-b-2 border-slate-100 focus:border-blue-600 focus:ring-0 px-6 py-4 rounded-2xl text-lg font-bold transition-all placeholder:text-slate-200"
                                placeholder="0812XXXXXXXX..."
                            >
                        </div>
                    </div>

                    <div class="grid grid-cols-1 gap-4">
                        <button 
                            @click="addNewCustomer"
                            :disabled="!newCustomerForm.name || !newCustomerForm.phone"
                            class="w-full h-20 bg-blue-600 text-white rounded-3xl font-black text-xl uppercase tracking-widest shadow-lg shadow-blue-600/20 hover:bg-blue-700 disabled:bg-slate-100 disabled:text-slate-300 transition-all active:scale-[0.98]"
                        >
                            Simpan & Pilih
                        </button>
                        <button 
                            @click="isAddCustomerModalOpen = false"
                            class="w-full h-14 text-slate-400 font-black text-xs uppercase tracking-[0.2em] hover:text-slate-600 transition-colors"
                        >
                            Batalkan
                        </button>
                    </div>
                </div>
            </div>
        </Teleport>
    </AuthenticatedLayout>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.05); border-radius: 10px; }
.custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(37,99,235,0.2); }
.no-scrollbar::-webkit-scrollbar { display: none; }
.no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
</style>
