import 'package:dio/dio.dart';
import 'package:mini_store/config/constant.dart';
import 'package:mini_store/models/category_model.dart';

class CategoryRepository {
  final Dio dio = Dio();
  final String baseUrl = "${Constant.baseUrl}${Constant.appId}/categories"; // Replace with your API key

  // Fetch all categories
  Future<List<Category>> fetchCategories() async {
    final response = await dio.get(baseUrl);
    final categories = (response.data as List).map((json) => Category.fromJson(json)).toList();
    return categories;
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    await dio.post(baseUrl, data: category.toJson());
  }

  // Delete a category (optional)
  Future<void> deleteCategory(String id) async {
    await dio.delete('$baseUrl/$id');
  }
}
