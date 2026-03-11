<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Link, router, usePage } from '@inertiajs/vue3';

const props = defineProps<{
    hideSidebar?: boolean;
}>();

const showingNavigationDropdown = ref(false);
const isSidebarOpen = ref(!props.hideSidebar);
const isLoaded = ref(false);

onMounted(() => {
    isLoaded.value = true;
});

const logout = () => {
    router.post(route('logout'));
};
</script>

<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 font-sans selection:bg-blue-600 selection:text-white overflow-x-hidden">
        <!-- Mobile Sidebar Overlay -->
        <div 
            v-if="!hideSidebar && isSidebarOpen" 
            @click="isSidebarOpen = false" 
            class="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-40 lg:hidden transition-opacity duration-300"
        ></div>

        <!-- Sidebar -->
        <aside 
            v-if="!hideSidebar"
            class="fixed left-0 top-0 h-full bg-white border-r border-slate-200 z-50 transition-all duration-500 ease-in-out shadow-xl shadow-slate-200/50"
            :class="[
                isSidebarOpen ? 'w-72 translate-x-0' : 'w-24 -translate-x-full lg:translate-x-0', 
                !isLoaded && '-translate-x-full'
            ]"
        >
            <div class="flex flex-col h-full p-6">
                <!-- Logo Area -->
                <div class="mb-12 flex items-center gap-4">
                    <div class="h-12 w-12 bg-blue-600 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-600/20">
                        <span class="text-2xl font-black text-white">A</span>
                    </div>
                    <div v-if="isSidebarOpen" class="transition-opacity duration-300">
                        <h2 class="font-black text-xl tracking-tighter text-slate-900">ALIRA</h2>
                        <p class="text-[10px] text-blue-600 font-bold uppercase tracking-widest mt-[-2px]">Malaka POS</p>
                    </div>
                </div>

                <!-- Navigation -->
                <nav class="flex-1 space-y-2">
                    <Link 
                        :href="route('dashboard')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('dashboard') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('dashboard')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Ringkasan</span>
                    </Link>

                    <Link 
                        :href="route('cashier.index')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('cashier.*') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('cashier.*')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Meja Kasir</span>
                    </Link>

                    <Link 
                        :href="route('admin.menus')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.menus') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.menus')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Manajer Menu</span>
                    </Link>

                    <div class="h-[1px] bg-slate-100 my-4"></div>

                    <Link 
                        :href="route('admin.dashboard')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.dashboard') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.dashboard')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 8v8m-4-5v5m-4-2v2m-2 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Ringkasan</span>
                    </Link>

                    <Link 
                        :href="route('admin.reports')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.reports') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.reports')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2a4 4 0 00-4-4H5m11 2a4 4 0 00-4-4h-1m1 8v-2a4 4 0 014-4h1m-11 8a4 4 0 01-4-4V5a2 2 0 012-2h14a2 2 0 012 2v8a4 4 0 01-4 4h-1" /></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Laporan Penjualan</span>
                    </Link>

                    <Link 
                        :href="route('admin.transactions')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.transactions') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.transactions')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Riwayat Transaksi</span>
                    </Link>

                    <Link 
                        :href="route('admin.customers.index')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.customers.*') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.customers.*')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Pelanggan & Loyalty</span>
                    </Link>

                    <Link 
                        :href="route('admin.reservations.index')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.reservations.*') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.reservations.*')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Reservasi Meja</span>
                    </Link>

                    <Link 
                        :href="route('admin.settings')"
                        class="flex items-center gap-4 px-4 py-4 rounded-2xl transition-all duration-300 group relative"
                        :class="route().current('admin.settings') ? 'bg-blue-50 text-blue-700 font-bold' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'"
                    >
                        <div v-if="route().current('admin.settings')" class="absolute left-0 w-1 h-6 bg-blue-600 rounded-r-full"></div>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <span v-if="isSidebarOpen" class="font-medium whitespace-nowrap">Pengaturan</span>
                    </Link>
                </nav>

                <!-- Footer User -->
                <div class="mt-auto">
                    <div class="bg-blue-50/50 border border-blue-50 rounded-3xl p-4 mb-4" v-if="isSidebarOpen">
                        <p class="text-[10px] font-black text-blue-600/40 uppercase tracking-widest mb-1">Masuk sebagai</p>
                        <p class="font-bold text-sm truncate text-slate-900">{{ $page.props.auth.user.name }}</p>
                    </div>
                    <button 
                        @click="logout"
                        class="w-full flex items-center gap-4 px-4 py-4 rounded-2xl text-red-400 hover:bg-red-400/10 transition-all duration-300"
                    >
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                        <span v-if="isSidebarOpen" class="font-bold text-sm uppercase tracking-widest whitespace-nowrap">Keluar</span>
                    </button>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main 
            class="transition-all duration-500 ease-in-out min-h-screen"
            :class="[hideSidebar ? 'pl-0' : (isSidebarOpen ? 'lg:pl-72' : 'lg:pl-24')]"
        >
            <!-- Top Header -->
            <header class="h-20 lg:h-24 flex items-center justify-between px-6 lg:px-12 border-b border-slate-200 sticky top-0 bg-white/80 backdrop-blur-xl z-40">
                <div class="flex items-center gap-4 lg:gap-6">
                    <!-- Mobile Hamburger -->
                    <button 
                        v-if="!hideSidebar"
                        @click="isSidebarOpen = !isSidebarOpen"
                        class="lg:hidden h-10 w-10 flex items-center justify-center rounded-xl bg-slate-100 hover:bg-slate-200 transition-colors text-slate-600"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path v-if="!isSidebarOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                            <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                    <!-- Desktop Toggle -->
                    <button 
                        v-if="!hideSidebar"
                        @click="isSidebarOpen = !isSidebarOpen"
                        class="hidden lg:flex h-10 w-10 items-center justify-center rounded-xl bg-slate-100 hover:bg-slate-200 transition-colors text-slate-600"
                    >
                        <svg v-if="isSidebarOpen" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7"></path></svg>
                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7"></path></svg>
                    </button>
                    <div>
                        <h1 class="text-lg lg:text-xl font-black tracking-tight text-blue-700" v-if="$slots.header">
                            <slot name="header" />
                        </h1>
                    </div>
                </div>

                <div class="flex items-center gap-3 lg:gap-6">
                    <button 
                        @click="logout"
                        class="h-10 px-4 rounded-xl text-red-400 hover:bg-red-400/10 transition-all duration-300 flex items-center gap-2 border border-transparent hover:border-red-400/20"
                    >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                        <span class="hidden sm:inline font-bold text-xs uppercase tracking-widest whitespace-nowrap">Keluar</span>
                    </button>
                    <div class="h-10 w-10 rounded-xl bg-blue-600 flex items-center justify-center font-black text-white text-sm shadow-lg shadow-blue-600/20">
                        {{ $page.props.auth.user.name[0] }}
                    </div>
                </div>
            </header>

            <!-- Content Area -->
            <div class="p-6 lg:p-12 animate-in fade-in slide-in-from-bottom-4 duration-700">
                <slot />
            </div>
        </main>
    </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap');

body {
    font-family: 'Outfit', sans-serif;
}
</style>
