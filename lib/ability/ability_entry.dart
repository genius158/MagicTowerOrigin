import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/utils/damage_calculate.dart';

///  基础能力值
class AbilityEntry extends BaseEntry<AbilityEntry> {
  int life = 0;
  int attack = 0;
  int defend = 0;
  int money = 0;
  int experience = 0;

  int yKey = 0;
  int bKey = 0;
  int rKey = 0;

  AbilityEntry setYKey(int yKey) {
    if (yKey == null) {
      return this;
    }
    this.yKey = yKey;
    return this;
  }

  AbilityEntry setBKey(int bKey) {
    if (bKey == null) {
      return this;
    }
    this.bKey = bKey;
    return this;
  }

  AbilityEntry setRKey(int rKey) {
    if (rKey == null) {
      return this;
    }
    this.rKey = rKey;
    return this;
  }

  AbilityEntry setLife(int life) {
    if (life == null) {
      return this;
    }
    this.life = life;
    return this;
  }

  AbilityEntry setExperience(int experience) {
    if (experience == null) {
      return this;
    }
    this.experience = experience;
    return this;
  }

  AbilityEntry setMoney(int money) {
    if (money == null) {
      return this;
    }
    this.money = money;
    return this;
  }

  AbilityEntry setAttack(int attack) {
    if (attack == null) {
      return this;
    }
    this.attack = attack;
    return this;
  }

  AbilityEntry setDefend(int defend) {
    if (defend == null) {
      return this;
    }
    this.defend = defend;
    return this;
  }

  AbilityEntry clone() {
    return AbilityEntry()
        .setAttack(attack)
        .setDefend(defend)
        .setYKey(yKey)
        .setBKey(bKey)
        .setRKey(rKey)
        .setMoney(money)
        .setExperience(experience)
        .setLife(life)
        .setPassable(passable)
        .setName(name);
  }

  bool compare(AbilityEntry other) {
    print("$rKey     ${other.rKey}");
    if (yKey < other.yKey ||
        bKey < other.bKey ||
        rKey < other.rKey ||
        !other.passable) {
      return false;
    }

    int attackStatus = 0;

    var damage;
    if (other.yKey > 0) {
      attackStatus = 1;
      yKey = yKey - other.yKey;
    } else if (other.bKey > 0) {
      attackStatus = 1;
      bKey = bKey - other.bKey;
    } else if (other.rKey > 0) {
      attackStatus = 1;
      rKey = rKey - other.rKey;
    } else {
      damage = DamageCalculate.calculate(this, other);
      attackStatus = (damage is String) ? 2 : 0;
      if (damage is String) {
        attackStatus = 2;
      } else if (damage is int && life > damage) {
        attackStatus = 1;
        life = life - damage.toInt();
        money += other.money;
        experience += other.experience;
      }
    }

    print("damage: $damage |   life: $life attack: $attack defend: $defend   "
        " || ${other.life}  ${other.attack}  ${other.defend}   $attackStatus");

    return attackStatus == 1;
  }

  merge(AbilityEntry other) {
    life += other.life;
    attack += other.attack;
    defend += other.defend;
    money += other.money;
    experience += other.experience;

    yKey += other.yKey;
    bKey += other.bKey;
    rKey += other.rKey;
  }
}
