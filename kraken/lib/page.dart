/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kraken/kraken.dart';

class KrakenPage extends StatefulWidget {
  final String schema;
  KrakenPage({Key key, this.schema = ''}) : super(key: key);

  @override
  _KrakenPageState createState() => _KrakenPageState(schema: schema);
}

class _KrakenPageState extends State<KrakenPage> {
  final String schema;
  _KrakenPageState({this.schema = ''}) : super();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    // This dialog will exit your app on saying yes
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Uri u = Uri.parse(schema);
    String bundleURL = '';
    Map<String, String> queryParameters = {};
    bool popGesture = false;
    // Uri u2 = Uri.parse('kranken://startapp/?url=' + Uri.encodeComponent('assets/list.page.js'));
    if (u.scheme == 'kranken') {
      bundleURL = Uri.decodeComponent(u.queryParameters["url"] as String);
      queryParameters = u.queryParameters;
      popGesture = queryParameters['popGesture'] == '0';
    } else {
      bundleURL = schema;
    }
    final kraken = buildKraken(
      context,
      bundleURL,
      queryParameters,
    );
    return popGesture
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: kraken,
          )
        : kraken;
  }

  Widget buildKraken(
      context, String bundleURL, Map<String, String> schemaConfig) {
    final MediaQueryData queryData = MediaQuery.of(context);
    Color background = Colors.white;
    String color = schemaConfig['bgcolor'] ?? '';
    if (color.isNotEmpty) {
      int colorValue = int.tryParse(
              color.replaceAll('#', '0xff').replaceAll('0x', ''),
              radix: 16) ??
          0xFFFFFFFF;
      background = Color(colorValue);
    }

    final kraken = Kraken(
      background: background,
      viewportWidth: queryData.size.width,
      viewportHeight: queryData.size.height,
      bundlePath: bundleURL,
    );
    return Scaffold(
      // appBar: appBar,
      body: kraken,
    );
  }
}
