import 'dart:async';

import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:privo/initialze_sdk.dart';
import 'package:privo/main.dart';
import 'datadog_configuration.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.prod;
  await SDKManager.initializeAllSDK();

  await DatadogSdk.runApp(
    getDataDogConfig(),
    TrackingConsent.granted,
    () async {
      runApp(const MyApp());
    },
  );
}