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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.title = "頭條新聞"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupViews()
    _setupConstraints()
    spinner.startAnimating()
    
//    manager.fileExists(atPath: manager.backupFilePath()!.path) ?
//    loadBackupNews() :
    
    Task.detached(priority: .medium) {
      try await self._fetchingNews()
    }
  }
  
  //fetching from network
  private func _fetchingNews() async throws {
    print("fetching network news.....")
    let imageData = await newsPublisher()
    try await self._downloadAllImages(for: imageData)
  }
  
  private func newsPublisher() async -> [News] {
    return await withCheckedContinuation { continuation in
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
          self.spinner.stopAnimating()
        }
        .store(in: &subscriptions)
    }
  }
  
  private func _downloadAllImages(for news: [News]) async throws {
    var dict = [Int:Data]()
    let taskResult = (index: Int, image: Data?).self
    
    //async
    try await withThrowingTaskGroup(of: taskResult) { [unowned self] group in
      //concurrent
      for index in 0..<news.count {
        group.addTask {
          let imgData = try await self.downloadImage(url: news[index].urlToImage)
          return (index, imgData)
        }
      }
      
      //async wait for concurrent
      for try await newsArray in group {
        dict[newsArray.index] = newsArray.image
      }
    }
    
    self.imageDict = dict
    self.news = news
    DispatchQueue.main.async {
      self.tableview.reloadData()
    }
  }
  
  func downloadImage(url: String?) async throws -> Data? {
    return (url != nil) ?
    try await URLSession.shared.data(from: URL(string: url!)!).0 : Data()
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
   
  private func _setupViews() {
    view.addSubview(tableview)
    view.addSubview(spinner)
    
    tableview.delegate = self
    tableview.dataSource = self
  }
  
  private func _setupConstraints() {
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
    
    cell.configure(text: item.title, author: (item.author != nil) ? "來源：\(item.author!)" : "", data: imageDict[indexPath.row] ?? Data(), date: date)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsDetail()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
}