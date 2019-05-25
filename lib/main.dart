import 'dart:async';
import 'dart:collection';

import 'dart:ui' as ui show window, PointerDataPacket;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:magic_tower_origin/config/colors.dart';
import 'package:magic_tower_origin/datacenter/game_notify_flag.dart';
import 'package:magic_tower_origin/datacenter/game_provider.dart';
import 'package:magic_tower_origin/locale/translations_delegate.dart';
import 'package:magic_tower_origin/utils/router_heper.dart';
import 'package:magic_tower_origin/utils/view_adapter_config.dart';
import 'package:magic_tower_origin/view/diy_level_page.dart';
import 'package:magic_tower_origin/view/game_hero_info_view.dart';
import 'package:magic_tower_origin/view/game_prop_view.dart';
import 'package:magic_tower_origin/view/game_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:io';

void main() {
  // 设置竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runRatioApp(GameProvider(child: MyApp()));
  });
}

void runRatioApp(Widget app) {
  InnerWidgetsFlutterBinding.ensureInitialized()
    ..attachRootWidget(app)
    ..scheduleWarmUpFrame();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh'),
        Locale('en'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(Translations.of(context).text("app_title")),
        actions: _getActions(context),
      ),
      body: Column(
        children: <Widget>[
          GameHeroInfoView(),
          _getGameView(context),
          Expanded(
              child: Container(
            child: GamePropInfoView(),
            color: ColorMgr.cr666666(),
          )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    if (Platform.isAndroid) {
      await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    } else if (Platform.isIOS) {
      await SimplePermissions.requestPermission(Permission.PhotoLibrary);
      await SimplePermissions.requestPermission(Permission.AlwaysLocation);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    print("s  deactivate() ----------------------------------------");
  }

  @override
  void dispose() {
    super.dispose();
    print("s  dispose() ----------------------------------------");
  }

  _getGameView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorMgr.cr666666(),
          border: Border(
            bottom: BorderSide(color: ColorMgr.crB57147(), width: 4),
            right: BorderSide(color: ColorMgr.crB57147(), width: 4),
            left: BorderSide(color: ColorMgr.crB57147(), width: 4),
          )),
      child: new GameView(),
    );
  }

  _getActions(BuildContext context) {
    return [
      InkResponse(
          child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Image.asset(
                "images/icon_diy_level.png",
                width: 25,
                height: 25,
              )),
          onTap: () {
            RouterHelper.routePage(context, DiyLevelPage());
          }),
      InkResponse(
          child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Image.asset(
                "images/icon_load_diy.png",
                width: 25,
                height: 25,
              )),
          onTap: () {
            GameProvider.ofGame(context).update(GameNotifyFlag.gameLoadDiy);
          }),
      InkResponse(
          child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Image.asset(
                "images/icon_inner_game.png",
                width: 25,
                height: 25,
              )),
          onTap: () {
            GameProvider.ofGame(context).update(GameNotifyFlag.gameMain);
          }),
    ];
  }
}

///
/// 屏幕适配重写部分
/// 重写至 widgets/binding.dart
///
class InnerWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) InnerWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: getScreenAdapterSize(),
      devicePixelRatio: getAdapterRatio(),
    );
  }

  ///
  /// 以下一大重写与 GestureBinding
  /// 唯一目的 把 _handlePointerDataPacket 方法 事件原始数据转换 改用
  /// 修改过的 PixelRatio

  @override
  void initInstances() {
    super.initInstances();
    ui.window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(ui.PointerDataPacket packet) {
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用我们修改的
        getAdapterRatio()));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked)
      scheduleMicrotask(_flushPointerEventQueue);
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty)
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer);
    } else if (event.down) {
      result = _hitTests[event.pointer];
    } else {
      return;
    }
    if (result != null) dispatchEvent(event, result);
  }
}
