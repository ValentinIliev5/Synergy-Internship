//
//  NotificationsView.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 14.05.24.
//

import SwiftUI
import UserNotifications


struct NotificationsView: View {
    
    @StateObject var vm = NotificationViewModel()
    
    var body: some View {
        
        Text("Notification settings" ).font(.system(size:30))
        Form{
            DatePicker("Date", selection: $vm.date, in:Date.now...)

            TextField("Notification name", text: $vm.notificationName)
            TextField("Notification description", text: $vm.notificationDescription)
            
        }
        
        Button("Add") {
            vm.getAuth()
            vm.addNotification()
        }
        
    }
}

class NotificationViewModel : ObservableObject
{
    
    @Published var notificationName = ""
    @Published var notificationDescription = ""
    @Published var date = Date()
    
    
    func addNotification()
    {
        let content = UNMutableNotificationContent()
        
        content.title = self.notificationName
        content.subtitle = self.notificationDescription
        
        
        content.sound = UNNotificationSound.default

        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: "Test123", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        
        print("Notification set")
        
        
        self.notificationName = ""
        self.notificationDescription = ""
        self.date = Date.now
    }
    
    func getAuth(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            success,error in
            if success {
                print("Auth Provided!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
}
