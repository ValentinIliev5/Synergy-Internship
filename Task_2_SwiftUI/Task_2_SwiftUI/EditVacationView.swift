//
//  EditVacationView.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 13.05.24.
//

import SwiftUI
import CoreData
import MapKit
import PhotosUI
import Foundation

struct EditVacationView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.dismiss) private var dismiss
    
    var vacation: DesiredVacation
    
    @StateObject var vm : EditVacationViewModel

    init(vacation:DesiredVacation)
    {
        self.vacation = vacation
        _selectedImage = State(initialValue: UIImage(data: vacation.image!))
        self._vm = StateObject(wrappedValue: EditVacationViewModel(vacation:vacation))
        
    }
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        
        TextField("Vacation name", text: $vm.name)
        TextField("Hotel name", text: $vm.hotelName)
        TextField("Money needed", value:$vm.moneyNeeded, formatter: vm.getNumberFormatter())
        TextField("Description", text: $vm.desc)
        
        
        Map(coordinateRegion: $vm.region)
        
        VStack {
            if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    Button("Pick a Photo") {
                        isShowingPicker.toggle()
                    }
                    .padding()
                }
                .sheet(isPresented: $isShowingPicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
        
        Button("Edit") {
            vm.editVacation(viewContext: viewContext, selectedImage: selectedImage!, vacation: vacation)
            dismiss()
        }
}



class EditVacationViewModel : ObservableObject{
    
    var vacation: DesiredVacation
    
    init(vacation: DesiredVacation) {
            self.vacation = vacation
            self.name = vacation.name ?? ""
            self.hotelName = vacation.hotelName ?? ""
            self.moneyNeeded = vacation.moneyNeeded
            self.desc = vacation.desc ?? ""
            self.image = vacation.image
            self.region = MKCoordinateRegion(
                center: .init(latitude: vacation.latitude, longitude: vacation.longitude),
                span: .init(latitudeDelta: 0.3, longitudeDelta: 0.3)
            )
        
    }
    
    @Published var name = ""
    @Published var hotelName = ""
    @Published var moneyNeeded = 0.0
    @Published var desc = ""
    @Published var image : Data?
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 42.7339,longitude: 25.4858),
        span: .init(latitudeDelta: 5, longitudeDelta: 3.5)
    )
    
    func editVacation(viewContext: NSManagedObjectContext, selectedImage: UIImage, vacation:DesiredVacation)
    {
        withAnimation {
            
            vacation.name = name
            vacation.hotelName = hotelName
            vacation.latitude = region.center.latitude
            vacation.longitude = region.center.longitude
            vacation.moneyNeeded = moneyNeeded
            vacation.desc = desc
            
            vacation.image = selectedImage.pngData()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func getNumberFormatter() -> NumberFormatter
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 3
        
        return numberFormatter
    }
}
    
}
