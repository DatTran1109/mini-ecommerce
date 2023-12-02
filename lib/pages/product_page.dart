import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/search_field.dart';
import 'package:mini_ecommerce/data/models/cart_model.dart';
import 'package:mini_ecommerce/data/models/product_model.dart';
import 'package:mini_ecommerce/data/models/shop_provider.dart';
import 'package:mini_ecommerce/data/services/category_service.dart';
import 'package:mini_ecommerce/data/services/product_service.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _dropdownValue = '';
  String _dropdownValue2 = '';
  final _textController = TextEditingController();
  late Timer _timer;

  void filterIconTap() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => FutureBuilder(
              future: CategoryService.fetchAllCategory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Container();
                } else if (snapshot.hasData) {
                  return MultiSelectBottomSheet(
                    title: const Text('Filter by category'),
                    cancelText: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    confirmText: Text(
                      'Filter',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    initialValue:
                        Provider.of<ShopProvider>(context).filter.split(','),
                    items: snapshot.data!
                        .map((item) => MultiSelectItem(item.name, item.name))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) => Provider.of<ShopProvider>(
                      context,
                      listen: false,
                    ).setFilterField(values.join(',')),
                  );
                } else {
                  return Container();
                }
              },
            ));
  }

  void addToCart(ProductModel product, int quantity, String size) {
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textController.text = Provider.of<ShopProvider>(context).search;
    final future = ProductService.fetchAllProduct(
        search: _textController.text,
        category: Provider.of<ShopProvider>(context).filter,
        sort: Provider.of<ShopProvider>(context).sort);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchField(
                textController: _textController,
                onFilterPressed: filterIconTap,
                onSearchPressed: () =>
                    Provider.of<ShopProvider>(context, listen: false)
                        .setSearchField(_textController.text),
              ),
              const SizedBox(height: 25),
              _sortField(context),
              const SizedBox(height: 50),
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset('assets/animations/loading.json'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Container();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            onTap: () {
                              Provider.of<ShopProvider>(context, listen: false)
                                  .setSelectedProductID(
                                      snapshot.data![index].id);

                              Navigator.pushNamed(context, '/product_detail');
                            },
                            title: Text(snapshot.data![index].name),
                            subtitle:
                                Text('${snapshot.data![index].price}.000 VND'),
                            leading: snapshot.data![index].image!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: snapshot.data![index].image![0],
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.favorite),
                            trailing: GestureDetector(
                              onTap: () =>
                                  addToCart(snapshot.data![index], 1, 'L'),
                              child: Container(
                                width: 100,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff9DCEFF),
                                      Colors.deepPurpleAccent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      ' Cart',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'There is no available product!',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Container _sortField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Text('Name sort:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 5),
                DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  iconEnabledColor: Colors.deepPurpleAccent,
                  elevation: 0,
                  items: const [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'None',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'asc',
                      child: Text(
                        'A-Z',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'desc',
                      child: Text(
                        'Z-A',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                  value: _dropdownValue,
                  onChanged: (String? value) {
                    if (value == '') {
                      Provider.of<ShopProvider>(context, listen: false)
                          .setSortField('');
                      setState(() {
                        _dropdownValue = '';
                      });
                      return;
                    }

                    if (value is String) {
                      Provider.of<ShopProvider>(context, listen: false)
                          .setSortField('name,$value');

                      setState(() {
                        _dropdownValue = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Text('Price sort:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 5),
                DropdownButton(
                  dropdownColor: Theme.of(context).colorScheme.primary,
                  iconEnabledColor: Colors.deepPurpleAccent,
                  elevation: 0,
                  items: const [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'None',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'asc',
                      child: Text(
                        'Ascending',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'desc',
                      child: Text(
                        'Descending',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                  value: _dropdownValue2,
                  onChanged: (String? value) {
                    if (value == '') {
                      Provider.of<ShopProvider>(context, listen: false)
                          .setSortField('');
                      setState(() {
                        _dropdownValue2 = '';
                      });
                      return;
                    }

                    if (value is String) {
                      Provider.of<ShopProvider>(context, listen: false)
                          .setSortField('price,$value');

                      setState(() {
                        _dropdownValue2 = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
