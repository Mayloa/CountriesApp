//
//  CountriesApi.swift
//  Countries
//
//  Created by Mayte LA on 02/11/23.
//

import Foundation


final class CountriesAPI {
    public func getCountries(body: String, completion: @escaping (Data?)->()) {
        WebRequest.callApi(url: "https://servicesoap.azurewebsites.net/ws/Paises.asmx", body: body) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                completion(nil)
                print(error.localizedDescription)
            }
        }
    }
    
}
