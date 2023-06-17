import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DebugPrint on Object? {
  void log() => debugPrint(toString());
}

extension NullOrEmptyCheck on String? {
  bool get isNull => this == null;
  bool get isNuUOrEmpty => isNull || this!.isEmpty;
}

extension SpaceXY on num {
  SizedBox get spaceX => SizedBox(width: toDouble());
  SizedBox get spaceY => SizedBox(height: toDouble());
}

num n = 5;

extension GetNumber on String {
  int get getNumber => int.tryParse(trim().replaceAll(RegExp(r'\D+'), '')) ?? 0;
}

extension GetDate on int {
  String get toDate => DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(this));
}

extension GetTime on int {
  String get toTime => DateFormat('hh-mm').format(DateTime.fromMillisecondsSinceEpoch(this));
}
Map indexMap = {
  0:"A",
  1:"B",
  2:"C",
  3:"D",
  4:"E"
};