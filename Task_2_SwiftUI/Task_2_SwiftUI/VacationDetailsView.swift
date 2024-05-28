//
//  VacationView.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 13.05.24.
//

import SwiftUI
import MapKit

struct VacationDetailsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var vacation : DesiredVacation
    
    init(vacation:DesiredVacation)
    {
        self.vacation = vacation
        self._vm = StateObject(wrappedValue: VacationDetailsVM(vacation:vacation))
        
    }
    @StateObject private var vm : VacationDetailsVM
    
    var body: some View {
        Image(uiImage: UIImage(data: vm.image!)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            Text("\(vm.vacation.name!)")
                .onAppear {
                    vm.updateView()
                }
            Text("Hotel: \(vm.hotelName)")
            Text("\(vm.vacation.desc!)")
            Text("Money needed : \(vm.vacation.moneyNeeded)")
        
        
        Map(coordinateRegion: $vm.region, annotationItems: [vm.vacation])
        {
            place in
            MapMarker(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude), tint: .red)
        }
        
        .toolbar {
            ToolbarItem{
                NavigationLink{
                    EditVacationView(vacation:vm.vacation)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
    
}
class VacationDetailsVM : ObservableObject{
    
    @Published var vacation: DesiredVacation
    
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
    
    func updateView()
    {
        self.vacation = vacation
        self.name = vacation.name ?? ""
        self.hotelName = vacation.hotelName ?? ""
        self.moneyNeeded = vacation.moneyNeeded
        self.desc = vacation.desc ?? ""
        self.image = vacation.image
        self.region = MKCoordinateRegion(
            center: .init(latitude: vacation.latitude, longitude: vacation.longitude),
            span: .init(latitudeDelta: 0.3, longitudeDelta: 0.3))
    }
    
}
