//
//  AddLandmarkViewController.swift
//  Task1_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit
import MapKit
import CoreData

class AddLandmarkViewController: UIViewController {

    var city: City?
    
    @IBOutlet weak var landmarkNameTV: UITextField!
    @IBOutlet weak var landmarkDescTV: UITextField!
    @IBOutlet weak var landmarkMapView: MKMapView!
    @IBOutlet weak var testButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testButton.setTitle(city?.desc, for: .normal)
        
    }
    
    
    @IBAction func CreateLandmarkOnClick(_ sender: Any) {
        
        addLandmark(landmarkName: landmarkNameTV.text ?? "", ladnmarkDescription: landmarkDescTV.text ?? "" , landmarkLongtitude: landmarkMapView.centerCoordinate.longitude, landmarkLatitude: landmarkMapView.centerCoordinate.latitude)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    private func addLandmark(landmarkName:String, ladnmarkDescription:String,landmarkLongtitude:Double, landmarkLatitude:Double) {
        let newLandmark = Landmark(context: context)
        newLandmark.name = landmarkName
        newLandmark.desc = ladnmarkDescription
        
        newLandmark.long = landmarkLongtitude
        newLandmark.lat = landmarkLatitude
        
        newLandmark.city = self.city
        
        
        do {
            try context.save()
            print("saved landmark")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
