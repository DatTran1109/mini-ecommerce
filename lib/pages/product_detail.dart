import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/data/models/cart_model.dart';
import 'package:mini_ecommerce/data/models/product_model.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _selectedImageIndex = 0;
  int _quantity = 0;
  String? _size;
  late Timer _timer;

  void addToCart(
      BuildContext context, ProductModel product, int quantity, String? size) {
    if (quantity == 0 || size == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Text(
            'Please select size and quantity',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: const Text(
                'Add this product to your cart',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
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
                          _timer = Timer(const Duration(seconds: 2), () {
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
                      if (_timer.isActive) {
                        _timer.cancel();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    widget.product.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                widget.product.image![_selectedImageIndex],
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.favorite),
                    const SizedBox(height: 40),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        width: double.infinity,
                        height: 400,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    widget.product.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${widget.product.price}.000 VND',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.product.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(
                                  height: 70,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.product.image!.length,
                                    itemBuilder: (context, index) => Container(
                                      padding: const EdgeInsets.all(4),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImageIndex = index;
                                          });
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.product.image![index],
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: 135,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() {
                          _quantity--;
                        }),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 20)),
                      GestureDetector(
                        onTap: () => setState(() {
                          _quantity++;
                        }),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Size: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      DropdownButton(
                        dropdownColor: Theme.of(context).colorScheme.primary,
                        iconEnabledColor: Colors.deepPurpleAccent,
                        elevation: 0,
                        items: const [
                          // DropdownMenuItem(
                          //   value: '',
                          //   child: Text(
                          //     '',
                          //     style: TextStyle(fontSize: 14),
                          //   ),
                          // ),
                          DropdownMenuItem(
                            value: 'L',
                            child: Text(
                              'L',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'M',
                            child: Text(
                              'M',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'S',
                            child: Text(
                              'S',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'XL',
                            child: Text(
                              'XL',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        value: _size,
                        onChanged: (String? value) {
                          if (value == '') {
                            setState(() {
                              _size = null;
                            });
                            return;
                          }
                          if (value is String) {
                            setState(() {
                              _size = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      addToCart(context, widget.product, _quantity, _size),
                  child: Container(
                    width: 110,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff9DCEFF),
                          Colors.deepPurpleAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
