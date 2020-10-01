import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
              Navigator.of(context).pop();
              controller.jumpToPage(page);
          },
          child: Container(
            height: 60.0,
              child: Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 32,
                    color: controller.page.round() == page ?
                    Colors.grey[800] : Colors.amber,
                  ),
                  SizedBox(width: 24,),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: controller.page.round() == page ?
                      Colors.grey[800] : Colors.amber,
                    ),
                  )
                ],
              ),
          ),
        ),
      );
  }
}
