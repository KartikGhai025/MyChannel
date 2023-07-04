
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color bgcolor= Colors.red;
//Color(0xffF15F60);

final String keyId= 'channelId';

void addCheck() async {
  SharedPreferences pr = await SharedPreferences.getInstance();
  pr.setStringList('check', ['Kartik']);
}

void setDetails(String id, String name, String imageUrl)async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  List<String> channelId= pref.getStringList(keyId)!;
  channelId.add(id);
  print(channelId);
  pref.setStringList(keyId,channelId);
  pref.setString(id, name);
  pref.setString('${id}image', imageUrl);
  String? check = await pref.getString(id);
  print(check);
}

Future<String> getName(String id)async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  String name = pref.getString(id)!;
  return name;

}



class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = Paint()
      ..color = bgcolor
      ..style = PaintingStyle.fill;

    Path path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * .1, 0)
      ..cubicTo(size.width * .05, 0, 0, 20, 0, size.width * .08);

    Path path_2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * .9, 0)
      ..cubicTo(
          size.width * .95, 0, size.width, 20, size.width, size.width * .08);

    Paint paint_2 = Paint()
      ..color = bgcolor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path_3 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path_1, paint_1);
    canvas.drawPath(path_2, paint_1);
    canvas.drawPath(path_3, paint_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
