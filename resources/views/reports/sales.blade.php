@php
    $taxEnabled = \App\Models\Setting::get('tax_enabled', '0') === '1';
    $taxPercentage = (float)\App\Models\Setting::get('tax_percentage', '10');
@endphp
<!DOCTYPE html>
<html>
<head>
    <title>Laporan Penjualan</title>
    <style>
        body { font-family: sans-serif; font-size: 12px; color: #333; }
        .header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #444; padding-bottom: 10px; }
        .header h1 { margin: 0; text-transform: uppercase; font-size: 24px; }
        .header p { margin: 5px 0; color: #666; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #f2f2f2; border: 1px solid #ddd; padding: 10px; text-align: left; text-transform: uppercase; font-size: 10px; }
        td { border: 1px solid #ddd; padding: 10px; }
        .total-row { font-weight: bold; background-color: #f9f9f9; }
        .text-right { text-align: right; }
        .footer { margin-top: 50px; text-align: center; font-size: 10px; color: #999; }
    </style>
</head>
<body>
    <div class="header">
        <h1>{{ $shopName }}</h1>
        <p>LAPORAN PENJUALAN</p>
        <p>Periode: {{ date('d/m/Y', strtotime($startDate)) }} - {{ date('d/m/Y', strtotime($endDate)) }}</p>
    </div>

    <!-- Shift Summary Section -->
    <div style="margin-bottom: 30px;">
        <h3 style="text-transform: uppercase; font-size: 14px; border-bottom: 1px solid #eee; padding-bottom: 5px;">Ringkasan Kas (Shifts)</h3>
        <table>
            <tr>
                <td style="width: 50%; background-color: #f9f9f9; font-weight: bold;">TOTAL BUKA KAS (Opening)</td>
                <td class="text-right">Rp {{ number_format($totalOpening, 0, ',', '.') }}</td>
            </tr>
            <tr>
                <td style="width: 50%; background-color: #f9f9f9; font-weight: bold;">TOTAL TUTUP KAS (Closing)</td>
                <td class="text-right">Rp {{ number_format($totalClosing, 0, ',', '.') }}</td>
            </tr>
        </table>
    </div>

    <h3 style="text-transform: uppercase; font-size: 14px; border-bottom: 1px solid #eee; padding-bottom: 5px;">Detail Penjualan Produk</h3>
    <table>
        <thead>
            <tr>
                <th>Menu Item</th>
                <th class="text-right">Kuantitas</th>
                <th class="text-right">Total Penjualan</th>
            </tr>
        </thead>
        <tbody>
            @foreach($itemizedSales as $item)
                <tr>
                    <td>{{ $item['name'] }}</td>
                    <td class="text-right">{{ $item['quantity'] }}</td>
                    <td class="text-right">Rp {{ number_format($item['revenue'], 0, ',', '.') }}</td>
                </tr>
            @endforeach
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="2" class="text-right">TOTAL PENDAPATAN (REVENUE):</td>
                <td class="text-right">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</td>
            </tr>
        </tfoot>
    </table>

    <!-- Final Summary Section -->
    <div style="margin-top: 30px;">
        <h3 style="text-transform: uppercase; font-size: 14px; border-bottom: 1px solid #eee; padding-bottom: 5px;">Pendapatan per Metode Pembayaran</h3>
        <table>
            <thead>
                <tr>
                    <th>Metode</th>
                    <th class="text-right">Total</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>TUNAI (CASH)</td>
                    <td class="text-right">Rp {{ number_format($paymentBreakdown['cash'], 0, ',', '.') }}</td>
                </tr>
                <tr>
                    <td>QRIS</td>
                    <td class="text-right">Rp {{ number_format($paymentBreakdown['qris'], 0, ',', '.') }}</td>
                </tr>
                <tr>
                    <td>TRANSFER</td>
                    <td class="text-right">Rp {{ number_format($paymentBreakdown['transfer'], 0, ',', '.') }}</td>
                </tr>
                @if(isset($paymentBreakdown['other']) && $paymentBreakdown['other'] > 0)
                <tr>
                    <td>LAINNYA</td>
                    <td class="text-right">Rp {{ number_format($paymentBreakdown['other'], 0, ',', '.') }}</td>
                </tr>
                @endif
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td class="text-right">TOTAL KESELURUHAN:</td>
                    <td class="text-right">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</td>
                </tr>
            </tfoot>
        </table>
    </div>

    <div style="margin-top: 30px; border-top: 2px solid #333; padding-top: 10px;">
        <table style="border: none;">
            <tr style="font-size: 16px; font-weight: bold;">
                <td style="border: none;">GRAND TOTAL PENDAPATAN</td>
                <td style="border: none; color: #2563eb;" class="text-right">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</td>
            </tr>
        </table>
    </div>

    <div class="footer">
        <p>Dicetak pada: {{ date('d/m/Y H:i:s') }}</p>
        <p>Laporan ini dihasilkan secara otomatis oleh ALIRA MALAKA POS System.</p>
    </div>
</body>
</html>
