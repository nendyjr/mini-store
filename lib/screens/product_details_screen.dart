import 'package:flutter/material.dart';
import 'package:mini_store/models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product?.name ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (product?.image ?? '') != ''
                ? Image.network(
                    product!.image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/default_image.png"),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            Text(product?.name ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Category: ${product?.categoryName ?? ''}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Price: ${product?.harga}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(product?.description ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Dimensions: ${product?.width} x ${product?.length} x ${product?.height} cm'),
            const SizedBox(height: 8),
            Text('Weight: ${product?.weight}g'),
          ],
        ),
      ),
    );
  }
}
