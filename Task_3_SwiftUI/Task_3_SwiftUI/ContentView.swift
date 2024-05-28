//
//  ContentView.swift
//  Task_3_SwiftUI
//
//  Created by Synergy on 15.05.24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = TopicSelectionVM()
    
    var body: some View {
        NavigationView{
            VStack{
                Text("News App").font(.title)
                Text("Articles read: \(vm.articlesCountValue)")
                    .onAppear(perform: {
                        vm.refreshArticlesReadCount()
                        
                    })
                List(vm.topics, id:\.self){
                    topic in
                    NavigationLink{
                        NewsListView(topic: topic)
                        } label: {
                            Text("\(topic.capitalized)")
                        }
                }
            }
        }
    }
}

class TopicSelectionVM : ObservableObject{
    
    var topics : [String] = ["business","entertainment","science","health","sports","technology","general"]
    
    let preferences = UserDefaults.standard

    let articlesCountKey = "articlesCount"
    @Published var articlesCountValue = 0
    
    init(){
        if preferences.object(forKey: articlesCountKey ) == nil
        {
            preferences.setValue(0, forKey: articlesCountKey)
        }
        articlesCountValue = preferences.integer(forKey: articlesCountKey)
        
    }
    func refreshArticlesReadCount()
    {
        self.articlesCountValue = preferences.integer(forKey: articlesCountKey)
    }
}
