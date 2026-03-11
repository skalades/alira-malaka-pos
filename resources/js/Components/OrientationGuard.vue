<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

const isPortrait = ref(false);

const checkOrientation = () => {
    isPortrait.value = window.innerHeight > window.innerWidth;
};

onMounted(() => {
    checkOrientation();
    window.addEventListener('resize', checkOrientation);
});

onUnmounted(() => {
    window.removeEventListener('resize', checkOrientation);
});
</script>

<template>
    <div v-if="isPortrait" class="fixed inset-0 z-[9999] flex flex-col items-center justify-center bg-gray-900 px-6 text-center text-white">
        <div class="mb-6 animate-bounce">
            <svg class="h-20 w-20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
            </svg>
        </div>
        <h1 class="text-2xl font-bold mb-2">Harap Miringkan Perangkat</h1>
        <p class="text-gray-400">Aplikasi ini dirancang untuk digunakan dalam mode Landscape guna memberikan pengalaman terbaik.</p>
    </div>
</template>
