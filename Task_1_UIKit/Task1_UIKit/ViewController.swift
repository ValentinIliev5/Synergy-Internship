//
//  ViewController.swift
//  Task1_UIKit
//
//  Created by Synergy on 20.05.24.
//

import UIKit
import CoreData

class ViewController: UIViewController,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = cities[indexPath.row]
        
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        cell.textLabel?.text = "\(city.name ?? "") : \(city.desc ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteCity(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        performSegue(withIdentifier: "toLandmarksView", sender: cities[indexPath.row])
       
    }


    var fetchedResultsController: NSFetchedResultsController<City>!
    
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities: [City] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Landmark Notebook"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCities()
        
        citiesTableView.reloadData()
        }
    
    private func fetchCities()
    {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                cities = fetchedObjects
                }
            } catch {
                print("Failed to fetch objects: \(error)")
            }
    }
    private func deleteCity(at indexPath: IndexPath) {
        let city = cities[indexPath.row]
        context.delete(city)
        
        do {
            try context.save()
            cities.remove(at: indexPath.row)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLandmarksView"
        {
            if let destVC = segue.destination as? CityLandmarksViewController{
                if let selectedCity = sender as? City{
                    destVC.city = selectedCity
                }
            }
        }
    }
    @IBAction func AddCityClicked(_ sender: Any) {
        print("<-><-><-><-><-> add city clicked! <-><-><-><-><->")
      
        performSegue(withIdentifier: "toCreateCityView", sender: nil)
    }
}

