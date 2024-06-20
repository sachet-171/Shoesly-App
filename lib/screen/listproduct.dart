import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoeslymain/screen/detailscreen.dart';
import 'homepage.dart';
import '../model/productmodel.dart';
import '../widgets/singleproduct.dart';

// it show the  list of the product in infinite rooll
// where we add data in any  of the collection it will move here
class ListProduct extends StatefulWidget {
  final String name;

  ListProduct({required this.name});

  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  DocumentSnapshot? _lastDocument;
  final int _limit = 10;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts({bool resetSearch = false}) async {
    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (resetSearch || _searchQuery.isEmpty) {
        _products.clear();
        _filteredProducts.clear();
        _lastDocument = null;
      }

      // Fetch products from prodcuts
      Query productsQuery =
          _firestore.collection('products').orderBy('name').limit(_limit);
      if (_lastDocument != null) {
        productsQuery = productsQuery.startAfterDocument(_lastDocument!);
      }
      QuerySnapshot productsSnapshot = await productsQuery.get();
      List<Product> products = productsSnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();

      // Fetch special products
      Query productspecialQuery =
          _firestore.collection('productspecial').orderBy('name').limit(_limit);
      if (_lastDocument != null) {
        productspecialQuery =
            productspecialQuery.startAfterDocument(_lastDocument!);
      }
      QuerySnapshot productspecialSnapshot = await productspecialQuery.get();
      List<Product> productspecial = productspecialSnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();

      // Combine products and special products
      List<Product> allProducts = [...products, ...productspecial];

      if (allProducts.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      _lastDocument = productsSnapshot.docs.isNotEmpty
          ? productsSnapshot.docs.last
          : productspecialSnapshot.docs.last;

      setState(() {
        _products.addAll(allProducts);

        // Apply filter if search query is not empty
        if (_searchQuery.isNotEmpty) {
          _filteredProducts = _filterProducts(_products, _searchQuery);
        } else {
          _filteredProducts =
              List.from(_products); // Copy all products if no search
        }

        _isLoading = false;
      });

      // Debugging print statements
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to filter products based on search query
  List<Product> _filterProducts(List<Product> products, String query) {
    query = query.toLowerCase();
    return products
        .where((product) => product.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => HomePage(),
            ));
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              _hasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchProducts();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by product name...',
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16), // Adjust vertical padding
                    prefixIcon: Icon(Icons.search,
                        color: Colors.grey[700]), // Add search icon
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear,
                          color: Colors.grey[700]), // Add clear icon
                      onPressed: () {
                        setState(() {
                          _searchQuery = ''; // Clear the search query
                          _fetchProducts(
                              resetSearch: true); // Reset the product list
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white, // Background color
                    border: OutlineInputBorder(
                      
                      borderRadius: BorderRadius.circular(30), // Rounded border
                      borderSide: BorderSide(color: Colors.black12), // No border side
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Rounded border when focused
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5), // Border side color and width
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                      _fetchProducts(
                          resetSearch:
                              true); // Fetch products based on search query
                    });
                  },
                  style: TextStyle(
                      color: Colors.black, fontSize: 16), // Text style
                  cursorColor: Colors.blue, // Cursor color
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    Product product = _filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                            image: product.image,
                            name: product.name,
                            price: product.price,
                            productId: product.productId,
                            starRating: product.starRating,
                            review: product.review,
                          ),
                        ));
                      },
                      child: SingleProduct(
                        image: product.image,
                        name: product.name,
                        price: product.price,
                      ),
                    );
                  },
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!_isLoading && _filteredProducts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('No products available.')),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
