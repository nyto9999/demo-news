import UIKit
import Resolver
import Foundation

class NewsView: UIViewController{
   
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
  @Injected private var viewModel: NewsViewModel
  var dateFormatter = Constants.dateFormatter
  var lastContentOffset: CGFloat = 0
   
  // MARK: Layouts
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
  
  lazy var categoryHstack:NewsViewHstack = {
    let hstack = NewsViewHstack()
    Constants.Category.allCases.forEach {
      let label = UILabel()
      label.text = "\($0)"
      label.font = label.font.withSize(28)
      label.backgroundColor = .systemGray6
      label.layer.masksToBounds = true
      label.layer.cornerRadius = 5
      hstack.add(view: label)
    }
    hstack.showsHorizontalScrollIndicator = false
    return hstack
  }()
 
  // MARK: Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
   
  // MARK: UI
  private func _setupViews() {
    navigationItem.title = "頭條新聞"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27),NSAttributedString.Key.foregroundColor: UIColor.darkText]
    
    view.addSubview(tableview)
    view.addSubview(categoryHstack)
    view.addSubview(spinner)
  }
  private func _setupConstraints() {
    let vd = [
      "hstack" : categoryHstack,
      "tableview": tableview,
      "spinner" : spinner]
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[hstack]-[tableview]-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[hstack]-(10)-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tableview]-(10)-|", options: [], metrics: nil, views: vd))
    categoryHstack.heightAnchor.constraint(equalTo: categoryHstack.widthAnchor, multiplier: 0.125).isActive = true
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
   
  // MARK: Actions
  private func _fetchingNews() async throws {
    do {
      let newsFeed = try await viewModel.fetchingNewsFeed(type: .default)
      self.news = newsFeed.news
      self.images = newsFeed.images
    }
    catch {
      print(error)
    }
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
}

//MARK: tableview delegates
extension NewsView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsDetail()
    vc.link = selectedNews
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //MARK: scrollview delegates
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if lastContentOffset < scrollView.contentOffset.y {
        // did move up
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    } else if lastContentOffset > scrollView.contentOffset.y {
        // did move down
        self.navigationController?.setNavigationBarHidden(false, animated: false)
       
    } else if tableview.contentOffset.y >= (tableview.contentSize.height - tableview.frame.size.height) {
        // end
      //fetch history
    }
    else {
      // did move
    }
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      self.lastContentOffset = scrollView.contentOffset.y
  }
}

 
