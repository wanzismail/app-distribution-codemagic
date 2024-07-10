import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/staging_firebase_options.dart' as staging;
import 'package:rental_app/utils/remote_config_helper.dart';

import 'data/repository_impl.dart';
import 'presentation/home_screen.dart';
import 'presentation/repository_provider.dart';
import 'utils/extensions/color_ext.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Here, we initialize Firebase and pass in our generated
  /// Firebase option [DefaultFirebaseOptions.currentPlatform]
  await Firebase.initializeApp(
    options: staging.DefaultFirebaseOptions.currentPlatform,
  );

  await RemoteConfigHelper.setUpRemoteConfig();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<RemoteConfigUpdate>? _subscription;

  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    // Listen update from firebase remote config
    _subscription =
        remoteConfig.onConfigUpdated.listen((event) async => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = remoteConfig.getString('scaffold_color');
    final titleColor = remoteConfig.getString('app_bar_title_color');
    final textFieldColor = remoteConfig.getString('text_field_color');

    return RepositoryProvider(
      repository: DummyRepositoryImpl(),
      child: MaterialApp(
        title: 'Rental App',
        theme: ThemeData(
          scaffoldBackgroundColor: ColorHex.fromHex(scaffoldColor),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: ColorHex.fromHex(textFieldColor),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: ColorHex.fromHex(scaffoldColor),
            elevation: 0,
            centerTitle: false,
            toolbarTextStyle: _titleTextStyle.copyWith(
              color: ColorHex.fromHex(titleColor),
            ),
            titleTextStyle: _titleTextStyle.copyWith(
              color: ColorHex.fromHex(titleColor),
            ),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }

  TextStyle get _titleTextStyle {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xff333333),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
