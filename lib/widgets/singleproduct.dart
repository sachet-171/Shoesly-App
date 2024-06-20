import 'package:flutter/material.dart';
import 'package:shoeslymain/screen/favrouite_product.dart';


class SingleProduct extends StatefulWidget {
  final String image;
  final String name;
  final double price;
  
  SingleProduct({required this.image, required this.name, required this.price});
 
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Card(
      child: Container(
        height: height * 0.35,
        width: width * 0.2 * 2 + 10,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.image),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite; // Toggle favorite state
                        });

                        if (isFavorite) {
                          // Add the favorited product to the favorite list
                          FavoriteProduct.addToFavorites(widget.image, widget.name, widget.price);
                        } else {
                          // Remove the favorited product from the favorite list (if needed)
                          // This logic depends on your requirements
                          FavoriteProduct.removeFromFavorites(widget.image);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.favorite,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      widget.name,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "\$ ${widget.price.toString()}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color.fromARGB(255, 0, 0, 0)),
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
