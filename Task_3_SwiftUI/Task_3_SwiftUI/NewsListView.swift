//
//  NewsListView.swift
//  Task_3_SwiftUI
//
//  Created by Synergy on 15.05.24.
//

import SwiftUI

struct NewsListView: View {
    
    @StateObject private var vm : NewsListVM
    
    init(topic:String) {
        self._vm = StateObject(wrappedValue: NewsListVM(topic: topic))
    }
    var body: some View {
        Text("\(vm.topic.capitalized)")
        
        List(vm.articles, id:\.self.url){
           article in
            
            NavigationLink(destination:{
                ArticleView(article: article)
            })
            {
                if article.urlToImage != nil {
                    AsyncImage(url: URL(string: article.urlToImage ?? "")){ image in
                        image.resizable().aspectRatio(contentMode:.fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                }
                else{
                    Text("No image")
                }
                Text(article.title ?? "")
                    .onAppear(){
                        if (self.vm.articles.last?.url == article.url){
                            Task {
                                do{
                                    try await vm.getArticlesFromAPI(category: vm.topic)
                                }
                                catch{
                                    print(error)
                                }
                            }
                            vm.page = vm.page + 1
                        }
                    }
                }
            }
            .onAppear {
                if vm.articles.isEmpty
                {
                    Task {
                        do{
                            try await vm.getArticlesFromAPI(category: vm.topic)
                        }
                        catch{
                            print(error)
                        }
                    }
                }
            }
        
    }
}

class NewsListVM : ObservableObject
{
    @Published var articles = [Article]()
    var response = [Response]()
    
    @Published var topic : String
    @Published var page: Int
    init(topic:String)
    {
        self.topic = topic
        self.page = 1
    }
    
    private let apiKey = "495edd9fde584ca08e182e5d02916dea"
    
    func getArticlesFromAPI(category:String) async throws
    {
        let articlesUrl = "https://newsapi.org/v2/top-headlines?category=\(category)&pageSize=15&page=\(page)&apiKey=\(apiKey)"
        
        let url = URL(string: articlesUrl)
        
        let (data,_) = try await URLSession.shared.data(from: url!)
        let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
        
        
        articles.append(contentsOf: decodedResponse.articles)
        if articles.count > 30
        {
            articles.removeFirst(15)
        }
    }
}
