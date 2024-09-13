import 'package:equatable/equatable.dart';
import 'package:mini_store/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductEvent {
  final int page;
  final int pageSize;
  final String query;

  LoadProductsEvent({required this.page, required this.pageSize, required this.query});
}

class SearchProductEvent extends ProductEvent {
  final int page;
  final int pageSize;
  final String query;
  SearchProductEvent({required this.page, required this.pageSize, required this.query});
}

class AddProductEvent extends ProductEvent {
  final Product product;

  AddProductEvent({required this.product});

  @override
  List<Object?> get props => [product];
}
