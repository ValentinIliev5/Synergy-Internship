//
//  VacationDetailsViewController.swift
//  Task_2_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit

class VacationDetailsViewController: UIViewController {

    var vacation: DesiredVacation?
    @IBOutlet weak var vacNameL: UILabel!
    @IBOutlet weak var hotelNameL: UILabel!
    @IBOutlet weak var locationL: UILabel!
    @IBOutlet weak var moneyL: UILabel!
    @IBOutlet weak var descL: UILabel!
    @IBOutlet weak var vacImageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vacNameL.text = "Vacation name: \(vacation?.name ?? "")"
        hotelNameL.text = "Hotel name: \(vacation?.hotelName ?? "")"
        locationL.text = "Location: \(vacation?.location ?? "")"
        moneyL.text = "Money needed: \(vacation?.moneyNeeded ?? 0.0)"
        descL.text = "Description: \(vacation?.desc ?? "")"
        
        vacImageV.image = UIImage(data: (vacation?.image)!)
    }
    @IBAction func EditButtonClick(_ sender: Any) {
        
        performSegue(withIdentifier: "toEditVacation", sender: vacation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVacation"
        {
            if let destVC = segue.destination as? EditVacationViewController{
                if let selectedVacation = sender as? DesiredVacation{
                    destVC.vacation = selectedVacation
                }
            }
        }
    }
}
