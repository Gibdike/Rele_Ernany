import 'dart:async';

import 'package:controle_bluetooth/bloc/bloc.dart';
import 'package:intl/intl.dart';

class LogController extends Bloc<List<String>> {
  static List<String> _log = [];

  transmit(String msg) {
    final now = DateTime.now();
    String dateTime = DateFormat('jms').format(now);
    _log.add('${dateTime.toString()}: $msg');
    add(_log);
  }

  @override
  add(List<String> data) {
    streamController.add(data);
  }

  @override
  addError(Object error) {
    return streamController.addError(error);
  }

  @override
  Stream get stream => streamController.stream;

  @override
  void dispose() {
    _log = [];
    super.dispose();
  }
}
