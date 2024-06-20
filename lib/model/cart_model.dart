class CartItem {
  final String name;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  // Method to convert CartItem instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  // Static method to create a CartItem instance from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
    );
  }
}
