import 'package:flutter/material.dart';
import 'package:magic_tower_origin/utils/context_helper.dart';
import 'package:magic_tower_origin/widget/my_dialog.dart';

class RouterHelper {
  static routeDialog(BuildContext context,
      {Widget layout,
      String title,
      String message,
      String negativeText,
      VoidCallback onNegative,
      String positiveText,
      bool barrierDismissible,
      VoidCallback onPositive}) {
    barrierDismissible = barrierDismissible ?? true;
    ContextHelper.withCxt(context, (_) {
      if (layout != null) {
        showDialog<Null>(
            barrierDismissible: barrierDismissible,
            context: context,
            builder: (BuildContext context) {
              return new MyAlertDialog(
                contentPadding: EdgeInsets.all(0),
                content: layout,
              );
            });
        return;
      }
      showDialog<Null>(
          barrierDismissible: barrierDismissible,
          context: context,
          builder: (BuildContext context) {
            return new MyAlertDialog(
              contentPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              title: Container(
                padding:
                    EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Theme.of(context).primaryColor,
              ),
              content: Container(
                padding:
                    EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkResponse(
                    child: Text(negativeText ?? "取消"),
                    onTap: () {
                      Navigator.pop(context);
                      if (onNegative != null) {
                        onNegative();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkResponse(
                    child: Text(positiveText ?? "确定"),
                    onTap: () {
                      Navigator.pop(context);
                      if (onPositive != null) {
                        onPositive();
                      }
                    },
                  ),
                ),
              ],
            );
          });
    });
  }

  static routePage(BuildContext context, Widget layout) {
    Navigator.of(context).push(new PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 250),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return layout;
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          // 淡入
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: child, // child is the value returned by pageBuilder
          );
        }));
  }
}
