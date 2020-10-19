import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 300,
            child: Image.network(
              snapshot.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  snapshot.data['title'],
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  snapshot.data['address'],
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              height: 8.0,
              width: double.maxFinite,
              child: Divider(
                height: 4,
                color: Colors.amber,
                indent: 50,
                endIndent: 50,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Ver no Mapa',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                textColor: Colors.amber,
                padding: EdgeInsets.zero,
                onPressed: () {
                  launch(
                      'https://www.google.com/maps/search/?api=1&query=${snapshot.data['lat']},'
                      '${snapshot.data['long']}');
                },
              ),
              FlatButton(
                child: Text(
                  'Ligar',
                  style: TextStyle(
                    fontFamily: 'Merriweather',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  launch('tel: ${snapshot.data['phone']}');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
