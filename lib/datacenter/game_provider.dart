import 'package:flutter/material.dart';
import 'package:magic_tower_origin/datacenter/game_observable.dart';
import 'package:magic_tower_origin/datacenter/hero_observable.dart';

class GameProvider extends StatefulWidget {
  final HeroProviderObservable _heroProvider = HeroProviderObservable();
  final GameProviderObservable _gameProvider = GameProviderObservable();

  Widget child;

  GameProvider({Key key, this.child}) : super(key: key);

  static HeroProviderObservable ofHero(BuildContext context) =>
      (context.ancestorWidgetOfExactType(GameProvider) as GameProvider)
          ._heroProvider;

  static GameProviderObservable ofGame(BuildContext context) =>
      (context.ancestorWidgetOfExactType(GameProvider) as GameProvider)
          ._gameProvider;

  @override
  State<StatefulWidget> createState() {
    return _GameProviderState();
  }
}

class _GameProviderState extends State<GameProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    widget._heroProvider.dispose();
    widget._gameProvider.dispose();
  }
}
