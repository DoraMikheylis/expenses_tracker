import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<Map<String, String>> getListIcons(BuildContext context) async {
  var assetsFile =
      await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(assetsFile);
  List<String> listIcons = manifestMap.keys
      .where((String key) => key.contains('categories_icons/'))
      .toList();

  RegExp regex = RegExp(r'[^\/\\]*(?=\.[^.]+$)');

  Map<String, String> iconNames = Map.fromIterable(listIcons,
      key: (e) {
        String match = regex.firstMatch(e)?.group(0) ?? "unknown";
        return toBeginningOfSentenceCase(match);
      },
      value: (e) => e);

  log(iconNames.toString());
  return iconNames;
}
