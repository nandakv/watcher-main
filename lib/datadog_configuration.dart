import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:datadog_tracking_http_client/datadog_tracking_http_client.dart';

import 'flavors.dart';

/// We should run DataDog in Prod env only
DatadogConfiguration getDataDogConfig() {
  return DatadogConfiguration(
    clientToken: F.envVariables.dataDogCreds.clientToken,
    env: F.envVariables.dataDogCreds.env,
    uploadFrequency: UploadFrequency.average,
    batchSize: BatchSize.medium,
    site: DatadogSite.us1,
    nativeCrashReportEnabled: true,
    // loggingConfiguration: LoggingConfiguration(
    //   printLogsToConsole: false,
    //   sendNetworkInfo: true,
    // ),
    loggingConfiguration: DatadogLoggingConfiguration(),
    service: F.envVariables.dataDogCreds.serviceName,
    rumConfiguration: DatadogRumConfiguration(
      sessionSamplingRate: 25,
      applicationId: F.envVariables.dataDogCreds.applicationId,
      vitalUpdateFrequency: VitalsFrequency.frequent,
      reportFlutterPerformance: true,
    ),
    firstPartyHosts: ['creditsaison.in'],
  )..enableHttpTracking();
}

