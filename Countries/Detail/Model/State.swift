//
//  State.swift
//  Countries
//
//  Created by Mayte LA on 02/11/23.
//
import MapKit
import Foundation

class State: NSObject, MKAnnotation {
    var idState: String
    var stateName: String
    var coordinate: CLLocationCoordinate2D
    var idCountry: Int
    init(dictionary: [String : Any]) {
        let idState = dictionary["idEstado"] as? String ?? ""
        let stateName = dictionary["EstadoNombre"] as? String ?? ""
        let coordinates = dictionary["Coordenadas"] as? String ?? ""
        let idCountry = dictionary["idPais"] as? Int ?? 0
        
        let arrayCoordinates = coordinates.split(separator: ", ")
       
        var latitude: Double = 0
        var longitude: Double = 0
        if arrayCoordinates.count == 2 {
            latitude = Double(arrayCoordinates[0]) ?? 0
            longitude = Double(arrayCoordinates[1]) ?? 0
            
        }
        
        self.idState = idState
        self.stateName = stateName
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.idCountry = idCountry
    }
}
