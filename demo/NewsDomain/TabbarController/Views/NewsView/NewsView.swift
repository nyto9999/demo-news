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
  var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    return df
  }
  let category = ["  財經  ", "  娛樂  ", "  大眾  ", "  醫療  ", "  自然  ", "  體育  ", "  科技  "]
  
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
  
  lazy var scrollableStackView:ScrollableStackView = {
    let view = ScrollableStackView()
    
    category.forEach {
      let label = UILabel()
      label.text = $0
      label.font = label.font.withSize(28)
      label.backgroundColor = .systemGray6
      label.layer.masksToBounds = true
      label.layer.cornerRadius = 5
      
      view.add(view: label)
    }
    view.showsHorizontalScrollIndicator = false
    return view
  }()
    
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _setupViews()
    _setupConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.topViewController?.navigationItem.titleView = nil
    self.navigationController?.topViewController?.navigationItem.title = "頭條新聞"
    
    spinner.startAnimating()
    
    //    manager.fileExists(atPath: manager.backupFilePath()!.path) ?
    //    loadBackupNews() :
    
    Task.detached(priority: .medium) {
      try await self._fetchingNews()
    }
  }
  
  private func _setupViews() {
    tableview.delegate        = self
    tableview.dataSource      = self
     
    view.addSubview(scrollableStackView)
    view.addSubview(tableview)
    view.addSubview(spinner)
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
          let imgData = try await self.downloadImage(urlString: news[index].urlToImage)
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
  
  func downloadImage(urlString: String?) async throws -> Data? {
    
    guard let urlString = urlString,
          let url = URL(string: urlString)
    else { return Data() }
    
    return try await URLSession.shared.data(from: url).0
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
  
  private func _setupConstraints() {
    scrollableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollableStackView.heightAnchor.constraint(equalTo: scrollableStackView.widthAnchor, multiplier: 0.125).isActive = true
    
    tableview.topAnchor.constraint(equalTo: scrollableStackView.bottomAnchor).isActive = true
    tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    
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
 
