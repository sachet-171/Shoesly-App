import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shoeslymain/provider/cartprovider.dart';
import 'package:shoeslymain/screen/cartPage.dart';
import '../model/cart_model.dart';


class DetailScreen extends StatefulWidget {
  final String name;
  final double price;
  final String productId;
  final String starRating;
  final String review;
  final String image;

  DetailScreen({
    required this.name,
    required this.price,
    required this.productId,
    required this.starRating,
    required this.review,
    required this.image,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;
  int count = 1;
  String? description;
  List<int> sizes = [];
  int? selectedSize;
  bool isLoading = true;
  bool isFavorited = false; // Track favorite state

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('productspecial')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        setState(() {
          description = doc['description'];
          sizes = (doc['sizes'] as List<dynamic>)
              .map((size) => size is int
                  ? size
                  : (size is double
                      ? size.round() // or any other handling for double values
                      : int.tryParse(size.toString()) ?? 0))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching product details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildSizeProduct({required int size}) {
    bool isSelected = size == selectedSize;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = isSelected ? null : size;
        });
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : const Color(0xfff2f2f2),
        ),
        child: Center(
          child: Text(
            size.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  final TextStyle myStyle = const TextStyle(fontSize: 18);

  double getTotalPrice() {
    return widget.price * count;
  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: ListView(
                children: [
                  Container(
                    height: 840,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          width: 315,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Stack(
                                  children: [
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        height: 220,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: false,
                                        viewportFraction: 1.0,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentImageIndex = index;
                                          });
                                        },
                                      ),
                                      items: List.generate(3, (index) => index)
                                          .map(
                                            (item) => Container(
                                              child: Image.network(
                                                widget.image,
                                                fit: BoxFit.fill,
                                                width: 315,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: toggleFavorite,
                                        child: Icon(
                                          isFavorited
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorited
                                              ? Colors.red
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: List.generate(3, (index) {
                                          return Container(
                                            width: 10.0,
                                            height: 10.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentImageIndex == index
                                                  ? const Color.fromARGB(255, 0, 4, 8)
                                                  : Colors.grey,
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(
                                        width: 180,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color.fromARGB(255, 223, 222, 222),
                                        ),
                                        height: 35,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                            ),
                                            SizedBox(width: 9),
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            SizedBox(width: 9),
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Colors.green,
                                            ),
                                            SizedBox(width: 9),
                                            CircleAvatar(
                                              radius: 13,
                                              backgroundColor: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                widget.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                      int.tryParse(widget.starRating) ?? 0,
                                          (index) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${widget.starRating} stars',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 14, 13, 13),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '(Reviews: ${widget.review != true ? widget.review : "No review"})',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Size",
                                style: myStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 320,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: sizes
                                        .map((size) => Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: _buildSizeProduct(size: size),
                                    ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Description",
                                style: myStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 115,
                                child: SingleChildScrollView(
                                  child: Text(
                                    description ?? "No description available",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Quantity",
                                style: myStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (count > 1) {
                                              count--;
                                            }
                                          });
                                        },
                                        child: const Icon(Icons.remove)),
                                    Text(
                                      count.toString(),
                                      style: myStyle,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            count++;
                                          });
                                        },
                                        child: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Price",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "\$ ${getTotalPrice().toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 5),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final cart = Provider.of<Cart>(context,
                                              listen: false);
                                          cart.addItem(
                                            CartItem(
                                              name: widget.name,
                                              price: widget.price,
                                              quantity: count,
                                              image: widget.image,
                                            ),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CartPage(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        child: const Text(
                                          'ADD TO CART',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
