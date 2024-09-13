import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/blocs/product_bloc.dart';
import 'package:mini_store/blocs/product_event.dart';
import 'package:mini_store/models/category_model.dart';
import 'package:mini_store/models/product_model.dart';
import 'package:mini_store/repositories/category_repository.dart';

class AddProductModal extends StatefulWidget {
  const AddProductModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _sku;
  String? _description;
  int? _price;
  int? _weight;
  int? _width;
  int? _length;
  int? _height;
  String? _image;
  Category? _selectedCategory;
  List<Category> _categories = [];
  final _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load categories from API
  Future<void> _loadCategories() async {
    final categories = await _categoryRepository.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.91,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            const Text(
              'Add New Product',
              style: TextStyle(fontSize: 18),
            ),
            Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Product Name'),
                        onSaved: (value) => _name = value,
                        validator: (value) => value!.isEmpty ? 'Enter product name' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'SKU'),
                        onSaved: (value) => _sku = value,
                        validator: (value) => value!.isEmpty ? 'Enter SKU' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        onSaved: (value) => _description = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price (Rp)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _price = int.tryParse(value!),
                        validator: (value) => value!.isEmpty ? 'Enter price (Rp)' : null,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'weight (gr)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _weight = int.tryParse(value!),
                        validator: (value) => value!.isEmpty ? 'Enter weight (gr)' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'width (cm)'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _width = int.tryParse(value!),
                              validator: (value) => value!.isEmpty ? 'Enter width (cm)' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'length (cm)'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _length = int.tryParse(value!),
                              validator: (value) => value!.isEmpty ? 'Enter length (cm)' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'height (cm)'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _height = int.tryParse(value!),
                              validator: (value) => value!.isEmpty ? 'Enter height (cm)' : null,
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField<Category>(
                        decoration: InputDecoration(labelText: 'Category'),
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        validator: (value) => value == null ? 'Select a category' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Image Url'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _image = value!,
                        validator: (value) => value!.isEmpty ? 'Enter height' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('Add Product'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  // Check if the category exists, if not add it to the server
                                  if (_selectedCategory == null) {
                                    return;
                                  }

                                  final newProduct = Product(
                                    id: (DateTime.now().millisecondsSinceEpoch / 1000).round(),
                                    categoryId: _selectedCategory!.id,
                                    categoryName: _selectedCategory!.name,
                                    sku: _sku!,
                                    name: _name!,
                                    description: _description!,
                                    weight: _weight ?? 0,
                                    width: _width ?? 0,
                                    length: _length ?? 0,
                                    height: _height ?? 0,
                                    image: _image ?? '',
                                    harga: _price!,
                                    internalId: '',
                                  );

                                  BlocProvider.of<ProductBloc>(context).add(AddProductEvent(product: newProduct));

                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
