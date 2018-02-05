//
//  MyWebServiceManager.swift
//  API-Helpers(Swift) Example
//
//  Created by Webdior Mac - 2 on 05/02/18.
//  Copyright © 2018 Raj Dhakate. All rights reserved.
//

import UIKit
import AFNetworking

enum WebServiceType {
    case post
    case get
}

@objc protocol MyWebServiceManagerProtocol {
    func processComplete(serviceName: String, responseObject: Any)
    func processFailed(serviceName: String, errorDictionary: Error)
    func processOnGoing(serviceName: String, progress: Double)
}

class MyWebServiceManager: NSObject {
    
    private static let LOCALSERVER = ""
    private static let HOSTINGSERVER = ""
    private static let SERVER = LOCALSERVER
    
    private static let DelegateNotSet = "Delegate not set"
    
    var delegate: MyWebServiceManagerProtocol!
    
    public func callMyWebServiceManager(serviceName: String!, headerData: String?, headerFieldName: String?, parameterDictionary: [String: String]?, images: [UIImage]?, imageFieldName: String?, serviceType: WebServiceType!) {
        
        let mainURL = MyWebServiceManager.SERVER+serviceName
        let configuration = URLSessionConfiguration.default
        let manager = AFHTTPSessionManager(sessionConfiguration: configuration)
        
        if headerData != nil || headerFieldName != nil {
            manager.requestSerializer.setValue(headerData, forHTTPHeaderField: headerFieldName!)
        }
        
        callManager(manager: manager, serviceType: serviceType, url: mainURL, serviceName: serviceName, parameters: parameterDictionary, images: images, fileName: imageFieldName)
    }
    
    private func callManager(manager: AFHTTPSessionManager!, serviceType: WebServiceType!, url: String!, serviceName: String!, parameters: [String: String]?, images: [UIImage]?, fileName: String?) {
        
        // Print Full API URL
        if (parameters != nil) {
            var parameterDictionary = [String]()
            for key in (parameters?.keys)! {
                let value = parameters![key]
                let parameter = "\(key)=\(value ?? "nil")"
                parameterDictionary.append(parameter)
            }
            print("\(url)+?+\(parameterDictionary.joined(separator: "&"))")
        }
        
        if (images != nil) {
            // Upload Image by part
            for image in images! {
                manager.post(url, parameters: parameters, constructingBodyWith: { (formData) in
                    let data = UIImageJPEGRepresentation(image, 1.0)
                    formData.appendPart(withFileData: data!, name: fileName!, fileName: fileName!+".png", mimeType: "image/png")
                }, progress: { (uploadProgress) in
                    DispatchQueue.global().async {
                        if self.conforms(to: MyWebServiceManagerProtocol.self) {
                            self.delegate.processOnGoing(serviceName: serviceName, progress: uploadProgress.fractionCompleted*100)
                        } else {
                            print(MyWebServiceManager.DelegateNotSet)
                        }
                    }
                }, success: { (task, responseObject) in
                    print("response for \(url!)...... \n\(responseObject ?? "nil")")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processComplete(serviceName: serviceName, responseObject: responseObject ?? "nil")
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                }, failure: { (task, error) in
                    print("error for \(url)...... \n\(error.localizedDescription)")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processFailed(serviceName: serviceName, errorDictionary: error)
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                })
            }
        } else {
            // Call get service
            if serviceType == .get {
                manager.get(url, parameters: parameters, progress: { (progress) in
                    DispatchQueue.global().async {
                        if self.conforms(to: MyWebServiceManagerProtocol.self) {
                            self.delegate.processOnGoing(serviceName: serviceName, progress: progress.fractionCompleted*100)
                        } else {
                            print(MyWebServiceManager.DelegateNotSet)
                        }
                    }
                }, success: { (task, responseObject) in
                    print("response for \(url!)...... \n\(responseObject ?? "nil")")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processComplete(serviceName: serviceName, responseObject: responseObject ?? "nil")
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                }, failure: { (task, error) in
                    print("error for \(url)...... \n\(error.localizedDescription)")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processFailed(serviceName: serviceName, errorDictionary: error)
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                })
            }
            // Call post service
            else {
                manager.post(url, parameters: parameters, progress: { (progress) in
                    DispatchQueue.global().async {
                        if self.conforms(to: MyWebServiceManagerProtocol.self) {
                            self.delegate.processOnGoing(serviceName: serviceName, progress: progress.fractionCompleted*100)
                        } else {
                            print(MyWebServiceManager.DelegateNotSet)
                        }
                    }
                }, success: { (task, responseObject) in
                    print("response for \(url!)...... \n\(responseObject ?? "nil")")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processComplete(serviceName: serviceName, responseObject: responseObject ?? "nil")
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                }, failure: { (task, error) in
                    print("error for \(url)...... \n\(error.localizedDescription)")
                    if self.conforms(to: MyWebServiceManagerProtocol.self) {
                        self.delegate.processFailed(serviceName: serviceName, errorDictionary: error)
                    } else {
                        print(MyWebServiceManager.DelegateNotSet)
                    }
                })
            }
        }
    }

}
