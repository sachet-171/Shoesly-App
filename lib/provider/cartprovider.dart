import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart_model.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Method to add item to cart
  void addItem(CartItem newItem) {
    final existingItemIndex = _items.indexWhere((item) => item.name == newItem.name);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
    saveCart();
  }

  // Method to update item quantity
  void updateItemQuantity(CartItem item, int quantity) {
    final itemIndex = _items.indexOf(item);
    if (itemIndex >= 0) {
      _items[itemIndex].quantity = quantity;
      notifyListeners();
      saveCart();
    }
  }

  // Method to remove item from cart
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
    saveCart();
  }

  // Method to calculate total price of items in cart
  double getTotalPrice() {
    return _items.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }

  // Method to clear the cart
  void clearCart() {
    _items = [];
    notifyListeners();
    saveCart();
  }

  // Method to save cart items to SharedPreferences
  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _items.map((item) => item.toJson()).toList();
      await prefs.setString('cart', json.encode(cartData));
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  // Method to load cart items from SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart');
      if (cartString != null) {
        final List<dynamic> cartData = json.decode(cartString);
        _items = cartData.map((itemJson) => CartItem.fromJson(itemJson)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }
}
