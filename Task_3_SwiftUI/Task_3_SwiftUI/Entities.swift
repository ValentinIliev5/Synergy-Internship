//
//  Entities.swift
//  Task_3_SwiftUI
//
//  Created by Synergy on 16.05.24.
//

import Foundation

struct Article : Codable
{
    
    let source: SourceForArticle
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
}

struct SourceForArticle: Codable
{
    let id:String?
    let name:String?
}

struct Response : Codable
{
    let status: String?
    let totalResults: Int
    let articles: [Article]
}
