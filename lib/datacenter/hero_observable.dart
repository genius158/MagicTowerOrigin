import 'dart:async';

import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:rxdart/rxdart.dart';

class HeroProviderObservable {
  AbilityCharacter abilityCharacter;
  var _subject = BehaviorSubject<AbilityCharacter>();

  Stream<AbilityCharacter> get value => _subject.stream;

  void setHeroInfo(AbilityCharacter value) {
    abilityCharacter = value;
  }

  void update(AbilityCharacter value) {
    setHeroInfo(value);
    _subject.add(value);
  }

  void dispose() {
    _subject.close();
  }
}
