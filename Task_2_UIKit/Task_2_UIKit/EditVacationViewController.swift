//
//  EditVacationViewController.swift
//  Task_2_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit

class EditVacationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var vacation: DesiredVacation?
    
    @IBOutlet weak var vacationNameText: UITextField!
    @IBOutlet weak var hotelNameText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var moneyNeededText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var vacImageView: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vacationNameText.text = vacation?.name
        hotelNameText.text = vacation?.hotelName
        locationText.text = vacation?.location
        moneyNeededText.text = "\(vacation?.moneyNeeded ?? 0.0)"
        descriptionText.text = vacation?.desc
            
        vacImageView.image = UIImage(data: (vacation?.image)!)
        
    }
    @IBAction func selectImageButtonClick(_ sender: Any) {
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
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        editVacation()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func editVacation()
    {
        vacation?.name = vacationNameText.text
        vacation?.hotelName = hotelNameText.text
        vacation?.location = locationText.text
        vacation?.moneyNeeded = Double(moneyNeededText.text!) ?? 0.0
        vacation?.desc = descriptionText.text
        
        vacation?.image = vacImageView.image!.pngData()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
}
