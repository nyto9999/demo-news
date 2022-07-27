import UIKit
import Combine
import Resolver

class NewsView: UIViewController{
  
  @IBOutlet var tableview: UITableView!
  
  @Injected private var viewModel: NewsViewModel
  var news = [News]()
  var subscriptions = Set<AnyCancellable>()
  
  var dateFormatter: DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "UTC")
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
    return df
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.delegate = self
    tableview.dataSource = self
    
    viewModel.search(searchText: "獵人")
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
      }
      .store(in: &subscriptions)
  }
   
  //Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let indexPath = tableview.indexPathForSelectedRow {
      let vc = segue.destination as! NewsDetail
      vc.link = self.news[indexPath.row].url
    }
  }
}

extension NewsView: UITableViewDelegate, UITableViewDataSource {
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
}

