import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_data.dart';

class CartProduct {
  String cartId;
  String category;
  String productId;
  String size;
  int quantity;
  ProductData productData;
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cartId = document.documentID;
    category = document.data['category'];
    productId = document.data['productId'];
    size = document.data['size'];
    quantity = document.data['quantity'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'productId': productId,
      'size': size,
      'quantity': quantity,
      'product': productData.toResumeMap(),
    };
  }
}
