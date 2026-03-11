import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export interface CartItem {
    id: number;
    name: string;
    price: number;
    quantity: number;
    image?: string;
    notes?: string;
    category?: {
        id: number;
        name: string;
    };
}

export const useCartStore = defineStore('cart', () => {
    const items = ref<CartItem[]>([]);

    const totalItems = computed(() => items.value.reduce((total, item) => total + item.quantity, 0));
    const totalPrice = computed(() => items.value.reduce((total, item) => total + (item.price * item.quantity), 0));

    function addItem(product: any, initialNotes: string = '') {
        const existingItem = items.value.find(item => item.id === product.id && item.notes === initialNotes);
        if (existingItem) {
            existingItem.quantity++;
        } else {
            items.value.push({
                id: product.id,
                name: product.name,
                price: product.price,
                quantity: 1,
                image: product.image,
                notes: initialNotes,
                category: product.category
            });
        }
    }

    function updateItemNote(productId: number, note: string) {
        const item = items.value.find(i => i.id === productId);
        if (item) {
            item.notes = note;
        }
    }

    function removeItem(productId: number) {
        const index = items.value.findIndex(item => item.id === productId);
        if (index !== -1) {
            if (items.value[index].quantity > 1) {
                items.value[index].quantity--;
            } else {
                items.value.splice(index, 1);
            }
        }
    }

    function clearCart() {
        items.value = [];
    }

    return { items, totalItems, totalPrice, addItem, updateItemNote, removeItem, clearCart };
});
