//
//  CitiesListView.swift
//  Task_1
//
//  Created by Synergy on 7.05.24.
//

import Foundation
import SwiftUI
import CoreData

struct CitiesListView: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \City.name, ascending: true)],
        animation: .default)
    
    private var cities: FetchedResults<City>
    @State private var showingAlert = false
    @State private var cityName: String = ""
    @State private var cityDesc: String = ""
    
    var body: some View
    {
        NavigationView
        {
            VStack{
                
                TextField("Enter city name", text: $cityName)
                TextField("Enter city desc", text: $cityDesc)
                
                List{
                    ForEach(cities){ city in
                    NavigationLink{
                        CityLandmarksView(cityForView:city)
                        } label: {
                            Text("\(city.name!) : \(city.desc ?? "")")
                        }
                    }
                    .onDelete(perform: deleteCities)
                }
            }
            .toolbar{
                ToolbarItem {
                    Button("add") {
                        addCity(cityName: cityName, cityDesc: cityDesc)
                        cityName = ""
                        cityDesc = ""
                    }
                }
            }
        }
    }
    
    private func addCity(cityName:String, cityDesc:String) {
        withAnimation {
            let newCity = City(context: viewContext)
            newCity.name = cityName
            newCity.desc = cityDesc
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func deleteCities(offsets: IndexSet) {
        withAnimation {
            offsets.map { cities[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
