//
//  ViewController.swift
//  Task_3_UIKit
//
//  Created by Synergy on 17.05.24.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var TopicsTV: UITableView!
    @IBOutlet weak var pagesReadLabel: UILabel!
    
    let articlesCountKey = "articlesCount"
    var articlesCountValue = 0
    
    var topics : [String] = ["business","entertainment","science","health","sports","technology","general"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = topics[indexPath.row]
        
        let cell = TopicsTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = topic.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        performSegue(withIdentifier: "toNewsListController", sender: topics[indexPath.row].capitalized)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsListController"
        {
            if let destVC = segue.destination as? NewsListViewController{
                if let selectedTopic = sender as? String{
                    destVC.topic = selectedTopic
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News List"
        updateArticlesCountLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            updateArticlesCountLabel()
        }
    func updateArticlesCountLabel() {
            let preferences = UserDefaults.standard

            let articlesCountValue = preferences.integer(forKey: articlesCountKey)

            preferences.set(articlesCountValue, forKey: articlesCountKey)

            pagesReadLabel.text = "Articles read: \(articlesCountValue)"
        }
}

