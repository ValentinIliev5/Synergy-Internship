//
//  CityLandmarksViewController.swift
//  Task1_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit
import MapKit
import CoreData

class CityLandmarksViewController: UIViewController,MKMapViewDelegate {

    var city: City?
    var landmarks : [Landmark] = []
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var landmarksMapView: MKMapView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.text = city?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        landmarksMapView.removeAnnotations(landmarksMapView.annotations)
        landmarks = getFilteredLandmarksFromVM(city: city!)
        
        for landmark in landmarks {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: landmark.lat, longitude: landmark.long)
                    annotation.title = landmark.name
                    annotation.subtitle = landmark.desc
                    landmarksMapView.addAnnotation(annotation)
                }
    }
    @IBAction func AddLandmarkClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toCreateLandmarkView", sender: city)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("marker clicked!")
            if let annotationTitle = view.annotation?.title,
               let landmark = landmarks.first(where: { $0.name == annotationTitle }) {
                
                performSegue(withIdentifier: "toLandmarkDetails", sender: landmark)
            }
        }
    
    
    
    func getFilteredLandmarksFromVM(city:City) -> [Landmark]
    {
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        let cityPredicate = NSPredicate(format: "city.name == %@", city.name!)
        fetchRequest.predicate = cityPredicate
                  
        do {
            let results = try context.fetch(fetchRequest)
            
            print("Successfully fetched \(results.count) landmarks")
            return results
        } catch {
            print("Error fetching landmarks: \(error)")
            return []
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateLandmarkView"
        {
            if let destVC = segue.destination as? AddLandmarkViewController{
                if let selectedCity = sender as? City{
                    destVC.city = selectedCity
                }
            }
        }
        if segue.identifier == "toLandmarkDetails",
               let destVC = segue.destination as? LandmarkDetailsViewController,
               let landmark = sender as? Landmark {
            destVC.landmark = landmark
    }
}
}
