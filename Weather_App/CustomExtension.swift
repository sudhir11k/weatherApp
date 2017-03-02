//
//  CustomExtension.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 3/1/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import Foundation
import UIKit



/*
  To Display Alert on UIViewController
 */
extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


/*
 To Convert Dictionary in Hashable Key Value pair so that Deep down access of Element with Dictionary of Dictionary
 */

extension Dictionary where Key: Hashable, Value: Any {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}


/*
 To Download the image on background thread, once complete image will be assigned to UIImageviewInstance
 
 */
extension UIImageView {
    func downloadedFrom(link linkURL:NSURL, contentMode mode: UIViewContentMode) {
        contentMode = mode
        //if let url = NSURL(string: link) {
        URLSession.shared.dataTask(with: linkURL as URL, completionHandler: { (data, _, error) -> Void in
            guard let data = data, error == nil else {
                
                return
            }
            DispatchQueue.main.async { () -> Void in
                
                self.image = UIImage(data: data)
            }
        }).resume()
        
    }
}
