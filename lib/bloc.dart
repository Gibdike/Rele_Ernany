import 'dart:async';

class Bloc<T> {
  final _controller = StreamController<T>();

  Stream get stream => _controller.stream;

  add(T object) {
    _controller.add(object);
  }

  addError(Object error) {
    _controller.addError(error);
  }

  void dispose() {
    _controller.close();
  }
}