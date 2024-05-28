//
//  VacationCreationViewController.swift
//  Task_2_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit

class VacationCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var vacNameTV: UITextField!
    @IBOutlet weak var hotelNameTV: UITextField!
    @IBOutlet weak var locationTV: UITextField!
    @IBOutlet weak var moneyNeededTV: UITextField!
    @IBOutlet weak var descriptionTV: UITextField!
    @IBOutlet weak var vacImageView: UIImageView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func selectImageButton(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = false
                present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Photo library is not available.")
            }
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            print("Image selected")
            if let selectedImage = info[.originalImage] as? UIImage {
                vacImageView.image = selectedImage
            }
            dismiss(animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Image picker canceled")
            dismiss(animated: true, completion: nil)
        }
    @IBAction func saveVacationButton(_ sender: Any) {
        
        addVacation()
        _ = navigationController?.popViewController(animated: true)

        
    }
    func addVacation()
    {
        let newVacation = DesiredVacation(context: context)
        
        newVacation.name = vacNameTV.text
        newVacation.hotelName = hotelNameTV.text
        newVacation.location = locationTV.text
        newVacation.moneyNeeded = Double(moneyNeededTV.text!) ?? 0.0
        newVacation.desc = descriptionTV.text
        
        newVacation.image = vacImageView.image?.pngData()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
}
