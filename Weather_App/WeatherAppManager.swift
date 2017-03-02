//
//  WeatherAppManager.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 2/28/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import Foundation


struct Constants {
    
    struct WeatherAPIDetails {
        static let APIKey = "b274c5ce65b3e435688f3098769c6dee"
        static let APIScheme = "http"
        static let APIHost = "api.openweathermap.org"
        static let APIPath = "/data/2.5/weather"
        // /data/2.5/weather
    }
}


class WeatherAppManager {
    
    typealias CompletionHandler = (_ success:Bool, _ fetchedData:Any?,_ error: Error?) -> Void
    
    static let sharedStore = WeatherAppManager()
    
    private var networkManager = WeatherNetworkManager.sharedNetworkmanager
    
    
    
    /*
     fetchweatherDetailsOfCity fuction ----> To call the Network manager class for calling webservice 
     input - URLRequest
     Output - success (true/false), fetchedData (JSondictionay), error(NSerror ot nil)
     */
    
    func fetchweatherDetailsOfCity(cityName: String, completion:@escaping (_ success:Bool, _ fetchedData:Any?,_ error: Error?) -> Void) -> Void {
        
        let url = createURLFromParameters(parameters: ["q":cityName as AnyObject, "appid": Constants.WeatherAPIDetails.APIKey as AnyObject], pathparam: nil)
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20.0)
        print("urlString \(urlRequest.url?.absoluteString)")
        
        networkManager.fetchDataWithUrlRequest(urlRequest) { (_ success:Bool, _ fetchedData:Any?,_ error: Error?) in
            if let weatherDict = fetchedData as? [String:Any] {
                
                if let statusCode = weatherDict["cod"] as? Int {
                    
                    if statusCode == 200{
                        completion(true, weatherDict, nil)
                    }else{

                        self.getDummyResponse(completion: completion)
                       //completion(false, weatherDict, nil)
                    }
                }else{
                    completion(false, weatherDict, nil)
                }
            }
        }
        
       
    }
    
    
    /*
     getDummyResponse fuction ----> to Get the Dummy response in case of Failure if service is not proving expected data
     input - URLRequest
     Output - success (true/false), fetchedData (JSondictionay), error(NSerror ot nil)
     */
    
    func getDummyResponse( completion:@escaping (_ success:Bool, _ fetchedData:Any?,_ error: Error?) -> Void) {

        let responseString = "{\"coord\":{\"lon\":-0.13,\"lat\":51.51},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\",\"icon\":\"04n\"}],\"base\":\"stations\",\"main\":{\"temp\":279.48,\"pressure\":995,\"humidity\":70,\"temp_min\":278.15,\"temp_max\":281.15},\"visibility\":10000,\"wind\":{\"speed\":8.2,\"deg\":260},\"clouds\":{\"all\":90},\"dt\":1488329400,\"sys\":{\"type\":1,\"id\":5091,\"message\":0.0963,\"country\":\"GB\",\"sunrise\":1488350719,\"sunset\":1488390069},\"id\":2643743,\"name\":\"London\",\"cod\":200}"

        let data = responseString.data(using: String.Encoding.utf8)

        do {
            
            let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<AnyHashable,Any>
            print("Dummy jsonObject \(jsonObject)")
            completion(true, jsonObject, nil)
        }
            
        catch let error as NSError{
            completion(false, [:], error)
            
            
        }
    }
    
    
    /*
     createURLFromParameters fuction ----> to URLRequest based on query provide by Parameters or PathParams
     input - URLRequest
     Output - success (true/false), fetchedData (JSondictionay), error(NSerror ot nil)
     */
    
    private func createURLFromParameters(parameters: [String:AnyObject], pathparam: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.WeatherAPIDetails.APIScheme
        components.host   = Constants.WeatherAPIDetails.APIHost
        components.path   = Constants.WeatherAPIDetails.APIPath
        if let paramPath = pathparam {
            components.path = Constants.WeatherAPIDetails.APIPath + "\(paramPath)"
        }
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    

    
    
}
