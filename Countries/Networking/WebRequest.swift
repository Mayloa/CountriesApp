//
//  WebRequest.swift
//  Countries
//
//  Created by Mayte LA on 01/11/23.
//

import Foundation

class WebRequest: NSObject {
    static let shared = WebRequest()
    let sesion = URLSession.shared
    
    func callApi(url: String, callback: @escaping(_ data: Data?) -> Void) {
        let url = URL(string: url)
        let header = ["content-type": "text/xml", "charset" :"utf-8"]
        
        let param2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetPaises xmlns=\"http://tempuri.org/\"/></soap:Body></soap:Envelope>"
       
        var request = URLRequest(url: url!)
        request.allHTTPHeaderFields = header
        request.httpMethod = "POST"
        request.httpBody = param2.data(using: .utf8)
        
        let task = sesion.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    callback(nil)
                } else {
                    if let data = data {
                            callback(data)
                    } else {
                        callback(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
