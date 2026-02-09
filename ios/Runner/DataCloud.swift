//
//  DataCloud.swift
//  Runner
//
//  Created by Simon1 on 02/04/25.
//
import Cdp
import SFMCSDK
import MarketingCloudSDK
import Flutter

class DataCloudResult {
    var result: Bool
    var message: String
    
    init(result: Bool, message: String) {
        self.result = result
        self.message = message
    }
}


class DataCloud{
    
    var call: FlutterMethodCall
    
    init(call: FlutterMethodCall) {
        self.call = call
    }
    
    
    func initSDK() -> DataCloudResult {
        if let args = call.arguments as? [String: String],
           let appId = args["appId"],
           let endPoint = args["endPoint"] {
            
            SFMCSdk.setLogger(logLevel: LogLevel.debug)
            
            let cdpModuleConfig = CdpConfigBuilder(appId: appId, endpoint: endPoint)
                .trackScreens(true)
                .trackLifecycle(true)
                .sessionTimeout(600)
                .build()
            
            SFMCSdk.initializeSdk(ConfigBuilder().setCdp(config: cdpModuleConfig).build())
            SFMCSdk.identity.setProfileAttributes([.cdp: ["isAnonymous": "0"]])
            return DataCloudResult(result: true, message: "Success")
        } else {
            return DataCloudResult(result: false, message: "Bad Arguments")
        }
    }
    
    func login() -> DataCloudResult {
        if let args = call.arguments as? [String: String],
           let phoneNumber = args["phone_number"] {
            
            SFMCSdk.identity.setProfileAttributes([.cdp: ["phoneNumber" : phoneNumber]])
            SFMCSdk.identity.setProfileAttributes([.cdp: ["isAnonymous": "1"]])
            
            return DataCloudResult(result: true, message: "Success")
        } else {
            return DataCloudResult(result: false, message: "Bad Arguments")
        }
    }
    
    func setUserAttribute() -> DataCloudResult {
        if let args = call.arguments as? [String: String],
           let attributeName = args["attribute_name"],
           let attributeValue = args["attribute_value"] {
            let profileAttributes = [
                attributeName: attributeValue
            ]
            SFMCSdk.identity.setProfileAttributes([.cdp: profileAttributes])
            return DataCloudResult(result: true, message: "Success")
        } else {
            return DataCloudResult(result: false, message: "Bad Arguments")
        }
    }
    
    func trackEvent() -> DataCloudResult {
        guard let args = call.arguments as? [String: Any],
              let eventName = args["event_name"] as? String else {
            
            return DataCloudResult(result: false, message: "Event Name is missing")
        }
        
        let attributes = args["attributes"] as? [String: Any] ?? [:]
        
        if let customEvent = CustomEvent(name: eventName, attributes: attributes) {
            // Track the event using Salesforce SDK (or your event tracking SDK)
            SFMCSdk.track(event: customEvent)
            return DataCloudResult(result: true, message: "success")
        } else {
            return DataCloudResult(result: false, message: "failed to track event")
        }
        
    }
    
    func logout() -> DataCloudResult {
        SFMCSdk.identity.setProfileAttributes([.cdp: ["isAnonymous": "0"]])
        
        return DataCloudResult(result: true, message: "Success")
    }
    
}
