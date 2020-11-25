import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../datas/cart_product.dart';
import 'user_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  String couponCode;
  int discountPercentage = 0;
  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn) {
      _loadCartItem();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .add(cartProduct.toMap())
        .then((doc) => cartProduct.cartId = doc.documentID);
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .document(cartProduct.cartId)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrice() {
    notifyListeners();
  }

  double getProductPrice() {
    var price = 0.0;
    for (var subprice in products) {
      if (subprice.productData != null) {
        price += subprice.quantity * subprice.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 0.00;
  }

  Future<String> finishOrder() async {
    if (products.isEmpty) return null;
    isLoading = true;
    notifyListeners();
    var productsPrice = getProductPrice();
    var shipPrice = getShipPrice();
    var discount = getDiscount();
    var refOrder = await Firestore.instance.collection('orders').add({
      'clientId': user.firebaseUser.uid,
      'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productsPrice,
      'discount': discount,
      'totalPrice': productsPrice + shipPrice - discount,
      'status': 1
    });
    await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('orders')
        .document(refOrder.documentID)
        .setData({'orderId': refOrder.documentID});
    var query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();
    for (var doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

  void _loadCartItem() async {
    var query = await Firestore.instance
        .collection('users')
        .document(user.firebaseUser.uid)
        .collection('cart')
        .getDocuments();
    products = query.documents.map((doc) => 
      CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}
