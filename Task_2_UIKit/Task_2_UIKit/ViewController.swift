//
//  ViewController.swift
//  Task_2_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit
import CoreData

class ViewController:  UIViewController,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    var vacations: [DesiredVacation] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<DesiredVacation>!
    @IBOutlet weak var vacationsTV: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vacation = vacations[indexPath.row]
        
        let cell = vacationsTV.dequeueReusableCell(withIdentifier: "vacationCell", for: indexPath)
        
        cell.textLabel?.text = "\(vacation.name ?? "") : \(vacation.desc ?? "")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteVacation(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toVacationDetails", sender: vacations[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVacationDetails"
        {
            if let destVC = segue.destination as? VacationDetailsViewController{
                if let selectedVacation = sender as? DesiredVacation{
                    destVC.vacation = selectedVacation
                }
            }
        }
    }
    @IBAction func notificationsButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toNotifications", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchVacations()
        
        print(vacations.count)
        vacationsTV.reloadData()
    }
    @IBAction func addVacationButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toCreateVacation", sender: nil)
    }
    
    
    private func fetchVacations()
    {
        let fetchRequest: NSFetchRequest<DesiredVacation> = DesiredVacation.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                vacations = fetchedObjects
                }
            } catch {
                print("Failed to fetch objects: \(error)")
            }
    }
    
    private func deleteVacation(at indexPath: IndexPath) {
        let vacation = vacations[indexPath.row]
        context.delete(vacation)
        
        do {
            try context.save()
            vacations.remove(at: indexPath.row)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

