import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'models/cart_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: '@normaltda',
              theme: ThemeData(
                primarySwatch: Colors.amber,  
                primaryColor: Colors.amber,
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen()
            ),
          );
        }
      ),
    );
  }
}