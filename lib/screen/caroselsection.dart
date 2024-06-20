import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/productmodel.dart';
//this is carosel section where carosel functionality work

class CarouselSection extends StatefulWidget {
  @override
  _CarouselSectionState createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //data fetched from products collection  and specialforyourproduct
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("products")
          .doc("YVmEUV8GdSmpfuQLHeYX")
          .collection("specialforyourproduct")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data found'));
        }

        var products = snapshot.data!.docs
            .map((doc) => Product(
                  image: doc["image"],
                  price: doc["price"],
                  name: doc["name"],
                  productId: doc.id,
                  starRating: doc["starRating"],
                  review: doc["review"],
                ))
            .toList();

        return Container(
          height: 230,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 60, 47).withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                 
                ),
                items: products.map((product) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Text('Image could not be loaded');
                          },
                        ),

                        // Overlay with text
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "\$ ${product.price} USD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                child: Row(
                  children: products.asMap().entries.map((entry) {
                    return Container(
                      width: 20.0, // Width of the line
                      height: 4.0, // Height of the line
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0), // Rounded corners for the line
                        color: _currentImageIndex == entry.key
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
