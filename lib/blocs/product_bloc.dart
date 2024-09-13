import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../repositories/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductLoading()) {
    // Load products
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productRepository.fetchProducts(event.page, event.pageSize);
        emit(ProductLoaded(products: products, hasReachedMax: products.isNotEmpty));
      } catch (e) {
        print(e);
        emit(ProductError(e.toString()));
      }
    });

    // Add product
    on<AddProductEvent>((event, emit) async {
      print('Addproduct event ${event.product.name}');
      emit(ProductAdding());
      try {
        await productRepository.addProduct(event.product);
        emit(ProductAdded());
      } catch (e) {
        print(e);
        emit(ProductError(e.toString()));
      }
      // final currentState = state as ProductLoaded;
      // final List<Product> updatedProducts = List.from(currentState.products)..add(event.product);
      // emit(ProductLoaded(products: updatedProducts));
    });
  }
}
