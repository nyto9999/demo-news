import UIKit
import Resolver
import Foundation

class NewsView: UIViewController{
  
  // MARK: Feeds
  var news = [News]() {
    didSet {
      tableview.reloadData()
      spinner.stopAnimating()
    }
  }
  var images: [ImageRecord] = []
  var pendingOperations = PendingOperations()
  
  
  // MARK: Properties
  @Injected private var viewModel: NewsViewModel
  var dateFormatter = Constants.dateFormatter
  var lastContentOffset: CGFloat = 0
  let hstackTag =
  [1: "business", 2: "entertainment", 3: "general", 4: "health", 5: "science", 6: "sports", 7: "technology"]
  
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
    var tag = 1
    Constants.Category.allCases.forEach {
      let button = UIButton()
      button.setTitle("  \($0)  ", for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 24)
      button.tag = tag
      button.backgroundColor = .systemGray
      button.layer.cornerRadius = 5
      button.isUserInteractionEnabled = true
      button.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
      hstack.add(view: button)
      tag += 1
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
    
    spinner.startAnimating()
    
    Task.detached(priority: .medium) {
      try await self._fetchingNews(type: .default)
    }
  }
  
  @objc func tapped(sender: UIButton)  {
    
    Task.detached(priority: .medium) { [weak self] in
      let tag = await self?.hstackTag[sender.tag]
      try await self?._fetchingNews(type: .category(type: tag!))
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
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[hstack]-[tableview]|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[hstack]-(10)-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableview]|", options: [], metrics: nil, views: vd))
    
    categoryHstack.heightAnchor.constraint(equalTo: categoryHstack.widthAnchor, multiplier: 0.125).isActive = true
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  // MARK: Actions
  private func _fetchingNews(type: NewsType) async throws {
     
    //init
    self.news = [News]()
    self.images = [ImageRecord]()
    self.pendingOperations = PendingOperations()
    
    //fetch
    let newsFeed = try await viewModel.fetchingNewsFeed(type: type)
//    dump(newsFeed)
    //load news img
    newsFeed.forEach {
      let imageRecord = ImageRecord(key: $0.urlToImage ?? "", url: URL(string: $0.urlToImage ?? ""))
      
      DispatchQueue.main.async {
        self.images.append(imageRecord)
      }
      
    }
    
    //refresh
    DispatchQueue.main.async {
      self.news = newsFeed
    }
  }
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedNews = news[indexPath.row].url
    let vc = NewsWebView()
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


