import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/ability/ability_magic_entry.dart';
import 'package:magic_tower_origin/ability/base_entry.dart';
import 'package:magic_tower_origin/ability/prop_entry.dart';
import 'package:magic_tower_origin/ability/prop_type.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/render/image_render.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/grow_weapon_role.dart';
import 'package:magic_tower_origin/role/hero_character.dart';
import 'package:magic_tower_origin/role/npc_character.dart';
import 'package:magic_tower_origin/role/prop_level.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';

/// map entities 地图元素管理
class ME {
  static getAllRoles() {
    return [
      hero,
      road1,
      wall1,
      lowLife,
      norLife,
      yKey,
      bKey,
      rKey,
      att,
      def,
      yDoor,
      bDoor,
      rDoor,
      blade1,
      blade2,
      blade3,
      blade4,
      shield1,
      shield2,
      shield3,
      shield4,
      pFloor,
      nFloor,
      propBook,
      propSymmetry,
      propFlyUp,
      propFlyDown,
      slime1,
      slime2,
      slime3,
      slime4,
      bat1,
      bat2,
      bat3,
      magic1,
      magic2,
      magic3,
      magic4,
      magic5,
      skeleton1,
      skeleton2,
      skeleton3,
      orca1,
      orca2,
      guard1,
      guard2,
      guard3,
      guard4,
      guard5,
      hades1,
      hades2,
      swords1,
      swords2,
      swords3,
      stoneMonster,
      shadowMonster,
      boss1,
      boss3,
      npc1,
      npc2,
    ];
  }

  static BaseCharacter getEntity(String type) {
    BaseCharacter character;
    if (type == hero) {
      character = getHero();
    } else if (type == wall1) {
      character = getWall1();
    } else if (type == road1) {
      character = getRoad1();
    } else if (type == lowLife) {
      character = getLowLife();
    } else if (type == norLife) {
      character = getNorLife();
    } else if (type == yKey) {
      character = getYKey();
    } else if (type == bKey) {
      character = getBKey();
    } else if (type == rKey) {
      character = getRKey();
    } else if (type == att) {
      character = getAtt();
    } else if (type == def) {
      character = getDef();
    } else if (type == yDoor) {
      character = getYDoor();
    } else if (type == bDoor) {
      character = getBDoor();
    } else if (type == rDoor) {
      character = getRDoor();
    } else if (type == blade1) {
      character = getBlade1();
    } else if (type == blade2) {
      character = getBlade2();
    } else if (type == blade3) {
      character = getBlade3();
    } else if (type == blade4) {
      character = getBlade4();
    } else if (type == shield1) {
      character = getShield1();
    } else if (type == shield2) {
      character = getShield2();
    } else if (type == shield3) {
      character = getShield3();
    } else if (type == shield4) {
      character = getShield4();
    }
    // 道具
    else if (type == pFloor) {
      character = getPFloor();
    } else if (type == nFloor) {
      character = getNFloor();
    } else if (type == propBook) {
      character = getProBook();
    } else if (type == propSymmetry) {
      character = getPropSymmetry();
    } else if (type == propFlyUp) {
      character = getPropFlyUp();
    } else if (type == propFlyDown) {
      character = getPropFlyDown();
    }
    // 怪物
    else if (type == slime1) {
      character = getSlime1();
    } else if (type == slime2) {
      character = getSlime2();
    } else if (type == slime3) {
      character = getSlime3();
    } else if (type == slime4) {
      character = getSlime4();
    } else if (type == bat1) {
      character = getBat1();
    } else if (type == bat2) {
      character = getBat2();
    } else if (type == bat3) {
      character = getBat3();
    } else if (type == magic1) {
      character = getMagic1();
    } else if (type == magic2) {
      character = getMagic2();
    } else if (type == magic3) {
      character = getMagic3();
    } else if (type == magic4) {
      character = getMagic4();
    } else if (type == magic5) {
      character = getMagic5();
    } else if (type == skeleton1) {
      character = getSkeleton1();
    } else if (type == skeleton2) {
      character = getSkeleton2();
    } else if (type == skeleton3) {
      character = getSkeleton3();
    } else if (type == orca1) {
      character = getOrca1();
    } else if (type == orca2) {
      character = getOrca2();
    } else if (type == guard1) {
      character = getGuard1();
    } else if (type == guard2) {
      character = getGuard2();
    } else if (type == guard3) {
      character = getGuard3();
    } else if (type == guard4) {
      character = getGuard4();
    } else if (type == guard5) {
      character = getGuard5();
    } else if (type == hades1) {
      character = getHades1();
    } else if (type == hades2) {
      character = getHades2();
    } else if (type == swords1) {
      character = getSwords1();
    } else if (type == swords2) {
      character = getSwords2();
    } else if (type == swords3) {
      character = getSwords3();
    } else if (type == stoneMonster) {
      character = getStoneMonster();
    } else if (type == shadowMonster) {
      character = getShadowMonster();
    } else if (type == boss1) {
      character = getBoss1();
    } else if (type == boss2) {
      character = getBoss2();
    } else if (type == boss3) {
      character = getBoss3();
    }

    /// ------------ npc ---------------
    else if (type == npc1) {
      character = getNPC1();
    } else if (type == npc2) {
      character = getNPC2();
    }
    return character;
  }

  static const String hero = "hero";

  static getHero() {
    return HeroCharacter(
            ImageRender([
              ImageNode("images/Actor01-Braver01.png", [4, 4], 0),
              ImageNode("images/Actor01-Braver01.png", [4, 4], 4),
              ImageNode("images/Actor01-Braver01.png", [4, 4], 12),
              ImageNode("images/Actor01-Braver01.png", [4, 4], 8),
            ]).setImageIndex(0),
            AbilityEntry().setLife(1000))
        .setAttackWeapon(getBlade1())
        .setDefendWeapon(getShield1())
        .setName("hero")
        .setType("hero");
  }

  static const String wall1 = "wall1";

  static getWall1() {
    return BaseCharacter(
            ImageRender([
              ImageNode("images/Event01-Wall01.png", [4, 4], 1)
            ]),
            BaseEntry().setPassable(false))
        .setName("wall1")
        .setType("wall1");
  }

  static const String road1 = "road1";

  static getRoad1() {
    return BaseCharacter(
            ImageRender([
              ImageNode("images/Other09.png", [4, 4], 0)
            ]),
            BaseEntry())
        .setName("road1")
        .setType("road1");
  }

  static const String yDoor = "yDoor";

  static getYDoor() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Event01-Door01.png", [4, 4], 0)
            ]),
            AbilityEntry().setYKey(1))
        .setName("yDoor")
        .setType("yDoor");
  }

  static const String bDoor = "bDoor";

  static getBDoor() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Event01-Door01.png", [4, 4], 1),
            ]),
            AbilityEntry().setBKey(1))
        .setName("bDoor")
        .setType("bDoor");
  }

  static const String rDoor = "rDoor";

  static getRDoor() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Event01-Door01.png", [4, 4], 2),
            ]),
            AbilityEntry().setRKey(1))
        .setName("rDoor")
        .setType("rDoor");
  }

  static const String yKey = "yKey";

  static getYKey() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-01.png", [4, 4], 0)
            ]),
            AbilityEntry().setYKey(1))
        .setName("黄钥匙")
        .setType("yKey");
  }

  static const String bKey = "bKey";

  static getBKey() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-01.png", [4, 4], 1)
            ]),
            AbilityEntry().setBKey(1))
        .setName("蓝钥匙")
        .setType("bKey");
  }

  static const String rKey = "rKey";

  static getRKey() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-01.png", [4, 4], 2)
            ]),
            AbilityEntry().setRKey(1))
        .setName("红钥匙")
        .setType("rKey");
  }

  static const String att = "att";

  static getAtt() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-Gem01.png", [4, 4], 0)
            ]),
            AbilityEntry().setAttack(3))
        .setName("att")
        .setType("att");
  }

  static const String def = "def";

  static getDef() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-Gem01.png", [4, 4], 1)
            ]),
            AbilityEntry().setDefend(3))
        .setName("def")
        .setType("def");
  }

  static const String blade1 = "blade1";

  static getBlade1() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 0)
            ]),
            AbilityEntry().setAttack(10))
        .setName("blade1")
        .setType("blade1");
  }

  static const String blade2 = "blade2";

  static getBlade2() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 1)
            ]),
            AbilityEntry().setAttack(30))
        .setName("blade2")
        .setType("blade2");
  }

  static const String blade3 = "blade3";

  static getBlade3() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 2)
            ]),
            AbilityEntry().setAttack(60))
        .setName("blade3")
        .setType("blade3");
  }

  static const String blade4 = "blade4";

  static getBlade4() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 3)
            ]),
            AbilityEntry().setAttack(100))
        .setName("blade4")
        .setType("blade4");
  }

  static const String shield1 = "shield1";

  static getShield1() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 8)
            ]),
            AbilityEntry().setDefend(10))
        .setName("shield1")
        .setType("shield1");
  }

  static const String shield2 = "shield2";

  static getShield2() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 9)
            ]),
            AbilityEntry().setDefend(30))
        .setName("shield2")
        .setType("shield2");
  }

  static const String shield3 = "shield3";

  static getShield3() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 10)
            ]),
            AbilityEntry().setDefend(60))
        .setName("shield3")
        .setType("shield3");
  }

  static const String shield4 = "shield4";

  static getShield4() {
    return WeaponRole(
            ImageRender([
              ImageNode("images/Item01-08.png", [4, 4], 11)
            ]),
            AbilityEntry().setDefend(100))
        .setName("shield4")
        .setType("shield4");
  }

  ///////////////////////道具//////////////////////////
  static const String pFloor = "pFloor";

  static getPFloor() {
    return PropLevel(
            -1,
            ImageRender([
              ImageNode("images/floor.png", [2, 1], 0)
            ]),
            PropEntry().setTimes(-1))
        .setName("pFloor")
        .setType("pFloor");
  }

  static const String nFloor = "nFloor";

  static getNFloor() {
    return PropLevel(
            1,
            ImageRender([
              ImageNode("images/floor.png", [2, 1], 1)
            ]),
            PropEntry().setTimes(-1))
        .setName("nFloor")
        .setType("nFloor");
  }

  static const String propBook = "propBook";

  static getProBook() {
    return PropRole(
            ImageRender([
              ImageNode("images/Item01-05_1_1.png", [1, 1], 0)
            ]),
            PropEntry().setPropType(PropType.ABILITY_BOOK))
        .setName("怪物图鉴")
        .setType("propBook");
  }

  static const String propSymmetry = "propSymmetry";

  static getPropSymmetry() {
    return PropRole(
            ImageRender([
              ImageNode("images/Item01-06_2_1.png", [1, 1], 0)
            ]),
            PropEntry().setPropType(PropType.ABILITY_SYMMETRY).setTimes(1))
        .setName("对称")
        .setType("propSymmetry");
  }

  static const String propFlyUp = "propFlyUp";

  static getPropFlyUp() {
    return PropRole(
            ImageRender([
              ImageNode("images/Item01-06_2_3.png", [1, 1], 0)
            ]),
            PropEntry().setPropType(PropType.ABILITY_FLY_UP).setTimes(1))
        .setName("上一层")
        .setType("propFlyUp");
  }

  static const String propFlyDown = "propFlyDown";

  static getPropFlyDown() {
    return PropRole(
            ImageRender([
              ImageNode("images/Item01-06_2_2.png", [1, 1], 0)
            ]),
            PropEntry().setPropType(PropType.ABILITY_FLY_DOWN).setTimes(1))
        .setName("下一层")
        .setType("propFlyDown");
  }

  //////////////////////// END 道具 ////////////////////////
  static const String lowLife = "lowLife";

  static getLowLife() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-02.png", [4, 4], 0)
            ]),
            AbilityEntry().setLife(100))
        .setName("lowLife")
        .setType("lowLife");
  }

  static const String norLife = "norLife";

  static getNorLife() {
    return GrowWeaponRole(
            ImageRender([
              ImageNode("images/Item01-02.png", [4, 4], 4)
            ]),
            AbilityEntry().setLife(250))
        .setName("norLife")
        .setType("norLife");
  }

  static const String slime1 = "slime1";

  static getSlime1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Actor02-Monster01.png", [4, 4], 0),
              ImageNode("images/Actor02-Monster01.png", [4, 4], 1),
              ImageNode("images/Actor02-Monster01.png", [4, 4], 2),
              ImageNode("images/Actor02-Monster01.png", [4, 4], 3),
            ]),
            AbilityEntry()
                .setLife(50)
                .setMoney(1)
                .setAttack(20)
                .setDefend(1)
                .setExperience(1))
        .setName("绿头怪")
        .setType("slime1");
  }

  static const String slime2 = "slime2";

  static getSlime2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster01-01_2_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(70)
                .setMoney(2)
                .setAttack(15)
                .setDefend(2)
                .setExperience(2))
        .setName("红头怪")
        .setType("slime2");
  }

  static const String slime3 = "slime3";

  static getSlime3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Actor02-Monster02.png", [4, 4], 0),
              ImageNode("images/Actor02-Monster02.png", [4, 4], 1),
              ImageNode("images/Actor02-Monster02.png", [4, 4], 2),
              ImageNode("images/Actor02-Monster02.png", [4, 4], 3),
            ]),
            AbilityEntry()
                .setLife(200)
                .setMoney(5)
                .setAttack(35)
                .setDefend(10)
                .setExperience(5))
        .setName("青头怪")
        .setType("slime3");
  }

  static const String slime4 = "slime4";

  static getSlime4() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster01-04_4_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(700)
                .setMoney(32)
                .setAttack(250)
                .setDefend(125)
                .setExperience(30))
        .setName("怪王")
        .setType("slime4");
  }

  static const String bat1 = "bat1";

  static getBat1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster03-01.png", [4, 4], 0),
              ImageNode("images/Monster03-01.png", [4, 4], 1),
              ImageNode("images/Monster03-01.png", [4, 4], 2),
              ImageNode("images/Monster03-01.png", [4, 4], 3),
            ]),
            AbilityEntry()
                .setLife(100)
                .setMoney(3)
                .setAttack(20)
                .setDefend(5)
                .setExperience(3))
        .setName("小蝙蝠")
        .setType("bat1");
  }

  static const String bat2 = "bat2";

  static getBat2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster03-01.png", [4, 4], 4),
              ImageNode("images/Monster03-01.png", [4, 4], 5),
              ImageNode("images/Monster03-01.png", [4, 4], 6),
              ImageNode("images/Monster03-01.png", [4, 4], 7),
            ]),
            AbilityEntry()
                .setLife(150)
                .setMoney(10)
                .setAttack(65)
                .setDefend(30)
                .setExperience(8))
        .setName("大蝙蝠")
        .setType("bat2");
  }

  static const String bat3 = "bat3";

  static getBat3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster03-01.png", [4, 4], 8),
              ImageNode("images/Monster03-01.png", [4, 4], 9),
              ImageNode("images/Monster03-01.png", [4, 4], 10),
              ImageNode("images/Monster03-01.png", [4, 4], 11),
            ]),
            AbilityEntry()
                .setLife(550)
                .setMoney(25)
                .setAttack(160)
                .setDefend(90)
                .setExperience(20))
        .setName("红蝙蝠")
        .setType("bat3");
  }

  static const String skeleton1 = "skeleton1";

  static getSkeleton1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster02-01_1_1.png", [1, 1], 0),
            ]),
            AbilityEntry()
                .setLife(110)
                .setMoney(5)
                .setAttack(25)
                .setDefend(5)
                .setExperience(4))
        .setName("骷髅人")
        .setType("skeleton1");
  }

  static const String skeleton2 = "skeleton2";

  static getSkeleton2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster02-01_2_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(150)
                .setMoney(8)
                .setAttack(40)
                .setDefend(20)
                .setExperience(6))
        .setName("骷髅士兵")
        .setType("skeleton2");
  }

  static const String skeleton3 = "skeleton3";

  static getSkeleton3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster02-01_3_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(400)
                .setMoney(15)
                .setAttack(90)
                .setDefend(50)
                .setExperience(12))
        .setName("骷髅队长")
        .setType("skeleton3");
  }

  static const String orca1 = "orca1";

  static getOrca1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster09-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(400)
                .setMoney(15)
                .setAttack(90)
                .setDefend(50)
                .setExperience(12))
        .setName("兽面人")
        .setType("orca1");
  }

  static const String orca2 = "orca2";

  static getOrca2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster09-01_2_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(900)
                .setMoney(50)
                .setAttack(450)
                .setDefend(330)
                .setExperience(50))
        .setName("兽面武士")
        .setType("orca2");
  }

  static const String magic1 = "magic1";

  static getMagic1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster06-01.png", [4, 4], 0),
              ImageNode("images/Monster06-01.png", [4, 4], 1),
              ImageNode("images/Monster06-01.png", [4, 4], 2),
              ImageNode("images/Monster06-01.png", [4, 4], 3),
            ]),
            AbilityMagicEntry()
                .setLife(125)
                .setAttack(50)
                .setDefend(25)
                .setMoney(10)
                .setExperience(7))
        .setName("初级法师")
        .setType("magic1");
  }

  static const String magic2 = "magic2";

  static getMagic2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster06-01.png", [4, 4], 4),
              ImageNode("images/Monster06-01.png", [4, 4], 5),
              ImageNode("images/Monster06-01.png", [4, 4], 6),
              ImageNode("images/Monster06-01.png", [4, 4], 7),
            ]),
            AbilityMagicEntry()
                .setLife(100)
                .setAttack(200)
                .setDefend(110)
                .setMoney(30)
                .setExperience(25))
        .setName("高级法师")
        .setType("magic2");
  }

  static const String magic3 = "magic3";

  static getMagic3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster06-01.png", [4, 4], 8),
              ImageNode("images/Monster06-01.png", [4, 4], 9),
              ImageNode("images/Monster06-01.png", [4, 4], 10),
              ImageNode("images/Monster06-01.png", [4, 4], 11),
            ]),
            AbilityMagicEntry()
                .setLife(250)
                .setAttack(120)
                .setDefend(70)
                .setMoney(20)
                .setExperience(17))
        .setName("麻衣法师")
        .setType("magic3");
  }

  static const String magic4 = "magic4";

  static getMagic4() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster06-01.png", [4, 4], 12),
              ImageNode("images/Monster06-01.png", [4, 4], 13),
              ImageNode("images/Monster06-01.png", [4, 4], 14),
              ImageNode("images/Monster06-01.png", [4, 4], 15),
            ]),
            AbilityMagicEntry()
                .setLife(500)
                .setAttack(400)
                .setDefend(260)
                .setMoney(47)
                .setExperience(45))
        .setName("红衣法师")
        .setType("magic4");
  }

  static const String magic5 = "magic5";

  static getMagic5() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster06-02_1_1.png", [1, 1], 0)
            ]),
            AbilityMagicEntry()
                .setLife(3000)
                .setAttack(2212)
                .setDefend(1946)
                .setMoney(132)
                .setExperience(116))
        .setName("灵法师")
        .setType("magic5");
  }

  static const String guard1 = "guard1";

  static getGuard1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster05-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(450)
                .setAttack(150)
                .setDefend(90)
                .setMoney(22)
                .setExperience(19))
        .setName("初级卫兵")
        .setType("guard1");
  }

  static const String guard2 = "guard2";

  static getGuard2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster05-01_3_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(1500)
                .setAttack(560)
                .setDefend(460)
                .setMoney(60)
                .setExperience(60))
        .setName("高级卫兵")
        .setType("guard2");
  }

  static const String guard3 = "guard3";

  static getGuard3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster05-01_2_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(1250)
                .setAttack(500)
                .setDefend(460)
                .setMoney(55)
                .setExperience(55))
        .setName("冥卫兵")
        .setType("guard3");
  }

  static const String guard4 = "guard4";

  static getGuard4() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster08-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(1300)
                .setAttack(300)
                .setDefend(150)
                .setMoney(40)
                .setExperience(35))
        .setName("白衣武士")
        .setType("guard4");
  }

  static const String guard5 = "guard5";

  static getGuard5() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster07-08_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(2400)
                .setAttack(2612)
                .setDefend(2400)
                .setMoney(146)
                .setExperience(125))
        .setName("灵武士")
        .setType("guard5");
  }

  static const String hades1 = "hades1";

  static getHades1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster07-04_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(2000)
                .setAttack(680)
                .setDefend(590)
                .setMoney(70)
                .setExperience(65))
        .setName("冥战士")
        .setType("hades1");
  }

  static const String hades2 = "hades2";

  static getHades2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster02-01_4_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(3333)
                .setAttack(1200)
                .setDefend(1133)
                .setMoney(112)
                .setExperience(100))
        .setName("冥队长")
        .setType("hades2");
  }

  static const String swords1 = "swords1";

  static getSwords1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster07-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(850)
                .setAttack(350)
                .setDefend(200)
                .setMoney(45)
                .setExperience(40))
        .setName("金卫士")
        .setType("swords1");
  }

  static const String swords2 = "swords2";

  static getSwords2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster07-01_2_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(900)
                .setAttack(750)
                .setDefend(650)
                .setMoney(77)
                .setExperience(70))
        .setName("金队长")
        .setType("swords2");
  }

  static const String swords3 = "swords3";

  static getSwords3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster04-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(1200)
                .setAttack(620)
                .setDefend(520)
                .setMoney(65)
                .setExperience(75))
        .setName("双手剑士")
        .setType("swords3");
  }

  static const String stoneMonster = "stoneMonster";

  static getStoneMonster() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/stone_monster.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(500)
                .setAttack(115)
                .setDefend(65)
                .setMoney(15)
                .setExperience(15))
        .setName("石头怪")
        .setType("stoneMonster");
  }

  static const String shadowMonster = "shadowMonster";

  static getShadowMonster() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Monster11-01_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(3100)
                .setAttack(1150)
                .setDefend(1050)
                .setMoney(92)
                .setExperience(80))
        .setName("影子战士")
        .setType("shadowMonster");
  }

  static const String boss1 = "boss1";

  static getBoss1() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Actor02-Monster06_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(15000)
                .setAttack(1000)
                .setDefend(1000)
                .setMoney(100)
                .setExperience(100))
        .setName("魔王分身")
        .setType("boss1");
  }

  static const String boss2 = "boss2";

  static getBoss2() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Actor02-Monster06_1_1.png", [1, 1], 0)
            ]),
            AbilityEntry()
                .setLife(20000)
                .setAttack(1333)
                .setDefend(1333)
                .setMoney(133)
                .setExperience(133))
        .setName("红衣魔王")
        .setType("boss2");
  }

  static const String boss3 = "boss3";

  static getBoss3() {
    return AbilityCharacter(
            ImageRender([
              ImageNode("images/Actor02-Monster14.png", [4, 4], 0),
              ImageNode("images/Actor02-Monster14.png", [4, 4], 1),
              ImageNode("images/Actor02-Monster14.png", [4, 4], 2),
              ImageNode("images/Actor02-Monster14.png", [4, 4], 3),
            ]),
            AbilityEntry()
                .setLife(60000)
                .setAttack(3400)
                .setDefend(3000)
                .setMoney(390)
                .setExperience(343))
        .setName("冥灵魔王")
        .setType("boss3");
  }

  static const String npc1 = "npc1";

  static getNPC1() {
    return NPC(
            ImageRender([
              ImageNode("images/NPC01-01.png", [4, 4], 0),
              ImageNode("images/NPC01-01.png", [4, 4], 1),
              ImageNode("images/NPC01-01.png", [4, 4], 2),
              ImageNode("images/NPC01-01.png", [4, 4], 3),
            ]),
            BaseEntry().setPassable(false))
        .setName("npc1")
        .setType("npc1");
  }

  static const String npc2 = "npc2";

  static getNPC2() {
    return NPC(
            ImageRender([
              ImageNode("images/NPC01-01.png", [4, 4], 4),
              ImageNode("images/NPC01-01.png", [4, 4], 5),
              ImageNode("images/NPC01-01.png", [4, 4], 6),
              ImageNode("images/NPC01-01.png", [4, 4], 7),
            ]),
            BaseEntry().setPassable(false))
        .setTriggerThanDismiss()
        .setName("npc2")
        .setType("npc2");
  }
}
