import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../datas/cart_product.dart';
import '../datas/product_data.dart';
import '../models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
            width: 150,
            child: Image.network(
              cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    'Tamanho ${cartProduct.size}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.amber),
                        onPressed: cartProduct.quantity > 1
                          ? () {
                              CartModel.of(context).decProduct(cartProduct);
                            }
                          : null,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.amber, size: 30),
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                      ),
                    ],
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      'Remover',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                    ),
                    onPressed: () {
                      CartModel.of(context).removeCartItem(cartProduct);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: cartProduct.productData == null
        ? FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance
                .collection('products')
                .document(cartProduct.category)
                .collection('items')
                .document(cartProduct.productId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cartProduct.productData =
                    ProductData.fromDocument(snapshot.data);
                return _buildContent();
              } else {
                return Container(
                  height: 100,
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            },
          )
        : _buildContent());
  }
}
