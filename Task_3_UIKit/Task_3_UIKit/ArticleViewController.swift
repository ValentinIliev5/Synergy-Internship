//
//  ArticleViewController.swift
//  Task_3_UIKit
//
//  Created by Synergy on 17.05.24.
//

import UIKit
import SafariServices

class ArticleViewController: UIViewController {

    var article : Article?
    @IBOutlet weak var ArticleImage: UIImageView!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var TopLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage(from:article?.urlToImage ?? "")
        
        
        contentLabel.lineBreakMode = .byWordWrapping
        
        TopLabel.text = article?.title ?? "Title"
        subtextLabel.text = article?.author ?? "Author"
        contentLabel.text = article?.content ?? "Content"
        
        
        let preferences = UserDefaults.standard
        let articlesCountKey = "articlesCount"
        
        if preferences.object(forKey: articlesCountKey ) == nil
        {
            preferences.setValue(0, forKey: articlesCountKey)
        }
        var articlesCountValue = preferences.integer(forKey: articlesCountKey) + 1
        
        preferences.setValue(articlesCountValue, forKey: articlesCountKey)
        
    }
    
    @IBAction func OpenInWebOnClick(_ sender: Any) {
        guard let urlString = article?.url else {
                    return
                }
                
        if let url = URL(string: urlString) {
                    let safariViewController = SFSafariViewController(url: url)
                    present(safariViewController, animated: true, completion: nil)
                }
    }
    
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to download image: \(String(describing: error))")
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }.resume()
        }

    func setImage(from urlString: String) {
            guard let url = URL(string: urlString) else {
                print("Invalid URL string")
                return
            }

            downloadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    print("Image downloaded successfully")
                    self.ArticleImage.image = image
                } else {
                    print("Failed to load image")
                }
            }
        }
}
