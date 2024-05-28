//
//  CitiesListView.swift
//  Task_1
//
//  Created by Synergy on 7.05.24.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DesiredVacation.name, ascending: true)],
        animation: .default)
    
    private var vacations: FetchedResults<DesiredVacation>
    
    var body: some View
    {
        NavigationView
        {
        List{
            ForEach(vacations){ vacation in
            NavigationLink{
                VacationView(vacation: vacation)
                } label: {
                    Text("\(vacation.name!) : \(vacation.desc ?? "")")
                }
            }
            .onDelete(perform: deleteVacation)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink{
                            AddVacationView()
                        } label: {
                            Text("Add")
                        }
                    }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    NavigationLink{
                        NotificationsView()
                    } label: {
                        Text("Notifications")
                    }
                }
            }
        }
    }
    
    private func deleteVacation(offsets: IndexSet) {
        withAnimation {
            offsets.map { vacations[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

