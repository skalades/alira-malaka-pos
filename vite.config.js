import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.ts',
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        VitePWA({
            registerType: 'autoUpdate',
            devOptions: {
                enabled: true
            },
            manifest: {
                name: 'POS',
                short_name: 'POS',
                description: 'Point of Sale Alira Malaka',
                theme_color: '#111827',
                background_color: '#111827',
                display: 'standalone',
                orientation: 'any',
                start_url: 'http://127.0.0.1:8000/',
                scope: 'http://127.0.0.1:8000/',
                icons: [
                    {
                        src: 'http://127.0.0.1:8000/icons/icon.png',
                        sizes: '512x512',
                        type: 'image/png',
                        purpose: 'any maskable'
                    }
                ]
            }
        })
    ],
    server: {
        host: '127.0.0.1',
        cors: true,
        hmr: {
            host: '127.0.0.1',
        },
    },
});
