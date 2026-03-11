<script setup lang="ts">
import { ref } from 'vue';
import { Head, Link } from '@inertiajs/vue3';

defineProps<{
    title?: string;
}>();

const isSummaryOpen = ref(false);
</script>

<template>
    <div class="h-screen w-screen overflow-hidden bg-gray-50 flex flex-col lg:flex-row">
        <Head :title="title" />

        <!-- Sidebar Navigation (Left - Hidden on mobile) -->
        <aside class="hidden lg:flex w-20 bg-white flex-col items-center py-6 border-r border-slate-200 z-20">
            <div class="mb-10 text-blue-600 font-black text-xl">AM</div>
            
            <nav class="flex-1 flex flex-col gap-8">
                <Link href="/" class="p-3 rounded-xl transition-all" :class="$page.url === '/' ? 'bg-blue-50 text-blue-600' : 'text-slate-400 hover:bg-slate-50 hover:text-slate-900'">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                </Link>
            </nav>

            <div class="mt-auto">
                <button class="text-slate-400 hover:text-red-500 transition-colors">
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                </button>
            </div>
        </aside>

        <!-- Mobile Header -->
        <header class="lg:hidden h-16 bg-white border-b border-slate-200 flex items-center justify-between px-6 z-30">
            <div class="text-blue-700 font-black text-lg">AM POS</div>
            <button @click="isSummaryOpen = !isSummaryOpen" class="bg-blue-50 text-blue-600 p-2 rounded-lg relative">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                <div class="absolute -top-1 -right-1 h-5 w-5 bg-blue-600 text-white rounded-full text-[10px] flex items-center justify-center border-2 border-white">!</div>
            </button>
        </header>

        <!-- Main Workspace -->
        <main class="flex-1 flex flex-col lg:flex-row overflow-hidden relative">
            <!-- Left Panel (Main Content) -->
            <section class="flex-1 overflow-y-auto p-4 lg:p-6 bg-white shadow-inner">
                <slot />
            </section>

            <!-- Right Panel (Order Summary) -->
            <section 
                class="fixed inset-y-0 right-0 w-full sm:w-[400px] lg:relative lg:w-[40%] bg-slate-50 border-l border-slate-200 flex flex-col shadow-lg transition-transform duration-300 z-40"
                :class="[isSummaryOpen ? 'translate-x-0' : 'translate-x-full lg:translate-x-0']"
            >
                <div class="p-6 border-b bg-white flex justify-between items-center">
                    <h2 class="text-xl font-bold text-blue-700">Detail Pesanan</h2>
                    <button @click="isSummaryOpen = false" class="lg:hidden p-2 text-slate-400 hover:text-slate-600">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                    </button>
                </div>
                <div class="flex-1 overflow-y-auto p-6">
                    <slot name="summary" />
                </div>
                <!-- Action Footer -->
                <div class="p-6 bg-white border-t border-slate-200 shadow-2xl">
                    <slot name="footer" />
                </div>
            </section>

            <!-- Backdrop for mobile summary -->
            <div 
                v-if="isSummaryOpen" 
                @click="isSummaryOpen = false" 
                class="fixed inset-0 bg-black/40 z-30 lg:hidden"
            ></div>
        </main>
    </div>
</template>
