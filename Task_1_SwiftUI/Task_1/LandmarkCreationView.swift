//
//  LandmarkCreationView.swift
//  Task_1
//
//  Created by Synergy on 7.05.24.
//

import Foundation
import SwiftUI
import CoreData
import MapKit

struct LandmarkCreationView: View
{
    @Environment(\.managedObjectContext) private var viewContext

    @Environment(\.dismiss) private var dismiss
    
    
    @State private var landmarkName: String = ""
    @State private var landmarkDesc: String = ""
    
    var landmarkLongtitude: Double = 0.0
    var landmarkLatitude: Double = 0.0
    
    var city: City
    
    @State var region = MKCoordinateRegion(
        center: .init(latitude: 42.7339,longitude: 25.4858),
        span: .init(latitudeDelta: 5, longitudeDelta: 3.5)
    )
    
    var body: some View{
        VStack{
            Text("Enter landmark data: ")
            TextField("Enter landmark name", text: $landmarkName)
            TextField("Enter landmark desc", text: $landmarkDesc)
            
            Map(coordinateRegion: $region)
            
            Button("add") {
                addLandmark(landmarkName: landmarkName, ladnmarkDescription: landmarkDesc,
                            landmarkLongtitude:String($region.center.longitude.wrappedValue),
                            landmarkLatitude: String($region.center.latitude.wrappedValue))
                dismiss()
            }
        }
    }

    private func addLandmark(landmarkName:String, ladnmarkDescription:String,landmarkLongtitude:String, landmarkLatitude:String) {
        withAnimation {
            
            let newLandmark = Landmark(context: viewContext)
            newLandmark.name = landmarkName
            newLandmark.desc = ladnmarkDescription
            
            newLandmark.longtitude = Double(landmarkLongtitude) ?? 0.0
            newLandmark.latitude = Double(landmarkLatitude) ?? 0.0
            
            newLandmark.city = self.city
            
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
