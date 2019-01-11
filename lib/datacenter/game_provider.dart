import 'package:flutter/material.dart';
import 'package:magic_tower_origin/datacenter/game_observable.dart';
import 'package:magic_tower_origin/datacenter/hero_observable.dart';

class GameProvider extends InheritedWidget {
  final HeroProviderObservable _heroProvider = HeroProviderObservable();
  final GameProviderObservable _gameProvider = GameProviderObservable();

  GameProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static HeroProviderObservable ofHero(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(GameProvider) as GameProvider)
          ._heroProvider;
  static GameProviderObservable ofGame(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(GameProvider) as GameProvider)
          ._gameProvider;
}
