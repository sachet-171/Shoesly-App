import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoeslymain/model/productmodel.dart';

//Making of the brandId in firebase to filter the product as per the Brand of product

class BrandListProduct extends StatelessWidget {
  final String name;
  final String brandId;

  BrandListProduct({required this.name, required this.brandId});

  Future<List<Product>> fetchProductsForBrand(String brandId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('productspecial')
          .where('brandId', isEqualTo: brandId)
          .get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product(
          name: doc['name'],
          price: doc['price'].toDouble(),
          image: doc['image'],
          productId: doc['productId'],
          starRating: doc['starRating'],
          review: doc['review'],
          // Add other fields like starRating, review, etc. if available
        );
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products for brandId: $brandId');
      print(e);
      return []; // Return empty list or handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name), // Display brand name in the app bar
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProductsForBrand(brandId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found for this brand'));
          } else {
            // Display products using ListView or GridView
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Price: ${product.price.toStringAsFixed(2)}'),
                  // Implement onTap for each product if needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
