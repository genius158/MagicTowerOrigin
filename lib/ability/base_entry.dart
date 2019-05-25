import 'package:magic_tower_origin/role/name_role.dart';

/// 能力基类
class BaseEntry<T extends Name> extends Name {
  bool passable = true;

  BaseEntry() : super("power");

  BaseEntry setPassable(bool able) {
    if (able == null) {
      return this;
    }
    this.passable = able;
    return this;
  }

  merge(T t) {}
}
