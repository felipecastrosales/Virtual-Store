import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class DiscountCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de Desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(), 
                hintText: 'Digite o seu cupom'),
              initialValue: CartModel.of(context).couponCode ?? '',
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection('coupons')
                    .document(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data != null) {
                    CartModel.of(context)
                      .setCoupon(text, docSnap.data['percent']);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.amber,
                      content: Text(
                        'Seu desconto de '
                        '${docSnap.data['percent']}% foi aplicado.',
                      ),
                    ));
                  } else {
                    CartModel.of(context).setCoupon(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Esse cupom não existe, verifique se seu código '
                        'está certo ou entre em contato conosco.',
                      ),
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
