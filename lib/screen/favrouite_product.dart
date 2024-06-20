import 'package:flutter/material.dart';
// in this when we clicked favroutie icon then    this data is stored in fav nav bar
class FavoriteProduct extends StatefulWidget {
  static List<Map<String, dynamic>> favoriteItems = []; // List to store favorite items

  @override
  _FavoriteProductState createState() => _FavoriteProductState();

  static void addToFavorites(String image, String name, double price) {
    // Method to add a product to favorites
    favoriteItems.add({
      'image': image,
      'name': name,
      'price': price,
    });
  }

  static void removeFromFavorites(String image) {
    // Method to remove a product from favorites (if needed)
    favoriteItems.removeWhere((item) => item['image'] == image);
  }
}

class _FavoriteProductState extends State<FavoriteProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: ListView.builder(
        itemCount: FavoriteProduct.favoriteItems.length,
        itemBuilder: (context, index) {
          var item = FavoriteProduct.favoriteItems[index];
          return ListTile(
            leading: Image.network(item['image']),
            title: Text(item['name']),
            subtitle: Text('\$ ${item['price']}'),
          );
        },
      ),
    );
  }
}
