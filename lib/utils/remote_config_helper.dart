import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:rental_app/utils/extensions/color_ext.dart';

class RemoteConfigHelper {
  static Future<FirebaseRemoteConfig> setUpRemoteConfig() async {
    /// Gets an instance of [FirebaseRemoteConfig]
    final remoteConfig = FirebaseRemoteConfig.instance;

    /// This gives the config some settings
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        /// By giving a timeout of 10 seconds, we tell Firebase to try fetching
        /// configurations and wait for a maximum of 10 seconds
        fetchTimeout: const Duration(seconds: 10),

        /// Since Remote Config caches configuration, setting this param
        /// let Firebase know when to consider cached configuration data as obsolete
        minimumFetchInterval: Duration.zero,
      ),
    );

    /// For our configurations, we are giving it default values to fall to
    /// in cases where fetching config fails or isn't found
    await remoteConfig.setDefaults(
      {
        'scaffold_color': Colors.white.toHex(),
        'app_bar_title_color': const Color(0xff333333).toHex(),
        'text_field_color': Colors.grey[100]!.toHex(),
        'shadow_color': Colors.grey[300]!.toHex(),
      },
    );

    await remoteConfig.fetchAndActivate();

    return remoteConfig;
  }
}
