import 'dart:collection';
import 'dart:ui';
import 'dart:ui' as UI show Image;

import 'package:flutter/services.dart';
import 'package:magic_tower_origin/map/map_info.dart';
import 'package:magic_tower_origin/render/image_node.dart';
import 'package:magic_tower_origin/role/ability_character.dart';
import 'package:magic_tower_origin/role/base_character.dart';
import 'package:magic_tower_origin/role/name_role.dart';
import 'package:magic_tower_origin/role/npc_character.dart';
import 'package:rxdart/rxdart.dart';

 /// 角色管理基类
abstract class BaseManager<T extends BaseCharacter, R extends Name> {
  List<List<T>> characters;

  loadImages(List<BaseCharacter> cs) {
    HashMap<String, UI.Image> imgCache = HashMap();
    return Observable.fromIterable(positionReset(cs))
        .flatMap((character) =>
            Observable.fromFuture(getImage(character, imgCache: imgCache)))
        .toList()
        .asObservable()
        .map((characters) {
      listReady();
      characters.remove(null);
      var finalCbs = characters.map((character) {
        onLoad(character);
        return character;
      }).toList();
      imgCache.clear();
      return finalCbs;
    });
  }

  static Future<BaseCharacter> getImage(BaseCharacter character,
      {Map<String, UI.Image> imgCache}) async {
    if (character == null) {
      return null;
    }
//    print("getImagegetImageget  ${character.imageRender.imageNodes}");

    for (ImageNode node in character.imageRender.imageNodes) {
      if (node.image == null) {
        UI.Image tempImage;
        if (imgCache != null) {
          tempImage = imgCache[node.imgPath];
        }
        if (tempImage != null) {
          node.image = tempImage;
        } else {
          node.image = await _getImg(node.imgPath);
          if (imgCache != null) {
            imgCache.putIfAbsent(node.imgPath, () => node.image);
          }
        }
      }
    }

    if (character is AbilityCharacter && character.equipment != null) {
      for (var weapon in character.equipment) {
        await getImage(weapon);
      }
    }

    if (character is NPC) {
      if (character.abilityGrantRole != null) {
        await getImage(character.abilityGrantRole,imgCache: imgCache);
      }
    }

    return character;
  }

  static Future<UI.Image> _getImg(String imgPath) async {
    ByteData data = await rootBundle.load(imgPath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  onLoad(BaseCharacter character) {
    if (character != null) {
      int px = character.imageRender.position[0];
      int py = character.imageRender.position[1];
      if (px < MapInfo.sx && py < MapInfo.sy) {
        characters[px][py] = character;
      }
    }
    return character;
  }

  T getCharacter(int px, int py) {
    if (characters == null) {
      return null;
    }
    return characters[px][py];
  }

  void listReady() {
    if (characters != null && characters.length == MapInfo.sy) {
      return;
    }
    if (characters == null) {
      characters = new List();
      for (var i = 0; i < MapInfo.sx; i++) {
        characters.add(new List());
        for (var j = 0; j < MapInfo.sy; j++) {
          characters[i].add(null);
        }
      }
    }
  }

  T remove(int px, int py) {
    T character = characters[px][py];
    characters[px][py] = null;
    return character;
  }

  void dispose() {
    if (characters != null) {
      characters.clear();
      characters = null;
    }
  }

  /// 位置重设
  List<BaseCharacter> positionReset(List<BaseCharacter> cs) {
    List<BaseCharacter> fcs = new List();
    int index = 0;
    for (var character in cs) {
      if (character != null) {
        if (character.imageRender.position[0] == null ||
            character.imageRender.position[1] == null) {
          character.imageRender.position[0] = index % (MapInfo.sx);
          character.imageRender.position[1] = (index / MapInfo.sx).floor();
        }
        fcs.add(character);
      }
      index++;
    }
    return fcs;
  }
}
