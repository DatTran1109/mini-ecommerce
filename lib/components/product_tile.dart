import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/data/models/cart_model.dart';
import 'package:mini_ecommerce/data/models/product_model.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final void Function()? onTap;
  const ProductTile({super.key, required this.product, required this.onTap});

  void addToCart(
      BuildContext context, int quantity, String size, Timer? timer) {
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: const Text('Add this product to your cart'),
            actions: [
              MaterialButton(
                onPressed: () {
                  final Map<dynamic, dynamic> productMap = {
                    'id': product.id,
                    'name': product.name,
                    'price': product.price,
                    'size': size,
                    'quantity': quantity,
                  };
                  final cartModel = CartModel();
                  cartModel.addToCart(productMap);

                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        timer = Timer(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });

                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Center(
                            child: Lottie.asset(
                                'assets/animations/add_cart.json',
                                repeat: false),
                          ),
                        );
                      }).then((value) {
                    if (timer!.isActive) {
                      timer!.cancel();
                    }
                  });
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

  @override
  Widget build(BuildContext context) {
    Timer? timer;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(25),
                    width: double.infinity,
                    child: product.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.image![0],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.favorite),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${product.price.toString()}.000 VND'),
                Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                        onPressed: () => addToCart(context, 1, 'L', timer),
                        icon: const Icon(Icons.add)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
