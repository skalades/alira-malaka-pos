<script setup lang="ts">
import Checkbox from '@/Components/Checkbox.vue';
import InputError from '@/Components/InputError.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

defineProps<{
    canResetPassword?: boolean;
    status?: string;
}>();

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const isVisible = ref(false);
setTimeout(() => isVisible.value = true, 100);

const submit = () => {
    form.post(route('login'), {
        onFinish: () => {
            form.reset('password');
        },
    });
};
</script>

<template>
    <Head title="Login - Alira Malaka" />

    <div class="min-h-screen w-full relative flex items-center justify-center overflow-hidden font-sans selection:bg-blue-600 selection:text-white">
        <!-- Premium Background -->
        <div class="absolute inset-0 z-0">
            <img 
                src="/images/login-bg.png" 
                class="w-full h-full object-cover scale-105 transition-transform duration-[10s] ease-out"
                :class="{ 'scale-100': isVisible }"
            />
            <div class="absolute inset-0 bg-black/60 backdrop-blur-[2px]"></div>
        </div>

        <!-- Login Card -->
        <div 
            class="relative z-10 w-full max-w-md px-6 transition-all duration-1000 ease-out"
            :class="isVisible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-12'"
        >
            <div class="bg-white/10 backdrop-blur-xl border border-white/20 rounded-[40px] p-10 shadow-2xl overflow-hidden relative group">
                <!-- Subtle Glow effect -->
                <div class="absolute -top-24 -left-24 w-48 h-48 bg-blue-600/20 rounded-full blur-3xl group-hover:bg-blue-600/30 transition-all duration-700"></div>

                <div class="relative z-10">
                    <div class="text-center mb-10">
                        <h1 class="text-4xl font-black text-white tracking-tighter mb-2">ALIRA MALAKA</h1>
                        <p class="text-white/50 text-sm font-medium uppercase tracking-[0.2em]">Management System</p>
                    </div>

                    <div v-if="status" class="mb-6 bg-green-500/10 border border-green-500/20 text-green-400 text-xs py-3 px-4 rounded-xl text-center">
                        {{ status }}
                    </div>

                    <form @submit.prevent="submit" class="space-y-6">
                        <div class="space-y-2">
                            <label class="text-[10px] font-black text-white/40 uppercase tracking-widest ml-1">Email Address</label>
                            <div class="relative group">
                                <input 
                                    v-model="form.email"
                                    type="email" 
                                    required
                                    class="w-full h-14 bg-white/5 border border-white/10 rounded-2xl px-6 text-white placeholder:text-white/20 focus:outline-none focus:ring-2 focus:ring-blue-600/50 focus:border-blue-600 transition-all"
                                    placeholder="kasir@aliramalaka.com"
                                />
                            </div>
                            <InputError class="mt-1 ml-1" :message="form.errors.email" />
                        </div>

                        <div class="space-y-2">
                            <label class="text-[10px] font-black text-white/40 uppercase tracking-widest ml-1">Password</label>
                            <input 
                                v-model="form.password"
                                type="password" 
                                required
                                class="w-full h-14 bg-white/5 border border-white/10 rounded-2xl px-6 text-white placeholder:text-white/20 focus:outline-none focus:ring-2 focus:ring-blue-600/50 focus:border-blue-600 transition-all"
                                placeholder="••••••••"
                            />
                            <InputError class="mt-1 ml-1" :message="form.errors.password" />
                        </div>

                        <div class="flex items-center justify-between">
                            <label class="flex items-center cursor-pointer group">
                                <div class="relative">
                                    <input type="checkbox" v-model="form.remember" class="sr-only">
                                    <div class="w-5 h-5 border border-white/20 rounded flex items-center justify-center transition-all group-hover:border-blue-600" :class="{ 'bg-blue-600 border-blue-600': form.remember }">
                                        <svg v-if="form.remember" class="w-3.5 h-3.5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                                    </div>
                                </div>
                                <span class="ms-3 text-xs font-bold text-white/50 group-hover:text-white transition-colors">Ingat saya</span>
                            </label>
                        </div>

                        <button 
                            type="submit"
                            :disabled="form.processing"
                            class="w-full h-16 bg-blue-600 hover:bg-blue-700 disabled:bg-white/10 text-white rounded-2xl font-black text-lg shadow-xl shadow-blue-600/20 active:scale-[0.98] transition-all duration-300 flex items-center justify-center gap-3 mt-4"
                        >
                            <span v-if="form.processing" class="w-6 h-6 border-4 border-white/30 border-t-white rounded-full animate-spin"></span>
                            <span v-else>Masuk ke Dashboard</span>
                        </button>
                    </form>

                    <div class="mt-8 text-center">
                        <p class="text-[10px] text-white/30 font-medium tracking-wider">
                            &copy; 2026 ALIRA MALAKA GROUP. ALL RIGHTS RESERVED.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@100..900&display=swap');

:deep(body) {
    font-family: 'Outfit', sans-serif;
}
</style>
