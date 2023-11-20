class ProductModel {
  final String id;
  final String name;
  final String description;
  final List? category;
  final num price;
  final List? image;
  final Map? size;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
    required this.size,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['_id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        price: json['price'],
        image: json['image'],
        size: json['size'],
      );

  // static Map<dynamic, dynamic> modelToMap(ProductModel? model) {
  //   Map<dynamic, dynamic> productMap = {
  //     'id': model!.id,
  //     'name': model.name,
  //     'description': model.description,
  //     'category': model.category,
  //     'price': model.price,
  //     'image': model.image,
  //     'size': model.size,
  //   };
  //   return productMap;
  // }

  // static ProductModel mapToModel(Map<dynamic, dynamic> map) => ProductModel(
  //       id: map['id'],
  //       name: map['name'],
  //       description: map['description'],
  //       category: map['category'],
  //       price: map['price'],
  //       image: map['image'],
  //       size: map['size'],
  //     );
}
