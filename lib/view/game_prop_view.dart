import 'package:flutter/material.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/datacenter/hero_observable.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/prop_role.dart';
import 'package:magic_tower_origin/widget/game_image_text.dart';

class GamePropInfoView extends StatelessWidget {
  HeroProviderObservable _heroInfo;

  @override
  Widget build(BuildContext context) {
    print("GamePropInfoViewGamePropInfoView render");
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
    List<List<PropRole>> pross = _getProps(character?.getProps());
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "固有道具:",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Row(
                children: pross[0].map((data) {
                  return _ImageAndData(data);
                }).toList(),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "消耗道具:",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Row(
                  children: pross[1].map((data) {
                    return _ImageAndData(data);
                  }).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<List<PropRole>> _getProps(List<PropRole> props) {
    List<List<PropRole>> prss = [List(), List()];
    if (props == null) {
      return prss;
    }

    for (PropRole pr in props) {
      if (pr.abilityEntry.times == -1) {
        prss[0].add(pr);
      } else {
        prss[1].add(pr);
      }
    }
    return prss;
  }
}

class _ImageAndData extends StatelessWidget implements Comparable<_ImageAndData> {
  PropRole _propRole;
  ValueChanged<PropRole> onTap;
  EdgeInsets padding;

  _ImageAndData(this._propRole, {this.onTap, this.padding});

  @override
  int compareTo(other) {
    return _propRole.abilityEntry.propType -
        other._propRole.abilityEntry.propType;
  }

  @override
  Widget build(BuildContext context) {
    var imgNodes = _propRole?.imageRender?.imageNodes;
    var imgNode;
    if (imgNodes != null) {
      imgNode = imgNodes[0];
    }

    return InkWell(
      child: Stack(
        children: <Widget>[
          GameImageText(
            imgNode,
            "",
            width: 24,
            height: 24,
            fontSize: 8,
            padding: EdgeInsets.only(left: 3, right: 3),
          ),
          Text(
            " ${_propRole.abilityEntry.times >= 0 ? _propRole.abilityEntry.times : ""}",
            style: TextStyle(color: Colors.white, fontSize: 8),
          )
        ],
      ),
      onTap: () {
        GameProvider.ofGame(context).update(_propRole);
      },
    );
  }
}
