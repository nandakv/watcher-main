import '../../flavors.dart';

class HTMLGenerator {
  final String fipId;
  final List<String> consentHandle;
  final String mobileNumber;
  final String bankName;

  HTMLGenerator({
    required this.fipId,
    required this.consentHandle,
    required this.mobileNumber,
    required this.bankName,
  });

  String generateHTMLCode() {
    return """
    <!DOCTYPE html>
<html>
  <head>
    <meta
      name="viewport"
      content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width"
    />
    <style>
      html,
      body {
        overflow-x: hidden;
        overflow-y: hidden;
      }
    </style>
  </head>
  <body onload="sdkInitiate()" style="width: 100vw; height: 100vh; margin: 0">
    <script>
      window.addEventListener("message", (event) => {
        const { data } = event;
        console.log(data);
        console.log(data["eventCode"] + "|" + data["errorMessage"]);
        AAEvents.postMessage(data["eventCode"] + "|" + data["errorMessage"] + "|" + data["eventMessage"]);
      });

      function sdkInitiate() {
        let iframe = document.getElementById("websdk");
        const webSdkKeys = {
          organisationId: "${F.envVariables.aasdkCreds.organisationId}",
          fipId: "$fipId",
          consentHandle: ${consentHandle.map((e) => "\"$e\"").toList()},
          mobileNumber: "$mobileNumber",
          bankName: "$bankName",
        };
        iframe.contentWindow.postMessage(webSdkKeys, "*");
      }
    </script>
    <iframe
      id="websdk"
      src="${F.envVariables.aasdkCreds.iFrameURL}"
      width="100%"
      height="100%"
    ></iframe>
  </body>
</html>
    """;
  }
}
