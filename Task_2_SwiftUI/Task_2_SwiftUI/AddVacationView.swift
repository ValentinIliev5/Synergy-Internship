//
//  AddVacationView.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 13.05.24.
//

import SwiftUI
import CoreData
import MapKit
import PhotosUI

struct AddVacationView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.dismiss) private var dismiss
    
    
    @StateObject var vm = AddVacationViewModel()
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        Form{
            TextField("Vacation name", text: $vm.name)
            TextField("Hotel name", text: $vm.hotelName)
            TextField("Money needed", value:$vm.moneyNeeded, formatter: vm.getNumberFormatter())
            TextField("Description", text: $vm.desc)
        }
        
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
        
        Button("Create") {
            vm.addVacation(viewContext: viewContext, selectedImage: selectedImage!)
            dismiss()
        }
}

struct AddVacationView_Previews: PreviewProvider {
    static var previews: some View {
        AddVacationView()
    }
}



class AddVacationViewModel : ObservableObject{
    
    @Published var name = ""
    @Published var hotelName = ""
    @Published var moneyNeeded = 0.0
    @Published var desc = ""
    
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 42.7339,longitude: 25.4858),
        span: .init(latitudeDelta: 5, longitudeDelta: 3.5)
    )
    
    func addVacation(viewContext: NSManagedObjectContext, selectedImage: UIImage)
    {
        withAnimation {
            
            let newVacation = DesiredVacation(context: viewContext)
            
            newVacation.name = name
            newVacation.hotelName = hotelName
            newVacation.latitude = region.center.latitude
            newVacation.longitude = region.center.longitude
            newVacation.moneyNeeded = moneyNeeded
            newVacation.desc = desc
            
            newVacation.image = selectedImage.pngData()
            
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
