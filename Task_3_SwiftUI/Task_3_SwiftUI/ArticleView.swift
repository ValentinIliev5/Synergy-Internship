//
//  ArticleView.swift
//  Task_3_SwiftUI
//
//  Created by Synergy on 16.05.24.
//

import SwiftUI

struct ArticleView: View {
    
    @StateObject var vm : ArticleVM
    
    init(article:Article)
    {
        self._vm = StateObject(wrappedValue: ArticleVM(article:article))
    }
    var body: some View {
        
        Text("\(vm.article.title ?? "")").font(.title2)
        Text("Author: \(vm.article.author ?? "Unknown")").font(.caption)
        
        if vm.article.urlToImage != nil {
            AsyncImage(url: URL(string: vm.article.urlToImage ?? "")){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }
        Text(vm.article.description ?? "Description").font(.caption2)
        Text(vm.article.content ?? "Some content").font(.body)
        
            .toolbar {
                ToolbarItem{
                    Link("Open in web",destination:URL(string: vm.article.url ?? "")!)
                }
            }
    }
}


class ArticleVM : ObservableObject
{
    let preferences = UserDefaults.standard

    let articlesCountKey = "articlesCount"

    var articlesCountValue = 0

    @Published var article: Article
    
    init(article:Article){
        
        self.article = article
        if preferences.object(forKey: articlesCountKey ) == nil
        {
            preferences.setValue(0, forKey: articlesCountKey)
        }
        articlesCountValue = preferences.integer(forKey: articlesCountKey) + 1
        
        preferences.setValue(articlesCountValue, forKey: articlesCountKey)
    }
}
