import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeslymain/provider/cartprovider.dart';
import 'package:shoeslymain/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// this is final checkout page  
//where data come from cart and data like names quantity image etc  and 
//when we provide the details it store in firebase also 
class CheckoutPage extends StatelessWidget {
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            _buildSectionTitle('Order Summary'),
            _buildOrderSummary(cart),
            SizedBox(height: 24.0),
            _buildSectionTitle('Payment Method'),
            _buildPaymentMethodSelection(),
            SizedBox(height: 24.0),
            _buildSectionTitle('Location'),
            _buildLocationSelection(),
            SizedBox(height: 24.0),
            _buildSectionTitle('Order Details'),
            _buildOrderDetails(cart),
            SizedBox(height: 24.0),
            _buildSectionTitle('Payment Details'),
            _buildPaymentDetails(),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _placeOrder(context, cart);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
              ),
              child: Text('Place Order', style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }
 // total price is seen in firebase collection
  Widget _buildOrderSummary(Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Items: ${cart.items.length}', style: TextStyle(fontSize: 16.0)),
        SizedBox(height: 8.0),
        Text('Grand Total: \$${cart.getTotalPrice().toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text('Select Payment Method', style: TextStyle(fontSize: 16.0)),
    );
  }
//location will be manual
// we can provide map  also
  Widget _buildLocationSelection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text('Enter Delivery Location', style: TextStyle(fontSize: 16.0)),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(hintText: 'Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cart.items
          .map((item) => ListTile(
                leading: Image.network(
                  item.image,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                title: Text(item.name),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
              ))
          .toList(),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text('Payment Details', style: TextStyle(fontSize: 16.0)),
    );
  }

  Future<void> _placeOrder(BuildContext context, Cart cart) async {
    String location = _locationController.text;

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a delivery location')),
      );
      return;
    }

    // Collect order details
    List<Map<String, dynamic>> orderItems = cart.items.map((item) {
      return {
        'name': item.name,
        'quantity': item.quantity,
        'price': item.price,
        'total': item.price * item.quantity,
        'image': item.image,
      };
    }).toList();

    double totalPrice = cart.getTotalPrice();

    Map<String, dynamic> orderDetails = {
      'items': orderItems,
      'totalPrice': totalPrice,
      'location': location,
      'timestamp': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance.collection('orders').add(orderDetails);

      // Clear the cart
      cart.clearCart();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Order Placed'),
          content: Text('Your order has been placed successfully.'),  //we provide the details it store in firebase also 
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HomePage()));
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order. Please try again.')),
      );
    }
  }
}
