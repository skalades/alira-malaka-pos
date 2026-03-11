Rencana Fitur Aplikasi Kasir & Self-Order (Mobile-First Landscape)

Aplikasi ini dirancang sebagai Progressive Web App (PWA) dengan fokus pada orientasi landscape untuk memberikan ruang kerja maksimal pada perangkat mobile.

1. Stack Teknologi & Framework

Backend: Laravel 11 (PHP 8.2+)

Frontend: Vue.js 3 dengan Inertia.js (Memberikan pengalaman Single Page Application tanpa perlu membuat API terpisah).

Styling: Tailwind CSS (Untuk desain responsif dan kustomisasi layout landscape).

Real-time Engine: Laravel Reverb (WebSocket server bawaan Laravel untuk notifikasi instan).

Database: MySQL 8.0+

State Management: Pinia (Untuk mengelola keranjang belanja di sisi client).

Client-side Library: Laravel Echo (Untuk mendengarkan broadcast dari Reverb).

2. Struktur Database (MySQL)

Berikut adalah tabel-tabel utama yang diperlukan:

users: Mengelola data admin dan kasir (id, name, email, password, role).

tables: Data meja (id, table_number, qr_code_token, status 

$$available, occupied$$

).

categories: Kategori menu (id, name, slug, image).

menus: Detail produk (id, category_id, name, description, price, stock, image, is_available).

orders: Data pesanan induk (id, table_id, user_id 

$$null for self-order$$

, order_number, total_price, status 

$$pending, processing, ready, completed, cancelled$$

, type 

$$dine_in, takeaway$$

).

order_items: Detail item per pesanan (id, order_id, menu_id, quantity, notes, price_at_time).

transactions: Data pembayaran (id, order_id, payment_method 

$$cash, qris, debit$$

, amount_paid, change_amount, transaction_time).

3. Sisi Pelanggan (Self-Order via QR)

Fitur ini diakses pelanggan setelah melakukan scan QR Code di meja masing-masing.

Dynamic QR Code Identification: Sistem mengenali meja melalui URL (contoh: /order/table-05?token=xyz).

Katalog Menu Interaktif: Filter kategori dan pencarian cepat dengan transisi Vue.js yang halus.

Manajemen Keranjang (Cart): Menggunakan Pinia agar data keranjang tidak hilang saat pindah halaman (sebelum checkout).

Status Pesanan Real-time: Pelanggan mendapat update otomatis saat status pesanan dikonfirmasi atau diselesaikan oleh kasir via WebSocket.

4. Sisi Kasir (Dashboard POS)

Fitur utama untuk memproses transaksi dan menerima pesanan dari meja.

Real-time Order Notification: Notifikasi suara dan visual muncul instan saat pelanggan menekan tombol "Pesan".

Interactive Table Map: Layout visual meja restoran yang berubah warna sesuai status order (Pending, Unpaid, Occupied).

Manual Input (Takeaway): Form input cepat untuk pelanggan yang datang langsung (bungkus) tanpa melalui scan QR meja.

Payment Processing: Integrasi kalkulator kembalian untuk cash dan antarmuka untuk konfirmasi pembayaran digital/QRIS.

Order Management: Kasir dapat mengubah status pesanan (misal: dari 'Pending' ke 'Processing') yang akan langsung terupdate di layar pelanggan.

5. Detail Teknis UI (Mobile Landscape)

Mengingat target utamanya adalah Mobile Landscape:

Breakpoint Customization: Menggunakan utilitas Tailwind untuk memastikan elemen tidak bertumpuk di layar pendek (height kecil).

Orientation Guard: Implementasi JavaScript untuk mendeteksi orientasi layar dan menampilkan overlay "Harap Miringkan Perangkat" jika pengguna berada dalam mode portrait.

Fixed Sidebar Navigation: Menu navigasi berada di sisi kiri (lebar ~70-80px) untuk memudahkan navigasi jempol.

Two-Column Layout:

Kiri (60%): Grid menu dengan gambar dan tombol tambah besar.

Kanan (40%): Daftar pesanan/struk berjalan yang selalu terlihat (sticky).

Touch Optimization: Elemen interaktif minimal 44x44 pixel untuk menghindari kesalahan tekan (fat-finger).

6. Panel Admin & Laporan

QR Generator: Otomatis membuat QR Code unik per meja dengan token keamanan agar tidak bisa dimanipulasi manual.

Menu & Stock Management: Mengelola ketersediaan stok bahan atau menu yang akan langsung mempengaruhi tampilan di sisi pelanggan secara real-time.

Sales Analytics: Grafik pendapatan menggunakan Chart.js yang terintegrasi dengan data MySQL untuk melihat performa harian/bulanan.