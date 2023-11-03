//
//  Countries.swift
//  Countries
//
//  Created by Mayte LA on 01/11/23.
//

import Foundation

class Countries {
    var idPais: String
    var nombrePais: String
    
    init(dictionary: [String : Any]) {
        
         let idPais = dictionary["idPais"] as? String ?? ""
         let nombrePais = dictionary["NombrePais"] as? String ?? ""
   
        self.idPais = idPais
        self.nombrePais = nombrePais
        
              
    }
    
}
