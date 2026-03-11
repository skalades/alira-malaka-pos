<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

defineProps<{
    title?: string;
    showCartButton?: boolean;
    cartCount?: number;
}>();

const isCartOpen = ref(false);
</script>

<template>
    <div class="min-h-screen bg-slate-50 text-slate-900 font-['Outfit'] selection:bg-blue-600/30">
        <Head :title="title" />
        
        <!-- Header (Non-sticky) -->
        <header class="absolute top-0 left-0 right-0 z-50 bg-white/80 backdrop-blur-2xl border-b border-slate-200 px-6 h-20 flex items-center justify-between">
            <div class="flex items-center gap-4">
                <div class="w-10 h-10 bg-blue-600 rounded-xl flex items-center justify-center shadow-lg shadow-blue-600/20">
                    <span class="text-white font-black text-xl tracking-tighter">A</span>
                </div>
                <h1 class="font-black text-lg lg:text-xl tracking-tighter uppercase tracking-[0.2em] text-blue-700 whitespace-nowrap">Alira Malaka</h1>
            </div>

            <div v-if="showCartButton" @click="$emit('toggle-cart')" class="relative cursor-pointer group">
                <div class="w-12 h-12 bg-slate-100 border border-slate-200 rounded-2xl flex items-center justify-center group-hover:bg-slate-200 transition-all">
                    <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </div>
                <span v-if="cartCount && cartCount > 0" class="absolute -top-2 -right-2 bg-blue-600 text-white text-[10px] font-black w-6 h-6 rounded-full flex items-center justify-center border-4 border-slate-50 animate-in zoom-in-50">
                    {{ cartCount }}
                </span>
            </div>
        </header>

        <!-- Main Content -->
        <main class="pt-28 pb-32 px-6 max-w-lg mx-auto">
            <slot />
        </main>

        <!-- Dynamic Background Elements -->
        <div class="fixed top-0 left-0 w-full h-full pointer-events-none -z-10 overflow-hidden">
            <div class="absolute -top-[20%] -left-[10%] w-[60%] h-[60%] bg-blue-600/5 rounded-full blur-[120px]"></div>
            <div class="absolute -bottom-[10%] -right-[10%] w-[50%] h-[50%] bg-blue-600/10 rounded-full blur-[100px]"></div>
        </div>
    </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100;300;400;600;700;900&display=swap');
</style>
