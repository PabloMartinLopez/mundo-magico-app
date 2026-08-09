import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier{
  Color _color = Colors.amber;

  Color get color => _color;

  void changeColor(Color color){
    _color = color;
    notifyListeners();
  }

}