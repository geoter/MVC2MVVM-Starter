//
//  ViewController.swift
//  DailyNews-MVCTutorial
//
//  Created by Damla Çim on 5.07.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private variables
    private var articles: [Article]?
    private var selectIndex = 0
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Setup functions
    private func setup() {
        setupTableView()
        fetchData()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Functions
    private func fetchData() {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2025-02-11&sortBy=publishedAt&apiKey=bec60be278634a9f9b681d532eed3596") else {
            return
        }
        self.alert()
        WebService().getArticles(url: url) { [weak self] articles in
            if let articles = articles {
                self?.articles = articles
                print(articles)
                self?.reloadTableView()
            }
        }
    }
    
    private func alert() {
        let alertController = UIAlertController(title: "Warning!", message: "No response from API. The news is loading.", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: Extensions
extension ArticleViewController {
 
    // MARK: Functions
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func articleIndex(_ index: Int) -> Article {
        guard let article = self.articles?[index] else {
            return Article(source: nil, author: nil, title: "", description: "", url: "", urlToImage: "", publishedAt: "", content: nil)
        }
        return article
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell",for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell not found")
        }
        let articleIndex = self.articleIndex(indexPath.row)
        cell.titleLabel.text = articleIndex.title
        cell.descriptionLabel.text = articleIndex.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectIndex = indexPath.row
        print(selectIndex)
        //performSegue(withIdentifier: "detail", sender: self) -> 1st way using segues, calles prepare(for segue)
        //2nd way
        showArticleDetails(for: self.articleIndex(selectIndex))
    }
    
    private func showArticleDetails(for article: Article) {
        guard let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? DetailViewController else { return }
        detailsVC.articles = article
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let detailViewController = segue.destination as? DetailViewController {
//            let articleVM = self.articleIndex(selectIndex)
//            detailViewController.articles = articleVM
//            print(articleVM)
//        }
//    }
}




