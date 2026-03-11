/**
 * Utility for generating ESC/POS commands and sending to RawBT
 */

export class EscPosBuilder {
    private buffer: Uint8Array = new Uint8Array(0);

    private append(data: number[] | Uint8Array) {
        const newData = data instanceof Uint8Array ? data : new Uint8Array(data);
        const combined = new Uint8Array(this.buffer.length + newData.length);
        combined.set(this.buffer);
        combined.set(newData, this.buffer.length);
        this.buffer = combined;
    }

    init() {
        this.append([0x1b, 0x40]); // ESC @
        return this;
    }

    alignCenter() {
        this.append([0x1b, 0x61, 0x01]); // ESC a 1
        return this;
    }

    alignLeft() {
        this.append([0x1b, 0x61, 0x00]); // ESC a 0
        return this;
    }

    alignRight() {
        this.append([0x1b, 0x61, 0x02]); // ESC a 2
        return this;
    }

    bold(on: boolean = true) {
        this.append([0x1b, 0x45, on ? 0x01 : 0x00]); // ESC E n
        return this;
    }

    fontSize(width: number = 1, height: number = 1) {
        // width and height can be 1-8
        const w = (width - 1) & 0x07;
        const h = (height - 1) & 0x07;
        const n = (w << 4) | h;
        this.append([0x1d, 0x21, n]); // GS ! n
        return this;
    }

    text(content: string) {
        const encoder = new TextEncoder();
        this.append(encoder.encode(content));
        return this;
    }

    line(content: string = '') {
        this.text(content + '\n');
        return this;
    }

    dashLine() {
        this.line('--------------------------------');
        return this;
    }

    feed(lines: number = 1) {
        for (let i = 0; i < lines; i++) {
            this.append([0x0a]); // LF
        }
        return this;
    }

    cut() {
        this.append([0x1d, 0x56, 0x42, 0x00]); // GS V 66 0
        return this;
    }

    toBase64() {
        let binary = '';
        const bytes = new Uint8Array(this.buffer);
        const len = bytes.byteLength;
        for (let i = 0; i < len; i++) {
            binary += String.fromCharCode(bytes[i]);
        }
        return window.btoa(binary);
    }
}

const justify = (left: string, right: string, width: number = 32): string => {
    const leftLen = left.length;
    const rightLen = right.length;
    const spaceNeeded = width - leftLen - rightLen;
    if (spaceNeeded <= 0) return left + ' ' + right;
    return left + ' '.repeat(spaceNeeded) + right;
};

/**
 * Builds a single receipt into the provided builder.
 * Does NOT include the cut command at the end to allow for batching.
 */
const buildReceipt = (
    builder: EscPosBuilder,
    order: any, 
    shopSettings: any, 
    taxSettings: any, 
    serviceChargeSettings: any, 
    mode: 'customer' | 'kitchen' | 'qc' = 'customer', 
    category?: string,
    onlyUnprinted: boolean = false
) => {
    const pageWidth = 32;

    if (mode === 'customer') {
        builder.alignCenter()
            .bold().fontSize(2, 2).line(shopSettings.name).fontSize(1, 1).bold(false)
            .line(shopSettings.address || '')
            .feed(1)
            .line('STRUK PELANGGAN')
            .line(new Date().toLocaleDateString('id-ID') + ' ' + new Date().toLocaleTimeString('id-ID'))
            .line(`Pesanan: #${order.order_number}`)
            .line(order.table ? `MEJA ${order.table.table_number}` : 'BUNGKUS')
            .dashLine()
            .alignLeft();

        order.order_items.forEach((item: any) => {
            let name = item.menu.name;
            if (item.variant) {
                name += ` (${item.variant.name})`;
            }
            const price = (item.price_at_time * item.quantity).toLocaleString();
            
            const qty = `${item.quantity}x `;
            const leftPart = qty + name;
            if (leftPart.length + price.length + 1 > pageWidth) {
                builder.line(leftPart);
                builder.line(justify('', price, pageWidth));
            } else {
                builder.line(justify(leftPart, price, pageWidth));
            }
            
            if (item.notes) builder.line(`  * ${item.notes}`);
        });

        builder.dashLine();

        const subtotal = Number(order.total_price);
        let total = subtotal;

        if (serviceChargeSettings.enabled || taxSettings.enabled) {
            builder.line(justify('SUBTOTAL', subtotal.toLocaleString(), pageWidth));
        }

        if (serviceChargeSettings.enabled) {
            const sc = subtotal * serviceChargeSettings.percentage / 100;
            builder.line(justify(`SERVICE CHG (${serviceChargeSettings.percentage}%)`, sc.toLocaleString(), pageWidth));
            total += sc;
        }

        if (taxSettings.enabled) {
            const tax = subtotal * taxSettings.percentage / 100;
            builder.line(justify(`PAJAK (${taxSettings.percentage}%)`, tax.toLocaleString(), pageWidth));
            total += tax;
        }

        if (serviceChargeSettings.enabled || taxSettings.enabled) {
            builder.dashLine();
        }

        total -= Number(order.loyalty_discount || 0);

        builder.bold().line(justify('TOTAL TERTAGIH', `Rp ${total.toLocaleString()}`, pageWidth)).bold(false);

        if (order.transaction) {
            builder.feed(1)
                .line(justify(`BAYAR (${order.transaction.payment_method.toUpperCase()})`, Number(order.transaction.amount_paid).toLocaleString(), pageWidth))
                .bold().line(justify('KEMBALIAN', Number(order.transaction.change_amount).toLocaleString(), pageWidth)).bold(false);
        }

        builder.feed(2).alignCenter()
            .bold().line('--- TERIMA KASIH ---').bold(false)
            .line(shopSettings.footer || 'Selamat Menikmati')
            .feed(3);
    } else if (mode === 'kitchen') {
        const categoryName = category || 'DAPUR';
        const items = order.order_items.filter((item: any) => {
            const itemCat = item.menu?.category?.name || 'DAPUR';
            const matchesCategory = itemCat.toLowerCase() === categoryName.toLowerCase();
            const matchesPrintStatus = !onlyUnprinted || !item.is_printed;
            return matchesCategory && matchesPrintStatus;
        });

        if (items.length === 0) return false;

        builder.alignCenter()
            .bold().fontSize(2, 2).line(`TIKET ${categoryName.toUpperCase()}`).fontSize(1, 1).bold(false)
            .line(new Date().toLocaleDateString('id-ID') + ' ' + new Date().toLocaleTimeString('id-ID'))
            .line(`Pesanan: #${order.order_number}`)
            .line(order.table ? `MEJA ${order.table.table_number}` : 'BUNGKUS')
            .dashLine()
            .alignLeft();

        items.forEach((item: any) => {
            let name = item.menu.name;
            if (item.variant) {
                name += ` (${item.variant.name})`;
            }
            builder.bold().fontSize(2, 2).line(`${item.quantity}x ${name}`).fontSize(1, 1).bold(false);
            if (item.notes) builder.line(`  Catatan: ${item.notes}`);
            builder.feed(1);
        });

        builder.feed(2);
    } else if (mode === 'qc') {
        builder.alignCenter()
            .bold().fontSize(2, 2).line(`QC CHECKLIST${onlyUnprinted ? ' (BARU)' : ''}`).fontSize(1, 1).bold(false)
            .line(new Date().toLocaleDateString('id-ID') + ' ' + new Date().toLocaleTimeString('id-ID'))
            .line(`Pesanan: #${order.order_number}`)
            .line(order.table ? `MEJA ${order.table.table_number}` : 'BUNGKUS')
            .dashLine()
            .alignLeft();

        const items = onlyUnprinted 
            ? order.order_items.filter((item: any) => !item.is_printed)
            : order.order_items;

        if (items.length === 0) return false;

        items.forEach((item: any) => {
            let name = item.menu.name;
            if (item.variant) {
                name += ` (${item.variant.name})`;
            }
            builder.line(`[ ] ${item.quantity}x ${name}`);
            if (item.notes) builder.line(`    * ${item.notes}`);
        });

        builder.feed(3);
    }
    return true;
};

/**
 * Legacy single print function. Now uses the batch logic.
 */
export const printOrderRawBT = (order: any, shopSettings: any, taxSettings: any, serviceChargeSettings: any, mode: 'customer' | 'kitchen' | 'qc' = 'customer', category?: string, onlyUnprinted: boolean = false) => {
    return printOrderBatchRawBT(order, shopSettings, taxSettings, serviceChargeSettings, [{ mode, category }], onlyUnprinted);
};

/**
 * Prints multiple receipts in a single batch call to RawBT.
 */
export const printOrderBatchRawBT = (order: any, shopSettings: any, taxSettings: any, serviceChargeSettings: any, prints: { mode: 'customer' | 'kitchen' | 'qc', category?: string }[], onlyUnprinted: boolean = false) => {
    const builder = new EscPosBuilder().init();
    
    let hasContent = false;
    prints.forEach(p => {
        const result = buildReceipt(builder, order, shopSettings, taxSettings, serviceChargeSettings, p.mode, p.category, onlyUnprinted);
        if (result) {
            builder.feed(5); // Add space for manual tear if auto-cut is not supported
            builder.cut();
            hasContent = true;
        }
    });

    if (!hasContent) return;

    const base64 = builder.toBase64();
    const url = `rawbt:base64,${base64}`;

    const isAndroid = /Android/i.test(navigator.userAgent);
    if (!isAndroid) {
        console.log('RawBT Batch URL generated:', url);
        alert('Fitur "Cetak BT" (RawBT) hanya berfungsi di perangkat Android yang sudah terinstal aplikasi RawBT Driver.\n\nKarena Anda menggunakan Windows/Browser PC, data hanya ditampilkan di Console Log untuk pengecekan.');
        return;
    }

    window.location.href = url;
};
