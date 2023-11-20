import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_ecommerce/data/models/product_model.dart';

class ProductService {
  static Future<List<ProductModel>> fetchAllProduct({
    String page = '1',
    String limit = '10',
    String search = '',
    String sort = '',
    String category = 'all',
  }) async {
    final url = Uri.parse(
        'https://bewildered-toad-veil.cyclic.app/api/v1/product?search=$search&category=$category&sort=$sort&page=$page&limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // final dataMap = json.decode(response.body) as Map<String, dynamic>;
      // final dataList = dataMap['products'] as List<dynamic>;
      final dataList = json.decode(response.body) as List<dynamic>;

      List<ProductModel> productList = dataList.map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return productList;
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<ProductModel> fetchProduct(String id) async {
    final url =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/product/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load product");
    }
  }
}
