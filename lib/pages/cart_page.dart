import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/my_button.dart';
import 'package:mini_ecommerce/data/models/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<dynamic> cart = [];
  final cartModel = CartModel();

  @override
  void initState() {
    super.initState();
    cart.addAll(cartModel.getCart());
  }

  void removeItemFromCart(int index) {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: const Text('Remove this product from your cart'),
            actions: [
              MaterialButton(
                onPressed: () {
                  cartModel.removeFromCart(index);

                  setState(() {
                    cart.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              ),
              MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
            ],
          )),
    );
  }

  void payButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text("Pay backend coming soon!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Column(
        children: [
          Expanded(
              child: cart.isEmpty
                  ? Center(
                      child: Lottie.asset('assets/animations/empty_cart.json'),
                    )
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(cart[index]['name']),
                            subtitle: Text(
                                '${cart[index]['price'].toString()}.000 VND'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Size: ${cart[index]['size']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      cartModel.updateProductQuantity(
                                          index, 'add');
                                    });
                                  },
                                ),
                                Text(cart[index]['quantity'].toString()),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (cart[index]['quantity'] == 1) {
                                      removeItemFromCart(index);
                                      return;
                                    }
                                    setState(() {
                                      cartModel.updateProductQuantity(
                                          index, 'minus');
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
          cart.isEmpty
              ? const SizedBox(height: 75)
              : Padding(
                  padding: const EdgeInsets.all(50),
                  child: MyButton(
                      onTap: () => payButtonPressed(context),
                      child: const Text('PAY NOW')),
                ),
        ],
      ),
    );
  }
}
