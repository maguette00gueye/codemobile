import 'package:flutter/foundation.dart';
import 'CartItem.dart';

class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.values.fold(0, (total, item) => total + item.quantity);
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addItem(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      // Increment quantity if item already exists
      _items.update(
        productId,
            (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      // Decrease quantity if more than 1
      _items.update(
        productId,
            (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      // Remove item if quantity is 1
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}