import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/products_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

void main() {
  runApp(Shop());
}

class Shop extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products(),),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
          home: ProductScreen(),
          routes: {
            ProductDetailScreen.routeName : (context) => ProductDetailScreen(),
            CartScreen.routeName : (context) => CartScreen(),
            OrdersScreen.routeName : (context) => OrdersScreen(),
            UserProductsScreen.routeName : (context) => UserProductsScreen(),
            EditProductScreen.routeName : (context) => EditProductScreen(),
          },
          ),
      );
  }
}

