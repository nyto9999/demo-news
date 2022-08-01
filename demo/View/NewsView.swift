import UIKit
import Combine
import Resolver
import Foundation
 
class NewsView: UIViewController{
  
  //properties
  @Injected private var viewModel: NewsViewModel
  var news = [News]()
  var imageDict = [Int:Data]()
  let manager = FileManager()
  var subscriptions = Set<AnyCancellable>()
  
  //layouts
  lazy var tableview:UITableView = {
    let tableview = UITableView(frame: view.frame)
    tableview.register(NewsCellView.self, forCellReuseIdentifier: NewsCellView.id)
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    return df
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    spinner.startAnimating()
    
    
//    manager.fileExists(atPath: manager.backupFilePath()!.path) ?
//    loadBackupNews() :
    Task(priority: .medium) {
      try await self.fetchingNews()
    }
  }
  
  func downloadAllImages(news: [News]) async throws {
    
    var dict = [Int:Data]()
    
    try await withThrowingTaskGroup(of: (Int, Data).self) { [unowned self] group in
      for index in 0..<news.count {
        group.addTask {
          let data = try await self.downloadImage(url: self.news[index].urlToImage ?? "")
          return (index, data)
        }
      }
      
      for try await imageData in group {
        dict[imageData.0] = imageData.1
      }
    }
    
    DispatchQueue.main.async {
      self.tableview.reloadData()
      self.imageDict = dict
    }
  }
  
  func downloadImage(url: String) async throws -> Data {
    return try await URLSession.shared.data(from: URL(string: url)!).0
  }
  
  
  
  //loading from local
//  private func loadBackupNews() {
//    print("loading local news.....")
//    Task(priority: .medium) {
//      self.news = try await viewModel.loadBackupNews()
//      self.tableview.reloadData()
//      self.spinner.stopAnimating()
//    }
//  }
  
  //fetching from network
  private func fetchingNews() async throws{
    print("fetching network news.....")
    
    let images: [News] = try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self = self else { return }
      viewModel.newsTopHeadlines()
        .receive(on: DispatchQueue.main)
        .sink {completion in
          switch completion {
            case .finished:
              
              self.tableview.reloadData()
            case .failure:
              self.tableview.isHidden = true
          }
        } receiveValue: { value in
          continuation.resume(returning: value)
          self.news = value
          self.spinner.stopAnimating()
        }
        .store(in: &subscriptions)
    }
    try await self.downloadAllImages(news: images)
  }

  private func setupViews() {
    view.addSubview(tableview)
    view.addSubview(spinner)
    
    tableview.delegate = self
    tableview.dataSource = self
  }
  
  private func setupConstraints() {
    tableview.frame = view.bounds
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

extension NewsView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = news[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellView.id, for: indexPath) as! NewsCellView
    let dateString = dateFormatter.date(from: item.publishedAt)
    let date = dateString!.formatted(date: .complete, time: .shortened)
    
    cell.configure(text: item.title, author: "Author: \(item.author ?? "")", data: imageDict[indexPath.row] ?? Data(), date: date)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsDetail()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

