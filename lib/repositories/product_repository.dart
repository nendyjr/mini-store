import 'package:dio/dio.dart';
import 'package:mini_store/config/constant.dart';
import 'package:mini_store/repositories/product_preference.dart';
import 'package:mini_store/models/product_model.dart';

class ProductRepository {
  final Dio _dio = Dio();
  final String baseUrl = '${Constant.baseUrl}${Constant.appId}/products';
  final ProductPreference _preference = ProductPreference();

  // Fetch products with pagination
  Future<List<Product>> fetchProducts(int page, int pageSize, String search) async {
    try {
      if (page > 1 || search.isNotEmpty) {
        final products = await _preference.loadProductList();
        return getPagination(products, page, pageSize, search);
      } else {
        // Fetch all products
        final response = await _dio.get(baseUrl);
        if (response.statusCode == 200) {
          List<dynamic> allProducts = response.data;

          List<Product> products = allProducts.map((json) => Product.fromJson(json)).toList();

          _preference.saveProductList(products);

          return getPagination(products, page, pageSize, search);
        } else {
          throw Exception('Failed to load products');
        }
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }

  // Add New Product
  Future<void> addProduct(Product product) async {
    try {
      final params = product.addProductToJson();
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

  List<Product> getPagination(List<Product> allProducts, int page, int pageSize, String search) {
    final filteredProducts = search.isNotEmpty
        ? allProducts.where((product) {
            return (product.name ?? '').toLowerCase().contains(search.toLowerCase()) ||
                (product.categoryName ?? '').toLowerCase().contains(search.toLowerCase());
          }).toList()
        : allProducts;
    int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    if (startIndex >= filteredProducts.length) return [];

    if (endIndex > filteredProducts.length) endIndex = filteredProducts.length;

    return filteredProducts.sublist(startIndex, endIndex);
  }
}
