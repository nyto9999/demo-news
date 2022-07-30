import UIKit
import Combine
import Resolver

class RegionView: UIViewController{
  
  var news = [News]()
  var subscriptions = Set<AnyCancellable>()
  
  //layouts
  lazy var tableview:UITableView = {
    let tableview = UITableView(frame: view.frame)
    tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return tableview
  }()
  var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    return df
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableview)
    self.navigationController?.title = "News"
    tableview.delegate = self
    tableview.dataSource = self
  }
 
}

extension RegionView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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

