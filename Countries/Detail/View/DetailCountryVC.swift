//
//  DetailCountryVC.swift
//  Countries
//
//  Created by Mayte LA on 02/11/23.
//

import UIKit
import MapKit
import CoreLocation
class DetailCountryVC: UIViewController {
    let country: Countries
    
    init(country: Countries) {
        self.country = country
        super.init(nibName: nil, bundle: Bundle(for: DetailCountryVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var currentElement = ""
    private var xmlDict = [String: Any]()
    private var xmlDictArr = [[String: Any]]()
    private var states = [State]()
    
    private let countriesApi = CountriesAPI()
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = country.nombrePais
        self.navigationController?.navigationBar.barTintColor = .white
        self.view.backgroundColor = .purple
        self.configureMapView()
        
        self.callApi()
    }
    
    func configureMapView() {
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        self.mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
    }
    
    func setupMapView() {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  self.states[0].coordinate.latitude, longitude: self.states[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0))
        mapView.region = region
        
    }
    
    func callApi() {
        let body = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetEstadosbyPais xmlns=\"http://tempuri.org/\"><idEstado>\(country.idPais)</idEstado></GetEstadosbyPais></soap:Body></soap:Envelope>"
        
        countriesApi.getCountries(body: body) { xmlData in
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                
                if let xmlData = xmlData {
                    self.parseXML(data: xmlData)
                } else {
                    print("error al consumir servicio")
                }
            }
        }
    }
    
    func parseXML(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func updateUI() {
        for state in states {
            let annotations = MKPointAnnotation()
            annotations.title = state.stateName
            annotations.coordinate = state.coordinate
            
            mapView.addAnnotation(annotations)
        }
        
        self.setupMapView()
    }
    
    func showAlertView(state: State) {
        let alertController = UIAlertController(title: state.stateName, message: "Este estado pertenece a \(country.nombrePais).\n\n Sus coordenadas son: \(state.coordinate.latitude) , \(state.coordinate.longitude).", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Aceptar", style: .default)
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
    }
}

// MARK: - XMLParserDelegate
extension DetailCountryVC: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Estado" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                xmlDict.updateValue(string, forKey: currentElement)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Estado" {
            xmlDictArr.append(xmlDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parsingCompleted()
    }
    
    func parsingCompleted() {
        self.states = self.xmlDictArr.map { State(dictionary: $0) }
        self.updateUI()
    }
}


extension DetailCountryVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
       let stateSelected =  view.annotation?.title ?? ""
        
        guard let state = self.states.first(where: { $0.stateName == stateSelected }) else { return }
        
        self.showAlertView(state: state)
    }
}
