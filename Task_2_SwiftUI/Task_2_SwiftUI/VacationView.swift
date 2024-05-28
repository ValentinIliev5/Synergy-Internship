//
//  VacationView.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 15.05.24.
//

import SwiftUI
import MapKit

struct VacationView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var vacation : DesiredVacation
    
    init(vacation:DesiredVacation)
    {
        self.vacation = vacation
        self._vm = StateObject(wrappedValue: VacationVM(vacation:vacation))
        
    }
    @StateObject private var vm : VacationVM
    
    var body: some View {
        Image(uiImage: UIImage(data: vm.image!)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(3)
        Text("\(vm.name)").onAppear {
            vm.updateView()
        }
        Map(coordinateRegion: $vm.region)
        
        NavigationLink{
            VacationDetailsView(vacation: vm.vacation)
            
        }   label: {
                Text("Details")
            }
    }
}

class VacationVM : ObservableObject{
    
    init(vacation: DesiredVacation) {
            self.vacation = vacation
            self.name = vacation.name ?? ""
            self.image = vacation.image
            self.region = MKCoordinateRegion(
                center: .init(latitude: vacation.latitude, longitude: vacation.longitude),
                span: .init(latitudeDelta: 0.3, longitudeDelta: 0.3)
            )
        
    }
    
    @Published var vacation: DesiredVacation
    @Published var name = ""
    @Published var image : Data?
    @Published var region = MKCoordinateRegion(
        center: .init(latitude: 42.7339,longitude: 25.4858),
        span: .init(latitudeDelta: 5, longitudeDelta: 3.5))
    
    func updateView()
    {
        self.vacation = vacation
        self.name = vacation.name ?? ""
        self.image = vacation.image
        self.region = MKCoordinateRegion(
            center: .init(latitude: vacation.latitude, longitude: vacation.longitude),
            span: .init(latitudeDelta: 0.3, longitudeDelta: 0.3))
    }
}
