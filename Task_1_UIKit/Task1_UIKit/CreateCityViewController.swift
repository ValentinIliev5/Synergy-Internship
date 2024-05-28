//
//  CreateCityViewController.swift
//  Task1_UIKit
//
//  Created by Synergy on 20.05.24.
//

import UIKit
import CoreData

class CreateCityViewController: UIViewController {

    @IBOutlet weak var cityNameText: UITextField!
    @IBOutlet weak var cityDescText: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func AddCityButton(_ sender: Any) {
        
        addCity(cityName: cityNameText.text!, cityDesc: cityDescText.text!)
        
        cityNameText.text = ""
        cityDescText.text = ""
        
    }
    

    private func addCity(cityName:String, cityDesc:String) {
       let newCity = City(context: context)
        newCity.name = cityName
        newCity.desc = cityDesc
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}
