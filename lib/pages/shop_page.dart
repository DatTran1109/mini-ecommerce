import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_ecommerce/components/my_drawer.dart';
import 'package:mini_ecommerce/components/product_tile.dart';
import 'package:mini_ecommerce/data/models/shop_provider.dart';
import 'package:mini_ecommerce/data/services/category_service.dart';
import 'package:mini_ecommerce/data/services/product_service.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Mini Ecommerce'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      drawer: MyDrawer(
        onSignOut: signOut,
        onSettingTap: () => Navigator.pushNamed(context, '/setting_page'),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _searchFieldSection(textController, context),
              const SizedBox(height: 25),
              _categorySection(),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  'Hot Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _hotProductSection(),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Mini Shop',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Column _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: FutureBuilder(
            future: CategoryService.fetchAllCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset('assets/animations/loading.json'),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Container();
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Provider.of<ShopProvider>(context, listen: false)
                            .setFilterField(snapshot.data![index].name);

                        Navigator.pushNamed(context, '/product_page')
                            .then((value) {
                          Provider.of<ShopProvider>(context, listen: false)
                              .setSearchField('');
                          Provider.of<ShopProvider>(context, listen: false)
                              .setFilterField('');
                          Provider.of<ShopProvider>(context, listen: false)
                              .setSortField('');
                        });
                      },
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data![index].icon,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  SizedBox _hotProductSection() {
    return SizedBox(
        height: 550,
        child: FutureBuilder(
          future: ProductService.fetchAllProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset('assets/animations/loading.json'),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Container();
            } else if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ProductTile(
                    product: snapshot.data![index],
                    onTap: () {
                      Provider.of<ShopProvider>(context, listen: false)
                          .setSelectedProductID(snapshot.data![index].id);

                      Navigator.pushNamed(context, '/product_detail');
                    },
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }

  Container _searchFieldSection(
      TextEditingController textController, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search products',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(5),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Provider.of<ShopProvider>(context, listen: false)
                      .setSearchField(textController.text);

                  Navigator.pushNamed(context, '/product_page').then((value) {
                    Provider.of<ShopProvider>(context, listen: false)
                        .setSearchField('');
                    Provider.of<ShopProvider>(context, listen: false)
                        .setFilterField('');
                    Provider.of<ShopProvider>(context, listen: false)
                        .setSortField('');
                    textController.clear();
                  });
                },
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
