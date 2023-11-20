import 'package:hive/hive.dart';

class CartModel {
  final box = Hive.box('cart');
  final List<dynamic> cart = [];

  List<dynamic> getCart() {
    cart.clear();

    if (box.get('cart') == null) {
      return cart;
    }

    final List<dynamic> data = box.get('cart');

    if (data.isNotEmpty) {
      cart.addAll(data);
    }

    return cart;
  }

  void addToCart(Map<dynamic, dynamic> product) {
    final List<dynamic> cartInHive = [];

    if (box.get('cart') == null) {
      cartInHive.add(product);
      box.put('cart', cartInHive);
      return;
    }

    final List<dynamic> data = box.get('cart');

    if (data.isNotEmpty) {
      cartInHive.addAll(data);
      cartInHive.add(product);
      box.put('cart', cartInHive);
    } else {
      cartInHive.add(product);
      box.put('cart', cartInHive);
    }
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    box.put('cart', cart);
  }

  void updateProductQuantity(int index, String operator) {
    if (operator == 'add') {
      cart[index]['quantity']++;
      box.put('cart', cart);
    } else {
      cart[index]['quantity']--;
      box.put('cart', cart);
    }
  }
}
