//
//  SetNotificationViewController.swift
//  Task_2_UIKit
//
//  Created by Synergy on 21.05.24.
//

import UIKit
import UserNotifications

class SetNotificationViewController: UIViewController {

    @IBOutlet weak var notifNameText: UITextField!
    @IBOutlet weak var notifDescText: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if let error = error {
                    print("Request Authorization Failed: \(error)")
                }
            }
        
    }
    @IBAction func setNotificationButton(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = notifNameText.text ?? "Default"
        content.subtitle = notifDescText.text ?? "Default"
        content.sound = .default
        let date = timePicker.date
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Failed to add notification: \(error)")
            } else {
                print("Notification scheduled for \(date)")
            }
        }
    }
    

}
