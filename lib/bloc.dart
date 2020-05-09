import 'dart:async';

abstract class Bloc<T>{
  final _controller = StreamController<T>();

  StreamController<T> get streamController => _controller;

  Stream get stream;
  add(T object);
  addError(Object error);
  void dispose() {
    _controller.close();
  }
}