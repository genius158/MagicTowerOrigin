import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:magic_tower_origin/config/colors.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/hero_character.dart';
import 'package:magic_tower_origin/role/weapon_role.dart';
import 'package:magic_tower_origin/utils/damage_calculate.dart';
import 'package:magic_tower_origin/widget/game_image_text.dart';
import 'package:magic_tower_origin/widget/image_text.dart';

class MonsterBookDialog extends StatelessWidget {
  HeroCharacter _hero;
  List<List<BaseCharacter>> _datas;

  MonsterBookDialog(this._hero, this._datas);

  @override
  Widget build(BuildContext context) {
    var listView = _getItems(_datas);
    listView.insert(
        0,
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: double.infinity,
          child: Text(
            "怪物图鉴",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ));
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: listView,
      ),
      color: ColorMgr.cr666666(),
    );
  }

  List<Widget> _getItems(List<List<BaseCharacter>> datas) {
    Set<Widget> set = SplayTreeSet();

    for (var rows in datas) {
      for (var item in rows) {
        if (item is AbilityCharacter && !(item is WeaponRole)) {
          if (item.abilityEntry.attack > 0 || item.abilityEntry.defend > 0) {
            set.add(_ListItem(_hero, item));
          }
        }
      }
    }

    List<Widget> dataItem = new List();
    dataItem.addAll(set);
    return dataItem;
  }
}

class _ListItem extends StatelessWidget with Comparable<_ListItem> {
  final AbilityCharacter abilityCharacter;
  final HeroCharacter hero;

  _ListItem(this.hero, this.abilityCharacter);

  @override
  Widget build(BuildContext context) {
    EdgeInsets pd = EdgeInsets.only(top: 4, bottom: 4, left: 4);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: ColorMgr.crB57147(), width: 0.5))),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4),
        ),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  GameImageText(
                    abilityCharacter.imageRender.imageNodes[0],
                    abilityCharacter.name,
                    padding: pd,
                  ),
                  ImageText(
                    null,
                    "",
                    padding: pd,
                  )
                ],
              ),
              width: 90,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ImageText(
                        "images/Item02-09_3_1.png",
                        "${abilityCharacter.abilityEntry.life}",
                        padding: pd,
                      ),
                      ImageText(
                        "images/blade1.png",
                        "${abilityCharacter.abilityEntry.attack}",
                        padding: pd,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ImageText(
                        "images/Item01-05_1_4.png",
//                  "images/Item02-09_3_1.png",
                        "${abilityCharacter.abilityEntry.money}",
                        padding: pd,
                      ),
                      ImageText(
                        "images/Item01-08_3_1.png",
//                  "images/blade1.png",
                        "${abilityCharacter.abilityEntry.defend}",
                        padding: pd,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ImageText(
                        "images/Item04-XXMT03_1_2.png",
//                  "images/Item02-09_3_1.png",
                        "${abilityCharacter.abilityEntry.experience}",
                        padding: pd,
                      ),
                      ImageText(
                        null,
                        DamageCalculate.calculate(hero.getAbilityWithWeapon(),
                                abilityCharacter.abilityEntry)
                            .toString(),
                        color: Colors.red,
                        padding: pd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(4),
        ),
      ],
    );
  }

  @override
  int get hashCode => abilityCharacter.type.hashCode;

  @override
  int compareTo(other) {
    return abilityCharacter.abilityEntry.attack +
        abilityCharacter.abilityEntry.defend +
        abilityCharacter.abilityEntry.life -
        (other.abilityCharacter.abilityEntry.attack +
            other.abilityCharacter.abilityEntry.defend +
            other.abilityCharacter.abilityEntry.life);
  }
}
