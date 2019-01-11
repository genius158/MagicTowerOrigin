import 'package:magic_tower_origin/ability/base_entry.dart';

class PropEntry extends BaseEntry<PropEntry> {
  int times = -1;
  int propType;

  PropEntry setTimes(int times) {
    this.times = times;
    return this;
  }

  PropEntry setPropType(int propType) {
    this.propType = propType;
    return this;
  }

  merge(PropEntry other) {
    if (times > 0) {
      times += other.times;
    }
  }
}
