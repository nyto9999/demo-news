import UIKit
import Combine
import Resolver
 
class HeadlinesView: UIViewController{
  
  //properties
  @Injected private var viewModel: NewsViewModel
  var news = [News]()
  let manager = FileManager()
  var subscriptions = Set<AnyCancellable>()
  
  //layouts
  lazy var tableview:UITableView = {
    let tableview = UITableView(frame: view.frame)
    tableview.register(UITableViewCell.self, forCellReuseIdentifier: "headlines")
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
  
  private func loadBackupNews() {
    print("loading local news.....")
    Task(priority: .medium) {
      self.news = try await viewModel.loadBackupNews()
      self.tableview.reloadData()
    }
  }
  
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
    view = tableview
    view.addSubview(spinner)
    
    tableview.delegate = self
    tableview.dataSource = self
  }
  
  private func setupConstraints() {
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

extension HeadlinesView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "headlines", for: indexPath)
    let content = cell.defaultContentConfiguration()
    cell.contentConfiguration = configure(content, with: indexPath)
    return cell
  }
  
  private func configure(_ content: UIListContentConfiguration, with indexPath: IndexPath) -> UIListContentConfiguration {
    
    var content = content
    let publishedAt = news[indexPath.row].publishedAt
    let dateString = dateFormatter.date(from: publishedAt)
 
    content.text = news[indexPath.row].title
    content.secondaryText = dateString!.formatted(date: .complete, time: .shortened)
   
    content.textToSecondaryTextVerticalPadding = CGFloat(40.0)
    
    return content
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsDetail()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

