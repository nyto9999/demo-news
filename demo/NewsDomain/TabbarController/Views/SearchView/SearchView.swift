import UIKit
import Resolver
import Combine
import UIKit

class SearchView: UIViewController {
  // MARK: Feeds
  var news = [News]()
  var images = [Int:UIImage?]() {
    // news dependent on images
    didSet {
      tableview.reloadData()
      spinner.stopAnimating()
    }
  }
   
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
      "spinner" : spinner
    ]
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[tableview]-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tableview]-(10)-|", options: [], metrics: nil, views: vd))
    
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

// MARK: searchbar delegates
extension SearchView: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    print("begin edting")
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("end editing")
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    Task(priority: .medium) {
      let newsFeed = try await viewModel.fetchingNewsFeed(type: .search(searchText: searchBar.text!))
      self.news = newsFeed.news
      self.images = newsFeed.images
    }
  }
  
  
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
  }
}

// MARK: tableview delegates
extension SearchView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let news = news[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.id, for: indexPath) as! NewsCell
    let dateString = dateFormatter.date(from: news.publishedAt)
    let date = dateString!.formatted(date: .complete, time: .shortened)
 
    //cell config
    cell.configure(text: news.title, author: (news.author != nil) ? "來源：\(news.author!)" : "", image: images[indexPath.row]!, date: date)
    return cell
  }
}


