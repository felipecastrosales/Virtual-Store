import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/cart_model.dart';
import 'models/user_model.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
            title: '@normaltda',
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            theme: ThemeData(
              primarySwatch: Colors.amber,
              primaryColor: Colors.amber,
            ),
          ),
        );
      }),
    );
  }
}
