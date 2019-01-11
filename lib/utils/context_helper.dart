import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ContextHelper {
  static withCxt(BuildContext context, ValueChanged<BuildContext> vc) {
    try {
      context.size;
      vc(context);
      print("ContextHelper   dicect    ---------------------------");
    } catch (e) {
      StreamSubscription ss;
      ss = Observable.periodic(Duration(milliseconds: 200)).map((_) {
        try {
          context.size;
          return true;
        } catch (e) {
          return false;
        }
      }).takeWhile((able) {
        if (able) {}
        return able;
      }).listen((_) {
        vc(context);
        print("ContextHelper   periodic   --------------------------");
        ss.cancel();
      });
    }
  }
}
