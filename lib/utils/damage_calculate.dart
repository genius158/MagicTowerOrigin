import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/ability/ability_magic_entry.dart';

class DamageCalculate {
  /// 攻击式是：别人的血除以你攻击力减别人的防御力的得数减1，再成别人攻击力减你防御力的数，就是它减你的血。
  ///   1、 攻杀：勇士攻击＞怪物生命＋防御（对所有怪物适用）
  ///   2、 防杀：勇士防御＞怪物攻击 （对魔攻以外的怪物适用）
  ///   3、 勇士攻击必须大于怪物防御，否则该怪物不可攻击，即损失为“？？？”
  ///   4、 计算：
  ///   a) 战斗次数：怪物生命÷（勇士攻击－怪物防御） [注：舍小数点取整数]
  ///   b) 损失计算：战斗次数×（怪物攻击－勇士防御）×怪物进攻
  ///   c) 对于魔攻的怪物，当勇士防御大于怪物攻击时，每次战斗损失＝怪物攻击
  static calculate(AbilityEntry ha, AbilityEntry ea) {
    if (ha.attack > ea.defend + ea.life) {
      return 0;
    }
    if (ha.attack <= ea.defend) {
      return "???";
    }

    if (ha.defend > ea.attack) {
      return 0;
    }

    int attackCount = ea.life ~/ (ha.attack - ea.defend);
    if (ea is AbilityMagicEntry) {
      attackCount++;
    }

    int damage = attackCount * (ea.attack - ha.defend);

    print("calculate   $attackCount  $damage");
    return damage;
  }
}
