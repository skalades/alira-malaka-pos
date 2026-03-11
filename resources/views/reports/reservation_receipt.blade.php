<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Struk Reservasi - {{ $shopName }}</title>
    <style>
        body { font-family: 'Helvetica', sans-serif; font-size: 14px; line-height: 1.5; color: #333; }
        .receipt-box { max-width: 800px; margin: auto; padding: 30px; border: 1px solid #eee; }
        header { text-align: center; margin-bottom: 20px; border-bottom: 2px solid #3b82f6; padding-bottom: 10px; }
        .shop-name { font-size: 24px; font-weight: 900; color: #1e3a8a; margin: 0; text-transform: uppercase; }
        .section-title { font-weight: bold; font-size: 16px; margin-top: 20px; border-bottom: 1px solid #ddd; padding-bottom: 5px; color: #3b82f6; }
        .info-grid { display: block; margin-top: 10px; }
        .info-row { margin-bottom: 5px; }
        .label { font-weight: bold; width: 140px; display: inline-block; }
        .footer { text-align: center; margin-top: 50px; font-size: 12px; color: #777; border-top: 1px solid #eee; pt: 10px; }
        .dp-box { background: #f0f9ff; border: 1px dashed #3b82f6; padding: 15px; margin-top: 20px; text-align: center; }
        .dp-amount { font-size: 20px; font-weight: bold; color: #2563eb; }
    </style>
</head>
<body>
    <div class="receipt-box">
        <header>
            <h1 class="shop-name">{{ $shopName }}</h1>
            <p>{{ $shopAddress }}</p>
        </header>

        <div style="text-align: center; margin-bottom: 30px;">
            <h2 style="margin: 0;">BUKTI REKAPAN RESERVASI</h2>
            <p>Kode Booking: <strong>#RES-{{ str_pad($reservation->id, 5, '0', STR_PAD_LEFT) }}</strong></p>
        </div>

        <div class="section-title">Detail Reservasi</div>
        <div class="info-grid">
            <div class="info-row"><span class="label">Nama:</span> {{ $reservation->customer->name }}</div>
            <div class="info-row"><span class="label">No. WhatsApp:</span> {{ $reservation->customer->phone }}</div>
            <div class="info-row"><span class="label">Tanggal & Waktu:</span> {{ \Carbon\Carbon::parse($reservation->reservation_time)->translatedFormat('d F Y, H:i') }} WIB</div>
            <div class="info-row"><span class="label">Nomor Meja:</span> Meja {{ $reservation->table->table_number }}</div>
            <div class="info-row"><span class="label">Jumlah Orang:</span> {{ $reservation->num_people }} Orang</div>
            @if($reservation->notes)
            <div class="info-row"><span class="label">Catatan:</span> {{ $reservation->notes }}</div>
            @endif
        </div>

        @if($reservation->orders->isNotEmpty())
        <div class="section-title">Daftar Pre-order Menu</div>
        <table style="width: 100%; margin-top: 10px; border-collapse: collapse;">
            <thead>
                <tr style="background: #f8fafc; text-align: left;">
                    <th style="padding: 10px; border-bottom: 2px solid #e2e8f0; font-size: 11px; text-transform: uppercase;">Menu</th>
                    <th style="padding: 10px; border-bottom: 2px solid #e2e8f0; font-size: 11px; text-transform: uppercase; text-align: center;">Qty</th>
                    <th style="padding: 10px; border-bottom: 2px solid #e2e8f0; font-size: 11px; text-transform: uppercase; text-align: right;">Total</th>
                </tr>
            </thead>
            <tbody>
                @php $order = $reservation->orders->first(); @endphp
                @foreach($order->orderItems as $item)
                <tr>
                    <td style="padding: 10px; border-bottom: 1px solid #f1f5f9;">
                        <strong>{{ $item->menu->name }}</strong>
                        @if($item->variant_id)
                            <br><small style="color: #3b82f6;">Varian: {{ $item->variant->name }}</small>
                        @endif
                        @if($item->notes)<br><small style="color: #64748b;">* {{ $item->notes }}</small>@endif
                    </td>
                    <td style="padding: 10px; border-bottom: 1px solid #f1f5f9; text-align: center;">{{ $item->quantity }}x</td>
                    <td style="padding: 10px; border-bottom: 1px solid #f1f5f9; text-align: right;">Rp {{ number_format($item->price_at_time * $item->quantity, 0, ',', '.') }}</td>
                </tr>
                @endforeach
            </tbody>
            <tfoot>
                <tr style="background: #f8fafc;">
                    <td colspan="2" style="padding: 10px; font-weight: bold; text-align: right;">Subtotal Pembelian:</td>
                    <td style="padding: 10px; font-weight: bold; text-align: right;">Rp {{ number_format($order->total_price, 0, ',', '.') }}</td>
                </tr>
                @php 
                    $total = $order->total_price;
                    $sc = 0;
                    $tax = 0;
                @endphp
                @if($serviceChargeEnabled)
                    @php 
                        $sc = $order->total_price * $serviceChargePercentage / 100;
                        $total += $sc;
                    @endphp
                    <tr>
                        <td colspan="2" style="padding: 10px; text-align: right; font-size: 12px;">Tax Service ({{ $serviceChargePercentage }}%):</td>
                        <td style="padding: 10px; text-align: right; font-size: 12px;">Rp {{ number_format($sc, 0, ',', '.') }}</td>
                    </tr>
                @endif
                @if($taxEnabled)
                    @php 
                        $tax = $order->total_price * $taxPercentage / 100;
                        $total += $tax;
                    @endphp
                    <tr>
                        <td colspan="2" style="padding: 10px; text-align: right; font-size: 12px;">PPN ({{ $taxPercentage }}%):</td>
                        <td style="padding: 10px; text-align: right; font-size: 12px;">Rp {{ number_format($tax, 0, ',', '.') }}</td>
                    </tr>
                @endif
                <tr style="background: #f1f5f9;">
                    <td colspan="2" style="padding: 10px; font-weight: 900; text-align: right; font-size: 16px; color: #1e3a8a;">TOTAL PRE-ORDER:</td>
                    <td style="padding: 10px; font-weight: 900; text-align: right; font-size: 16px; color: #1e3a8a;">Rp {{ number_format($total, 0, ',', '.') }}</td>
                </tr>
            </tfoot>
        </table>
        @endif

        <div class="dp-box">
            <p style="margin: 0 0 5px 0; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">Status Pembayaran Uang Muka (DP)</p>
            <div class="dp-amount">Rp {{ number_format($reservation->dp_amount, 0, ',', '.') }}</div>
            <p style="margin: 5px 0 0 0; font-size: 11px; color: #666;">*DP ini akan memotong total belanja Anda saat di kasir.</p>
        </div>

        <div style="margin-top: 30px; font-size: 11px; color: #ef4444; background: #fef2f2; padding: 10px; border-radius: 8px;">
            <strong>PERHATIAN:</strong> Harap tunjukkan struk ini dalam bentuk digital atau cetak saat Anda datang ke lokasi untuk proses check-in.
        </div>

        <div class="footer">
            <p>{{ $shopFooter }}</p>
            <p>Dicetak pada: {{ now()->translatedFormat('d/m/Y H:i') }}</p>
        </div>
    </div>
</body>
</html>
