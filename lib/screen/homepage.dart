import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shoeslymain/model/category_model.dart';

import 'package:shoeslymain/screen/caroselsection.dart';
import 'package:shoeslymain/screen/cartPage.dart';
import 'package:shoeslymain/screen/favrouite_product.dart';
import 'package:shoeslymain/screen/filter_product.dart';
import 'package:shoeslymain/screen/listproduct.dart';
import 'package:shoeslymain/screen/specialforyousection.dart';
import 'package:shoeslymain/service/category_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedStarRatingFilter;
  late Future<List<Category>> _categories;
  double? starRating;
 

  @override
  void initState() {
    super.initState();
    _categories = CategoryService().getCategories();
  }

  Widget _buildCategoryBrandProduct({
    required String image,
    required int color,
    required String label,
    required String sublabel,
  }) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 38,
          backgroundColor: Color(color),
          child: Center(
            child: Container(
              height: 40,
              child: Image(
                image: AssetImage("assets/images/$image"),
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          sublabel,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //beginning of the search bar and card icon 
      key: _key,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: screenWidth * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[700],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.shopping_bag,
                            color: Colors.grey[700],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => CartPage()));
                          },
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 247, 243, 243),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 255, 254, 254)!,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: "What are you looking for?",
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      cursorColor: const Color.fromARGB(255, 224, 224, 224),
                    ),
                    SizedBox(height: 25),

                    //beginning of carousel section //import from other caroselsection.dart file
                    CarouselSection(),

                  //beginning of Brand section //All fetched from firebase  brand collection


                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Brands",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showFilterDialog(context);
                            },
                            child: Text("Filter"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<Category>>(
                      future: _categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No categories found'));
                        } else {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: snapshot.data!.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ListProduct(
                                                name: category.name,
                                                
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              category.image,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${category.price.toStringAsFixed(0)} items',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

           //beginning of Brand section //All fetched from firebase  productspecial collection
              //import from sepecialforyoursection.dart

              SizedBox(height: 10),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.0),
                      child: Text(
                        "Special For Your",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ListProduct(
                                  name: "Special For Your",
                                )));
                      },
                      child: Text(
                        "view more",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SpecialForYouSection(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      //beginning of Navigation section 

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.shopping_basket),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ListProduct(
                            name: "List of products",
                          )));
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => CartPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>FavoriteProduct()));
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _showFilterDialog(context);
                },
                child: Text("Filter"),
              ),
            ],
          ),
        ),
      ),
    );
  }  

  //filter function to provide star to collect data from firebase

  void _showFilterDialog(BuildContext context) {
  TextEditingController starRatingController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      double rating = 0; // State variable to hold selected star rating

      return AlertDialog(
        title: Text("Apply Filters"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Star Rating:"),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating; // Update the selected rating
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => FilterProductScreen(
                        starRating: rating, // Pass selected rating to the next screen
                      ),
                    ));
                  },
                  child: Text("Apply"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}