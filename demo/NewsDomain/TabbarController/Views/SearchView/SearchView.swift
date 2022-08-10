import UIKit
import Resolver

class SearchView: UIViewController {
  
  // MARK: Feeds
  var news = [News]() {
    didSet {
      tableview.reloadData()
      spinner.stopAnimating()
    }
  }
  var images: [ImageRecord] = []
  var pendingOperations = PendingOperations()
  var searchable = false
  // MARK: Properties
  @Injected var viewModel: NewsViewModel
  var dateFormatter = Constants.dateFormatter
  
  
  // MARK: Layouts
  let searbar = UISearchBar()
  
  lazy var tableview:UITableView = {
    let tableview = UITableView()
    tableview.register(NewsCell.self, forCellReuseIdentifier: NewsCell.id)
    tableview.delegate        = self
    tableview.dataSource      = self
    tableview.translatesAutoresizingMaskIntoConstraints = false
    return tableview
  }()
  
  var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
  }()
  
  // MARK: Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    _setupViews()
    _setupConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
   
  // MARK: UI
  private func _setupViews() {
    navigationItem.titleView = searbar
    searbar.delegate = self
    view.backgroundColor = .white
    view.addSubview(spinner)
    view.addSubview(tableview)
  }
  private func _setupConstraints() {
    let vd = [
      "tableview" : tableview,
      "spinner"   : spinner
    ]
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[tableview]-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tableview]-(10)-|", options: [], metrics: nil, views: vd))
    
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

// MARK: searchbar delegates
extension SearchView: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    Task(priority: .medium) {
      let newsFeed = try await viewModel.fetchingNewsFeed(type: .search(searchText: searchBar.text!))
      newsFeed.forEach {
        let imageRecord = ImageRecord(key: $0.urlToImage ?? "", url: URL(string: $0.urlToImage ?? ""))
        images.append(imageRecord)
      }
      //init
      self.news = newsFeed
      self.searbar.endEditing(true)
      self.searchable = true
    }
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchable {
      //inti
      self.news.removeAll()
      self.images.removeAll()
      self.pendingOperations.downloadsInProgress.removeAll()
      self.tableview.reloadData()
    }
  }
}

// MARK: tableview delegates
extension SearchView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsWebView()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let news = news[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.id, for: indexPath) as! NewsCell
    let dateString = dateFormatter.date(from: news.publishedAt)
    let date = dateString!.formatted(date: .complete, time: .shortened)
 
    let imageDetails = images[indexPath.row]
 
    //cell config
    cell.configure(text: news.title, author: (news.author != nil) ? "來源：\(news.author!)" : "", image: imageDetails.image , date: date)
    
    switch imageDetails.state {
      case .new, .downloaded:
        startOperations(for: imageDetails, at: indexPath)
      case .failed:
        print("fail")
    }
    return cell
  }
  
  //MARK: ImageOperation
  func startOperations(for imageRecord: ImageRecord, at indexPath: IndexPath) {
    switch (imageRecord.state) {
    case .new:
      startDownload(for: imageRecord, at: indexPath)
    default:
        break
    }
  }
  
  func startDownload(for imageRecord: ImageRecord, at indexPath: IndexPath) {
    guard pendingOperations.downloadsInProgress[indexPath] == nil else {
      return
    }
    let downloader = ImageDownloader(imageRecord)
    
    downloader.completionBlock = {
      print("downloader completed")
      if downloader.isCancelled {
        return
      }
      DispatchQueue.main.async {
        self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
        self.tableview.reloadRows(at: [indexPath], with: .fade)
      }
    }
    pendingOperations.downloadsInProgress[indexPath] = downloader
    pendingOperations.downloadQueue.addOperation(downloader)
  }
}


