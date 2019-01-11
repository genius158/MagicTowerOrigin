import 'package:flutter/material.dart';
import 'package:magic_tower_origin/ability/ability_entry.dart';
import 'package:magic_tower_origin/config/colors.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/datacenter/hero_observable.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/name_role.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';
import 'package:magic_tower_origin/widget/game_image_text.dart';
import 'package:magic_tower_origin/widget/image_text.dart';

class GameHeroInfoView extends StatelessWidget {
  HeroProviderObservable _heroInfo;

  @override
  Widget build(BuildContext context) {
    print("GameHeroInfoViewGameHeroInfoViewGameHeroInfoView  build");
    //AppModel appModel = AppModel();
    _heroInfo = GameProvider.ofHero(context);
    return StreamBuilder<AbilityCharacter>(
      builder: _getBuilder,
      stream: _heroInfo.value,
      initialData: null,
    );
  }

  Widget _getBuilder(
      BuildContext context, AsyncSnapshot<AbilityCharacter> snapshot) {
    AbilityCharacter character = snapshot.data;

    AbilityEntry abilityEntry =
        character == null ? null : character.getAbilityWithWeapon();
    var weapons = _getWeapons(character != null ? character.getWeapons() : null);

    var padding = EdgeInsets.only(top: 4, bottom: 4);
    var floor = ImageText(
      null,
      "第${MapInfo.curLevel != null ? MapInfo.curLevel: ""}层",
      padding: EdgeInsets.only(left: 10),
    );

    var heroIcon = ImageText(
      "images/Actor01-Braver01_1_1.png",
      "",
      width: 25,
      height: 25,
      padding: EdgeInsets.only(left: 10),
    );

    var weaponContainer = _getWeaponContainer(character);

    var myk = Column(
      children: <Widget>[
        ImageText("images/Item01-05_1_4.png",
            "${abilityEntry != null ? abilityEntry.money : 0}",
            padding: padding),
        ImageText("images/Item01-01_1_1.png",
            "${abilityEntry != null ? abilityEntry.yKey : 0}",
            padding: padding)
      ],
    );
    var lbk = Column(
      children: <Widget>[
        ImageText("images/Item02-09_3_1.png",
            "${abilityEntry != null ? abilityEntry.life : 0}",
            padding: padding),
        ImageText("images/Item01-01_1_2.png",
            "${abilityEntry != null ? abilityEntry.bKey : 0}",
            padding: padding)
      ],
    );
    var ark = Column(
      children: <Widget>[
        ImageText("images/blade1.png",
            "${abilityEntry != null ? abilityEntry.attack : 0}",
            padding: padding),
        ImageText("images/Item01-01_1_3.png",
            "${abilityEntry != null ? abilityEntry.rKey : 0}",
            padding: padding)
      ],
    );

    var itEmpty = ImageText(
      null,
      "",
      padding: padding,
    );

    var bd = Column(
      children: <Widget>[
        ImageText("images/Item01-08_3_1.png",
            "${abilityEntry != null ? abilityEntry.defend : 0}",
            padding: padding),
        itEmpty
      ],
    );
    var ed = Column(
      children: <Widget>[
        ImageText("images/Item04-XXMT03_1_2.png",
            "${abilityEntry != null ? abilityEntry.experience : 0}",
            padding: padding),
        itEmpty
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: ColorMgr.cr666666(),
        border: Border.all(color: ColorMgr.crB57147(), width: 4),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[heroIcon, floor],
              ),
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          myk,
                          lbk,
                          ark,
                          bd,
                          ed,
                        ],
                      ))),
            ],
          ),
          Container(
            width: double.infinity,
            height: 4,
            color: ColorMgr.crB57147(),
          ),
          Row(
            children: <Widget>[
              ImageText(
                null,
                "装配: ",
                padding: EdgeInsets.only(left: 10),
              ),
              weaponContainer,
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        left:
                            BorderSide(color: ColorMgr.crB57147(), width: 4))),
                height: 30,
                child: weapons,
              ),
            ],
          )
        ],
      ),
    );
  }

  _getWeapons(List<Name> list) {
    var empty = GameImageText(
      null,
      "",
      padding: EdgeInsets.only(left: 5, right: 5),
    );
    if (list == null) {
      return empty;
    }

    var callBack = (weaponRole) {
      if (_heroInfo == null) {
        return;
      }
      AbilityCharacter ac = _heroInfo.abilityCharacter;
      if (weaponRole.abilityEntry.attack > 0) {
        ac.setAttackWeapon(weaponRole);
      } else if (weaponRole.abilityEntry.defend > 0) {
        ac.setDefendWeapon(weaponRole);
      }
      _heroInfo.setHeroInfo(ac);
      _heroInfo.update(ac);
    };

    var children = list.map((ac) {
      if (ac is WeaponRole) {
        return new _ImageAndData(
          ac,
          onTap: callBack,
        );
      }
      return empty;
    }).toList();
    children.sort();
    children = children.reversed.toList();
    return new Row(
      children: children,
    );
  }

  _getWeaponContainer(AbilityCharacter character) {
    var empty = _ImageAndData(
      null,
      padding: EdgeInsets.all(4),
    );
    var attackWeapon = empty;
    var defendWeapon = empty;

    if (character != null) {
      if (character.attackWeapon is WeaponRole) {
        attackWeapon = _ImageAndData(
          character.attackWeapon,
        );
      }
      if (character.defendWeapon is WeaponRole) {
        defendWeapon = _ImageAndData(
          character.defendWeapon,
        );
      }
    }

    return Container(
      width: 54,
      child: Row(
        children: <Widget>[attackWeapon, defendWeapon],
      ),
    );
  }
}

class _ImageAndData extends StatelessWidget with Comparable<_ImageAndData> {
  WeaponRole _weaponRole;
  ValueChanged<WeaponRole> onTap;
  EdgeInsets padding;

  _ImageAndData(this._weaponRole, {this.onTap, this.padding});


  @override
  int compareTo(other) {
    if (_weaponRole == null || other._weaponRole == null) {
      return 0;
    }
    if (_weaponRole.abilityEntry.attack > 0 &&
        other._weaponRole.abilityEntry.attack > 0) {
      return other._weaponRole.abilityEntry.attack -
          _weaponRole.abilityEntry.attack;
    }

    if (_weaponRole.abilityEntry.defend > 0 &&
        other._weaponRole.abilityEntry.defend > 0) {
      return other._weaponRole.abilityEntry.defend -
          _weaponRole.abilityEntry.defend;
    }
    if (_weaponRole.abilityEntry.defend == 0 &&
        other._weaponRole.abilityEntry.defend > 0) {
      return 1;
    }
    if (_weaponRole.abilityEntry.attack > 0 &&
        other._weaponRole.abilityEntry.attack == 0) {
      return -1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    var imgNodes = _weaponRole?.imageRender?.imageNodes;
    var imgNode;
    if (imgNodes != null) {
      imgNode = imgNodes[0];
    }

    return InkWell(
      child: GameImageText(
        imgNode,
        "",
        width: 18,
        height: 18,
        padding: EdgeInsets.only(left: 3, right: 3),
      ),
      onTap: () {
        if (onTap != null) {
         onTap(_weaponRole);
        }
      },
    );
  }
}
