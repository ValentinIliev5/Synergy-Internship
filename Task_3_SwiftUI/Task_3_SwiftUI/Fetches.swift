//
//  Fetches.swift
//  Task_3_SwiftUI
//
//  Created by Synergy on 16.05.24.
//

import Foundation

class WEB
{
    let apiKey = "802209ecc07b41ceaab7b2e755ae32f4"
    
    
    func getArticlesFromAPI(category:String) async throws -> [Article]
    {
        let articlesUrl = "https://newsapi.org/v2/top-headlines?category=\(category)&apiKey=\(apiKey)"
        
        let url = URL(string: articlesUrl)
        
        let (data,_) = try await URLSession.shared.data(from: url!)
        let decoded = try JSONDecoder().decode(ArticleResults.self, from: data)
        
        return decoded.results
    }
}
