import 'package:flutter/material.dart';

initDropdownTemperature() {
  List<DropdownMenuItem<int>> itens = [];
  for (int i = 17; i <= 27; i++) {
    itens.add(DropdownMenuItem(
      value: i,
      child: new Text(i.toString()),
    ));
  }
  return itens;
}
