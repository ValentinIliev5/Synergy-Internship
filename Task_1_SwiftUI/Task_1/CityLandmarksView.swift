//
//  CityLandmarksView.swift
//  Task_1
//
//  Created by Synergy on 7.05.24.
//

import Foundation
import SwiftUI
import CoreData
import MapKit

struct CityLandmarksView: View{
    
    
    @StateObject var vm = CityLandmarksViewModel()
    
    var cityForView: City
    
    func getCurrentCityId() -> String{
        return String("\(cityForView.objectID)")
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Landmark.name, ascending: true)],
//        //predicate: NSPredicate(format: "city == %@", "\(cityForView.objectID)"),
//        animation: .default)
//    private var landmarks: FetchedResults<Landmark>
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 42.7339,longitude: 25.4858),
        span: .init(latitudeDelta: 5, longitudeDelta: 3.5)
    )
    
    func getFilteredLandmarks() -> [Landmark] {
        //return landmarks.filter{ $0.city?.objectID == cityForView.objectID}
        
        return vm.getFilteredLandmarksFromVM(city: cityForView, context:viewContext)
    }
    func getBulgariaCoordinates() -> CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: 42.7339, longitude: 25.4858)
    }
    func getLandmarkLocation(landmark:Landmark) -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longtitude)
    }
    
    
    var body: some View
    {
            VStack{
                NavigationLink{
                    LandmarkCreationView(city:self.cityForView)
                }
                label : {
                    Text("Add landmark")
                }
                Text("Landmarks in \(cityForView.name!)")
                
                Map(coordinateRegion: $region,annotationItems: getFilteredLandmarks())
                {
                    landmark in
                    
                    MapAnnotation(coordinate: getLandmarkLocation(landmark: landmark)) {
                        
                        Text("\(landmark.name ?? "")")
                        
                        NavigationLink {
                            Text("\(landmark.name ?? "") - \(landmark.desc ?? "")")
                        } label: {
                                Circle().stroke(Color.yellow, lineWidth: 4)
                                        .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
    
    private func deleteLandmark(offsets: IndexSet) {
        withAnimation {
            offsets.map { getFilteredLandmarks()[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

class CityLandmarksViewModel : ObservableObject{
    
    func getFilteredLandmarksFromVM(city:City, context:NSManagedObjectContext) -> [Landmark]
    {
        let fetchRequest: NSFetchRequest<Landmark> = Landmark.fetchRequest()

        let cityPredicate = NSPredicate(format: "city == %@", city)
        fetchRequest.predicate = cityPredicate
                  
        do {
            let results = try context.fetch(fetchRequest)
            print("Successfully fetched \(results.count) landmarks")
            return results
        } catch {
            print("Error fetching landmarks: \(error)")
            return []
        }
    }
}
