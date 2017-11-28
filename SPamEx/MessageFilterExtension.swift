//
//  MessageFilterExtension.swift
//  SPamEx
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//

import IdentityLookup
import libPhoneNumber_iOS

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling {
    
    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First, check whether to filter using offline data (if possible).
        let offlineAction = self.offlineAction(for: queryRequest)
        
        switch offlineAction {
        case .allow, .filter:
            // Based on offline data, we know this message should either be Allowed or Filtered. Send response immediately.
            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            
            completion(response)
            
        case .none:
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            context.deferQueryRequestToNetwork() { (networkResponse, error) in
                let response = ILMessageFilterQueryResponse()
                response.action = .none
                
                if let networkResponse = networkResponse {
                    // If we received a network response, parse it to determine an action to return in our response.
                    response.action = self.action(for: networkResponse)
                } else {
                    NSLog("Error deferring query request to network: \(String(describing: error))")
                }
                
                completion(response)
            }
        }
    }
    
    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        // Replace with logic to perform offline check whether to filter first (if possible).
        
        let sender = queryRequest.sender ?? ""
        let msg = queryRequest.messageBody ?? ""
        
        print("MSG :" + msg)
        print("Sender :" + sender)
        
        let phoneUtil = NBPhoneNumberUtil()
        let countryCode = NSLocale.current.regionCode
        
        var parseSender : String!
        do {
            let phoneNumber : NBPhoneNumber = try phoneUtil.parse(sender, defaultRegion: countryCode!)
            print(phoneNumber.nationalNumber.stringValue)
            parseSender = phoneNumber.nationalNumber.stringValue
        }
        catch let error as NSError {
            print(error)
        }
        
        CoreDataStack.store.fetchNumbers()
        CoreDataStack.store.fetchContents()
        
        let contents = CoreDataStack.store.contents
        let numbers = CoreDataStack.store.numbers
        
        for content in contents {
            if msg.range(of: content.fileterString!) != nil{
                return .filter
            }
        }
        
        for number in numbers {
            do {
                let phoneNumber : NBPhoneNumber = try phoneUtil.parse(number.number!, defaultRegion: countryCode!)
                print(phoneNumber.nationalNumber.stringValue)
                
                if (parseSender.range(of: phoneNumber.nationalNumber.stringValue) != nil){
                    return .filter
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
        
        return .none
    }
    
    private func action(for networkResponse: ILNetworkResponse) -> ILMessageFilterAction {
        // Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
        return .none
    }
    
}
