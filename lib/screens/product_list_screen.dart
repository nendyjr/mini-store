import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/repositories/product_repository.dart';
import 'package:mini_store/blocs/product_bloc.dart';
import 'package:mini_store/blocs/product_state.dart';
import 'package:mini_store/blocs/product_event.dart';
import 'package:mini_store/models/product_model.dart';
import 'package:mini_store/screens/product_details_screen.dart';
import 'package:mini_store/screens/add_product_modal.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListScreen> {
  final ProductBloc _newsBloc = ProductBloc(productRepository: ProductRepository());
  final ScrollController _controller = ScrollController();
  List<Product> productList = [];
  int _currentPage = 1;
  final pageSize = 10;
  bool hasNextPage = false;

  @override
  void initState() {
    _newsBloc.add(LoadProductsEvent(page: 1, pageSize: pageSize));
    super.initState();
    _controller.addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadMore() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && hasNextPage) {
      _currentPage++;
      _newsBloc.add(LoadProductsEvent(page: _currentPage, pageSize: pageSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: BlocProvider(
        create: (context) => _newsBloc,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading || state is ProductAdding) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              hasNextPage = !state.hasReachedMax;
              if (state.products.isEmpty) return const Center(child: Text('Product list is empty'));

              if (_currentPage == 1) {
                productList = state.products;
              } else {
                productList.addAll(state.products);
              }
              return ListView.builder(
                controller: _controller,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  Product product = state.products[index];
                  return ListTile(
                    leading: Image.network(product.image ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.png")),
                    title: Text(product.name ?? ''),
                    subtitle: Text('Price: ${product.harga}'),
                    onTap: () {
                      // Navigate to the ProductDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ProductAdded) {
              _newsBloc.add(LoadProductsEvent(page: 1, pageSize: 10));
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return const Center(child: Text('Failed to load products'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show AddProductModal when FAB is pressed
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BlocProvider.value(
                value: _newsBloc,
                child: AddProductModal(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
