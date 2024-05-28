//
//  NewsListViewController.swift
//  Task_3_UIKit
//
//  Created by Synergy on 17.05.24.
//

import UIKit

class NewsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var ArticleTV: UITableView!
    
    @IBOutlet weak var TopicLabel: UILabel!
    var topic:String = ""
    
    
    private let apiKey = "495edd9fde584ca08e182e5d02916dea"
    private var page = 1
    
    var articles = [Article](){
        didSet {
            DispatchQueue.main.async {
                self.TopicLabel.text = self.topic
                self.ArticleTV.reloadData()
                print(self.articles.count)
            }
            print("Articles changed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ArticleTV.dequeueReusableCell(withIdentifier: "cellInNewsList", for: indexPath) as! ArticleViewCell
        
        
        let article = articles[indexPath.row]
        
        cell.articleTitle.text = article.title
        cell.setImage(from: article.urlToImage ?? "")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toArticleView", sender: articles[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == articles.count - 1
        {
            page = page + 1
            fetchArticles()
//
//            let middleIndexPath = IndexPath(row: articles.count / 2, section: 0)
//            tableView.scrollToRow(at: middleIndexPath, at: .middle, animated: true)
        }
    }
    
    func fetchArticles()
    {
        Task {
            do {
                try await getArticlesFromAPI(category: topic)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchArticles()
        
        print(topic)
        TopicLabel.text = topic
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleView"
        {
            if let destVC = segue.destination as? ArticleViewController{
                if let selectedArticle = sender as? Article{
                    destVC.article = selectedArticle
                }
            }
        }
    }
    
    func getArticlesFromAPI(category:String) async throws
    {
        
        let articlesUrl = "https://newsapi.org/v2/top-headlines?category=\(category)&pageSize=15&page=\(page)&apiKey=\(apiKey)"
        
        let url = URL(string: articlesUrl)
        
        let (data,_) = try await URLSession.shared.data(from: url!)
        let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
        
        
        articles.append(contentsOf: decodedResponse.articles)
//        if articles.count > 30
//        {
//            articles.removeFirst(15)
//        }
    }
    
    
    
}
class ArticleViewCell : UITableViewCell{
   
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    private var currentDownloadTask: URLSessionDataTask?
    
    override func prepareForReuse() {
            super.prepareForReuse()
            currentDownloadTask?.cancel()
            currentDownloadTask = nil
            articleImage.image = nil
        }
    
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            currentDownloadTask = URLSession.shared.dataTask(with: url) {data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to download image: \(String(describing: error))")
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
            currentDownloadTask?.resume()
        }

        func setImage(from urlString: String) {
            guard let url = URL(string: urlString) else {
                print("Invalid URL string")
                return
            }
            
            downloadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                
                if self.currentDownloadTask != nil {
                    if let image = image {
                        print("Image downloaded successfully")
                        self.articleImage.image = image
                    } else {
                        print("Failed to load image")
                    }
                }
            }
        }
}
