import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeslymain/provider/cartprovider.dart'; // Import your Cart provider
import 'package:shoeslymain/screen/homepage.dart'; // Replace with your home screen

void main() async {
  //initialized of firebase ,
  //shared preferences to store data ,
  //provided method also 
  
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  final cart = Cart();
  await cart.loadCart(); 
  runApp(
    ChangeNotifierProvider.value(
      value: cart,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: HomePage(), 
    );
  }
}
