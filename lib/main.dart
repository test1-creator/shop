import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/products_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_product_screen.dart';

void main() {
  runApp(Shop());
}

class Shop extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products("", "", []),
          update: (_, auth, previousProducts) => Products(
              auth.token, auth.userId, previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
           create: (context) => Orders("","", []),
          update: (_, auth, previousOrders) => Orders(auth.token, auth.userId, previousOrders == null ? [] : previousOrders.orders),),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
            home: auth.isAuth ? ProductScreen() :
            FutureBuilder(future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ?
                 SplashScreen() : AuthScreen(),
            ),
            routes: {
              ProductDetailScreen.routeName : (context) => ProductDetailScreen(),
              CartScreen.routeName : (context) => CartScreen(),
              OrdersScreen.routeName : (context) => OrdersScreen(),
              UserProductsScreen.routeName : (context) => UserProductsScreen(),
              EditProductScreen.routeName : (context) => EditProductScreen(),
            },

            ),
      ),
      );
  }
}

