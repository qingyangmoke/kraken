import 'package:flutter/material.dart';
import 'package:kraken/kraken.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraken Browser',
      // theme: ThemeData.dark(),
      home: KratenWebView(),
    );
  }
}

class KratenWebView extends StatefulWidget {
  KratenWebView({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<KratenWebView>
    with WidgetsBindingObserver {
  OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    borderRadius: const BorderRadius.all(
      Radius.circular(20.0),
    ),
  );

  Kraken _kraken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
      BridgeMethodManager.instance.invokeJavascriptMethod(-1, 'appLifecycleStateChanged', {
        'state': state.toString().split('.').last,
      });
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    BridgeMethodManager.instance.invokeJavascriptMethod(-1, 'platformBrightnessChanged', {
      'platformBrightness':
          (window.platformBrightness == Brightness.dark) ? 'dark' : 'light',
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    BridgeMethodManager.instance.invokeJavascriptMethod(-1, 'resize', {});
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    // final TextEditingController textEditingController = TextEditingController();

    BridgeMethodManager.instance.bootstrap(context);

    // AppBar appBar = AppBar(
    //   backgroundColor: Colors.black87,
    //   titleSpacing: 10.0,
    //   title: Container(
    //     height: 40.0,
    //     child: TextField(
    //       controller: textEditingController,
    //       onSubmitted: (value) {
    //         textEditingController.text = value;
    //         _kraken?.loadURL(value);
    //       },
    //       decoration: InputDecoration(
    //         hintText: 'Enter a app url 2',
    //         hintStyle: TextStyle(color: Colors.black54, fontSize: 16.0),
    //         contentPadding: const EdgeInsets.all(10.0),
    //         filled: true,
    //         fillColor: Colors.grey,
    //         border: outlineBorder,
    //         focusedBorder: outlineBorder,
    //         enabledBorder: outlineBorder,
    //       ),
    //       style: TextStyle(color: Colors.black, fontSize: 16.0),
    //     ),
    //   ),
    //   // Here we take the value from the MyHomePage object that was created by
    //   // the App.build method, and use it to set our appbar title.
    // );

    final Size viewportSize = queryData.size;
    print('app loaded');
    _kraken = Kraken(
      viewportWidth: viewportSize.width - queryData.padding.horizontal,
      // viewportHeight: viewportSize.height -
      //     appBar.preferredSize.height -
      //     queryData.padding.vertical,
      viewportHeight: viewportSize.height,
      bundlePath: 'assets/main.js',
    );

    return Scaffold(
        // appBar: appBar,
        body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: _kraken,
    ));
  }
}
