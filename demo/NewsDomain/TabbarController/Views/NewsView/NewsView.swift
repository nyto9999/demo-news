import UIKit
import Combine
import Resolver
import Foundation

class NewsView: UIViewController{
  
  //properties
  @Injected private var viewModel: NewsViewModel
  var dateFormatter = Constants.dateFormatter
  var subscriptions = Set<AnyCancellable>()
  var news = [News]()
  var imageDict = [Int:Data]() {
    didSet {
      self.tableview.reloadData()
      self.spinner.stopAnimating()
    }
  }
  
  //layouts
  lazy var tableview:UITableView = {
    let tableview = UITableView()
    tableview.register(NewsCellView.self, forCellReuseIdentifier: NewsCellView.id)
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
  
  lazy var categoryHstack:ScrollableStackView = {
    let view = ScrollableStackView()
    Constants.Category.allCases.forEach {
      let label = UILabel()
      label.text = "\($0)"
      label.font = label.font.withSize(28)
      label.backgroundColor = .systemGray6
      label.layer.masksToBounds = true
      label.layer.cornerRadius = 5
      view.add(view: label)
    }
    view.showsHorizontalScrollIndicator = false
    return view
  }()
  
  private lazy var searchBar: UISearchBar = {
    let sb = UISearchBar()
    sb.placeholder = "Search"
    sb.showsCancelButton = false
    sb.delegate = self
    return sb
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //    self.navigationController?.navigationBar.topItem?.searchController = searchController
    //    self.navigationController?.topViewController?.navigationItem.searchController = searchController
    self.navigationController?.topViewController?.navigationItem.titleView = searchBar
    _setupViews()
    _setupConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    manager.fileExists(atPath: manager.backupFilePath()!.path) ?
    //    loadBackupNews() :
    spinner.startAnimating()
    Task.detached(priority: .medium) {
      try await self._fetchingNews()
    }
    
  }
  
  private func _setupViews() {
    view.addSubview(categoryHstack)
    view.addSubview(tableview)
    view.addSubview(spinner)
  }
  
  //fetching from network
  private func _fetchingNews() async throws {
    let newsFeed = try await viewModel.fetchingNewsAndImageData()
    self.news = newsFeed.news
    self.imageDict = newsFeed.ImageData
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
    
    categoryHstack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    categoryHstack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    categoryHstack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    categoryHstack.heightAnchor.constraint(equalTo: categoryHstack.widthAnchor, multiplier: 0.125).isActive = true
    
    tableview.topAnchor.constraint(equalTo: categoryHstack.bottomAnchor).isActive = true
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

extension NewsView: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    Task.detached() {
      print("hhihihi")
      await self.viewModel.search(searchText: searchBar.text ?? "")
        
    }
    print("done")
  }
}

