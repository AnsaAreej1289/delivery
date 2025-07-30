import 'package:flutter/material.dart';

// Class representing a single item in the cart
class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  // Method to copy a CartItem (useful for immutability or updates)
  CartItem copyWith({
    String? name,
    String? image,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

// Class managing the state of the cart using ChangeNotifier
class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Add item to cart or increase quantity if it already exists
  void addItem(CartItem item) {
    int existingIndex = _items.indexWhere((i) => i.name == item.name);
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners(); // Notify widgets listening to this model
  }

  // Remove item completely from cart
  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.name == item.name);
    notifyListeners();
  }

  // Decrease quantity of an item; remove if quantity becomes 0
  void decreaseItemQuantity(CartItem item) {
    int existingIndex = _items.indexWhere((i) => i.name == item.name);
    if (existingIndex != -1) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }

  // Calculate total price of all items in the cart
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Get total number of individual items (sum of quantities)
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  // Clear all items from the cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
