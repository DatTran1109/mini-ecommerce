import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_ecommerce/data/models/category_model.dart';

class CategoryService {
  static Future<List<CategoryModel>> fetchAllCategory() async {
    final uri =
        Uri.parse('https://bewildered-toad-veil.cyclic.app/api/v1/category');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dataList = json.decode(response.body) as List<dynamic>;

      List<CategoryModel> categoryList = dataList.map((item) {
        return CategoryModel.fromJson(item);
      }).toList();

      return categoryList;
    } else {
      throw Exception("Failed to load category");
    }
  }
}
