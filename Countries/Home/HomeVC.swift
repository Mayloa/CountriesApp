//
//  ViewController.swift
//  Countries
//
//  Created by Mayte LA on 01/11/23.
//

import UIKit

class HomeVC: UIViewController {
    //  MARK: - Outlets
    @IBOutlet private var countriesPicker: UIPickerView!

    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountries()
    }
    
    func getCountries() {
        self.homeViewModel.getCountries() { [weak self] xmlData in
            DispatchQueue.main.async {
                if let xmlData = xmlData {
                    self?.homeViewModel.parseXML(data: xmlData)
                    self?.countriesPicker.reloadAllComponents()
                } else {
                    print("error al consumir servicio")
                }
            }
            
        }
    }
    
}

// MARK: - UIPickerViewDelegate
extension HomeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let vc = DetailCountryVC(country: self.homeViewModel.countries[row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension HomeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.homeViewModel.countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = self.homeViewModel.countries[row]
        
        return country.nombrePais
      
    }
}
