import UIKit
import Flutter
import WebEngage
import webengage_flutter
import SFMCSDK
import MarketingCloudSDK
import Cdp
import SafariServices

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // The appID, accessToken and appEndpoint are required values for MobilePush SDK Module configuration and are obtained from your MobilePush app.
    // See https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/get-started/get-started-setupapps.html for more information.
    var appID: String =  "51f0b8fd-e8e6-4d2c-9644-fa38c60de8e7"
    var accessToken: String = "1OiCQGgamTvkyVEDiIdRpuPC"
    var appEndpointURL: String = "https://mczd0zxgv0hpkrzr6jj5w60mrbf4.device.marketingcloudapis.com/"
    var mid: String = "542000947"
    var dataCloudAppId: String = "1e289552-e2e1-4b41-991c-ebf1959ac5a1"
    var dataCloudEndpoint: String = "https://h0zd8zt0h1zd9nzzgm3dsmj-mq.c360a.salesforce.com"
    // Define features of MobilePush your app will use.
    let analytics = true
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        WebEngage.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GeneratedPluginRegistrant.register(with: self)
        
        self.configureSDK()
        
        if let controller: FlutterViewController = window?.rootViewController as? FlutterViewController {
            print("Initialized Flutter controller")
            
            let methodChannel = FlutterMethodChannel(name: "privo", binaryMessenger: controller.binaryMessenger)
            
            methodChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                switch call.method{
                case "open_custom_tab":
                    guard let args = call.arguments as? [String: Any],
                          let urlString = args["custom_tab_url"] as? String,
                          let url = URL(string: urlString) else {
                        result(false)
                        return
                    }

                    let safariViewController = SFSafariViewController(url: url)
                    controller.present(safariViewController, animated: true, completion: nil)
                    result(true)
                    
                    break
                default:
                    result(FlutterMethodNotImplemented)
                }
            })

            // Create a dataCloud Method Channel
            let dataCloudChannel = FlutterMethodChannel(name: "data_cloud",
                                                        binaryMessenger: controller.binaryMessenger)

            print("Initialized data cloud method channel")

            dataCloudChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                let dataCloud = DataCloud(call: call)

                print("Entered data cloud method channel")

                switch call.method {
//                case "init":
//                    print("Data Cloud init called.")
//                    let value = dataCloud.initSDK()
//                    result([
//                        "result": value.result,
//                        "message": value.message
//                    ])
//                    break
                case "login":
                    print("Data Cloud login called")
                    let value = dataCloud.login()
                    result([
                        "result": value.result,
                        "message": value.message
                    ])
                    break
                case "logout":
                    print("Data Cloud logout called")
                    let value = dataCloud.logout()
                    result([
                        "result": value.result,
                        "message": value.message
                    ])
                    break
                case "set_user_attribute":
                    print("Data Cloud set user attribute called")
                    let value = dataCloud.setUserAttribute()
                    result([
                        "result": value.result,
                        "message": value.message
                    ])
                    break
                case "track_event":
                    print("Data Cloud track event called")
                    let value = dataCloud.trackEvent()
                    result([
                        "result": value.result,
                        "message": value.message
                    ])
                    break
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
        } else {
            print("Failed creating method channel")
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    // SDK: REQUIRED IMPLEMENTATION
    func configureSDK() {

        print("Configuring salesforce SDK")

        let bundleID = Bundle.main.bundleIdentifier
        
        if bundleID == "com.privo.creditsaison" {
            appID = "93889541-33d8-4f05-8c59-4695352bcc1f"
            accessToken = "4A7CAXSCVAXMCi06dbNyBjQd"
            appEndpointURL = "https://mczd0zxgv0hpkrzr6jj5w60mrbf4.device.marketingcloudapis.com/"
            mid = "542000947"
            dataCloudAppId = "a23c7c14-bfb8-4b11-9012-156b5a9f36ed"
            dataCloudEndpoint = "https://h0zd8zt0h1zd9nzzgm3dsmj-mq.c360a.salesforce.com"
        }
        
        let appEndpoint = URL(string: appEndpointURL)!
        
        // Use the Mobile Push Config Builder to configure the Mobile Push Module. This gives you the maximum flexibility in SDK configuration.
        // The builder lets you configure the module parameters at runtime.
        let mobilePushConfiguration = PushConfigBuilder(appId: appID)
            .setAccessToken(accessToken)
            .setMarketingCloudServerUrl(appEndpoint)
            .setMid(mid)
            .setAnalyticsEnabled(analytics)
            .setDelayRegistrationUntilContactKeyIsSet(false)
            .build()
        
        let cdpConfiguration = CdpConfigBuilder(appId: dataCloudAppId, endpoint: dataCloudEndpoint)
            .trackScreens(true)
            .trackLifecycle(true)
            .sessionTimeout(600)
            .build()

        // Set the completion handler to take action when module initialization is completed. The result indicates if initialization was sucesfull or not.
        // Seting the completion handler is optional.
        let completionHandler: (OperationResult) -> () = { result in
            if result == .success {
                // module is fully configured and ready for use
                self.setupMobilePush()
            } else {
                print("SFMC sdk configuration failed.");
            }
        }
        
        let dataCloudCompletionHandler: (OperationResult) -> () = { result in
            if result == .success {
                print("Data Cloud SDK configuration successful")
                SFMCSdk.cdp.setConsent(consent: SFMCSDK.Consent.optIn)
            } else {
                print("Data Cloud SDK configuration failed.");
            }
        }
        
        // Once you've created the mobile push configuration, intialize the SDK.
        SFMCSdk.initializeSdk(ConfigBuilder()
            .setPush(config: mobilePushConfiguration, onCompletion: completionHandler)
            .setCdp(config: cdpConfiguration,onCompletion: dataCloudCompletionHandler)
            .build())

        
    }
    
    func setupMobilePush() {

        // Set the URLHandlingDelegate to a class adhering to the protocol.
        // In this example, the AppDelegate class adheres to the protocol (see below)
        // and handles URLs passed back from the SDK.
        // For more information, see https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/sdk-implementation/implementation-urlhandling.html
        SFMCSdk.requestPushSdk { mp in
            mp.setURLHandlingDelegate(self)
        }

        // Make sure to dispatch this to the main thread, as UNUserNotificationCenter will present UI.
        DispatchQueue.main.async {
            // Set the UNUserNotificationCenterDelegate to a class adhering to thie protocol.
            // In this exmple, the AppDelegate class adheres to the protocol (see below)
            // and handles Notification Center delegate methods from iOS.
            UNUserNotificationCenter.current().delegate = self
            
            // Request authorization from the user for push notification alerts.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(_ granted: Bool, _ error: Error?) -> Void in
                if error == nil {
                    if granted == true {
                        // Your application may want to do something specific if the user has granted authorization
                        // for the notification types specified; it would be done here.
                    }
                }
            })
            
            // In any case, your application should register for remote notifications *each time* your application
            // launches to ensure that the push token used by MobilePush (for silent push) is updated if necessary.
            
            // Registering in this manner does *not* mean that a user will see a notification - it only means
            // that the application will receive a unique push token from iOS.
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SFMCSdk.requestPushSdk { mp in
            mp.setDeviceToken(deviceToken)
        }
    }
    
    // MobilePush SDK: REQUIRED IMPLEMENTATION
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    // MobilePush SDK: REQUIRED IMPLEMENTATION
    /** This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. **/
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationUserInfo(userInfo)
        }
        completionHandler(.newData)
    }
    
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Required: tell the MarketingCloudSDK about the notification. This will collect MobilePush analytics
        // and process the notification on behalf of your application.
        SFMCSdk.requestPushSdk { mp in
            mp.setNotificationRequest(response.notification.request)
        }
        
        completionHandler()
    }
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    override  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
}

// MobilePush SDK: REQUIRED IMPLEMENTATION
extension AppDelegate: URLHandlingDelegate {
    /**
     This method, if implemented, can be called when a Alert+CloudPage, Alert+OpenDirect, Alert+Inbox or Inbox message is processed by the SDK.
     Implementing this method allows the application to handle the URL from Marketing Cloud data.

     Prior to the MobilePush SDK version 6.0.0, the SDK would automatically handle these URLs and present them using a SFSafariViewController.

     Given security risks inherent in URLs and web pages (Open Redirect vulnerabilities, especially), the responsibility of processing the URL shall be held by the application implementing the MobilePush SDK. This reduces risk to the application by affording full control over processing, presentation and security to the application code itself.

     @param url value NSURL sent with the Location, CloudPage, OpenDirect or Inbox message
     @param type value NSInteger enumeration of the MobilePush source type of this URL
     */
    func sfmc_handleURL(_ url: URL, type: String) {
        // Very simply, send the URL returned from the MobilePush SDK to UIApplication to handle correctly.
        UIApplication.shared.open(url,
                                  options: [:],
                                  completionHandler: {
            (success) in
            print("Open \(url): \(success)")
        })
    }
}
