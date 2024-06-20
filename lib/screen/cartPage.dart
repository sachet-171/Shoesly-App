import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeslymain/provider/cartprovider.dart';
import 'package:shoeslymain/screen/checkout_page.dart'; // Replace with your cart provider import
// making of cart section 
//card inludes images price name quality 
//and grand total section also
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(item.image),
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (item.quantity > 1) {
                                    cart.updateItemQuantity(item, item.quantity - 1);  // number increased
                                  }
                                },
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  cart.updateItemQuantity(item, item.quantity + 1);    // number decreased
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this item?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.removeItem(item);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Grand Total: \$${cart.getTotalPrice().toStringAsFixed(2)}',   //grand total price of all carts item price
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  
                  onPressed: () {
                  
                     Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage()));
                    
                  },
                  style: ElevatedButton.styleFrom(
                    
                    backgroundColor: Colors.blue.shade300
                  ),
                  child: Text('Checkout',style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
