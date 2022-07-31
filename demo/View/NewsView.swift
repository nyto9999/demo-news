import UIKit
import Combine
import Resolver
 
class NewsView: UIViewController{
  
  //properties
  @Injected private var viewModel: NewsViewModel
  var news = [News]()
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
    
    
    manager.fileExists(atPath: manager.backupFilePath()!.path) ?
    loadBackupNews() :
    fetchingNews()
    
  }
  
  //loading from local
  private func loadBackupNews() {
    print("loading local news.....")
    Task(priority: .medium) {
      self.news = try await viewModel.loadBackupNews()
      self.tableview.reloadData()
      self.spinner.stopAnimating()
    }
  }
  
  //fetching from network
  private func fetchingNews() {
    print("fetching network news.....")
    viewModel.newsTopHeadlines()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
          case .finished:
            self.tableview.reloadData()
          case .failure:
            self.tableview.isHidden = true
        }
      } receiveValue: { news in
        self.news = news
        self.spinner.stopAnimating()
      }
      .store(in: &subscriptions)
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
    
    cell.configure(text: item.title, author: "Author: \(item.author ?? "")", date: date)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsDetail()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

