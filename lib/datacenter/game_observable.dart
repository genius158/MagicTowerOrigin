import 'dart:async';

import 'package:rxdart/rxdart.dart';

class GameProviderObservable {
  var _subject = PublishSubject<dynamic>();

  Stream<dynamic> get value => _subject.stream;

  void update(dynamic value) {
    _subject.add(value);
  }

  void dispose() {
    _subject.close();
  }
}
