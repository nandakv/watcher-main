import 'package:flutter/material.dart';
import 'package:privo/initialze_sdk.dart';
import 'package:privo/main.dart';

import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.qa;
  await SDKManager.initializeAllSDK();
  runApp(const MyApp());
}
