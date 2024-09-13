import 'package:dio/dio.dart';
import 'package:mini_store/config/constant.dart';
import '../models/product_model.dart';

class ProductRepository {
  final Dio _dio = Dio();
  final String baseUrl = '${Constant.baseUrl}${Constant.appId}/products';

  // Fetch products with pagination
  Future<List<Product>> fetchProducts(int page, int pageSize) async {
    try {
      // Fetch all products
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        List<dynamic> allProducts = response.data;

        // Paginate manually
        int startIndex = (page - 1) * pageSize;
        int endIndex = startIndex + pageSize;

        if (startIndex >= allProducts.length) return [];

        if (endIndex > allProducts.length) endIndex = allProducts.length;

        // Convert JSON to Product model
        List<Product> products =
            allProducts.sublist(startIndex, endIndex).map((json) => Product.fromJson(json)).toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  // Add New Product
  Future<void> addProduct(Product product) async {
    try {
      final params = product.toJson();
      print(params);
      Response response = await _dio.post(baseUrl, data: product.toJson());
      print(response);
      if (response.statusCode != 201) {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to add product: $e');
    }
  }
}
