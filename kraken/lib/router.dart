/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kraken/page.dart';

typedef PageCreator = Widget Function(BuildContext context, String schemaOrUrl);

class KrakenPageRouter {
  static PageCreator _pageCreator;
  // 给外部的钩子 用来创建自定义Page
  static void setPageCreator(PageCreator creator) {
    _pageCreator = creator;
  }

  static Widget buildPage(BuildContext context, String schemaOrUrl) {
    if (_pageCreator != null) {
      return _pageCreator(context, schemaOrUrl);
    }
    return KrakenPage(schema: schemaOrUrl);
  }

  static void openUrl(BuildContext context, String schemaOrUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => buildPage(context, schemaOrUrl)),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
