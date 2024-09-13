import 'dart:convert';
import 'package:mini_store/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPreference {
  static const String _productListKey = 'productList';

  Future<void> saveProductList(List<Product> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList = products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(_productListKey, jsonStringList);
  }

  Future<List<Product>> loadProductList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList(_productListKey);

    if (jsonStringList == null) {
      return [];
    }

    List<Product> productList = jsonStringList.map((jsonString) => Product.fromJson(jsonDecode(jsonString))).toList();
    return productList;
  }

  Future<void> clearProductList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productListKey);
  }
}
