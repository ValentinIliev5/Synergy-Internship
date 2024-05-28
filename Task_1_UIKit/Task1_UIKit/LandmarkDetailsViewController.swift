//
//  LandmarkDetailsViewController.swift
//  Task1_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit
import CoreData

class LandmarkDetailsViewController: UIViewController {
    
    @IBOutlet weak var landmarkNameTV: UILabel!
    @IBOutlet weak var landmarkDescTV: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var landmark:Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        landmarkNameTV.text = landmark?.name
        landmarkDescTV.text = landmark?.desc
        
    }
    
    @IBAction func deleteLandmarkClicked(_ sender: Any) {
        do {
            context.delete(landmark!)
            
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error deleting landmark: \(error)")
        }
    }
}
