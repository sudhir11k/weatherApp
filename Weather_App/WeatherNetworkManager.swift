//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 2/28/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import Foundation
import UIKit

class WeatherNetworkManager: NSObject, URLSessionTaskDelegate {

    static let sharedNetworkmanager = WeatherNetworkManager()
    let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        
        return URLSession(configuration: config)
    }()

    /*
     fetchDataWithUrlRequest fuction ----> initiate the service call using NSURL Session
     input - URLRequest
     Output - success (true/false), fetchedData (JSondictionay), error(NSerror ot nil)
     */
    
    func fetchDataWithUrlRequest(_ urlRequest: URLRequest, completion:@escaping (_ success:Bool, _ fetchedData:Any?,_ error: Error?) -> Void) {
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                completion(false, nil, nil)
            } else {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<AnyHashable,Any>
                    print(jsonObject)
                    completion(true, jsonObject, nil)
                } catch {
                    completion(false, nil, nil)
                }
            }
        })
        task.resume()
        
    }

}
