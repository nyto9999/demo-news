import UIKit
import Combine
import Swinject

class NewsView: UIViewController{
  
  @IBOutlet var tableview: UITableView!
  
  
  let viewModel = NewsViewModel()
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    viewModel.News()
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
        self.tableview.reloadData()
      } receiveValue: { news in
        self.news = news
      }
      .store(in: &subscriptions)

  }
  
  //Segue
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
          if let cell = sender as? UITableViewCell {
              let i = self.tableview.indexPath(for: cell)!.row
              if segue.identifier == "toNewsDetail" {
                  let vc = segue.destination as! NewsDetail
                vc.link = self.news[i].url
              }
          }
      }
}

extension NewsView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    
    let publishedAt = news[indexPath.row].publishedAt
    let dateString = dateFormatter.date(from: publishedAt)
    
    content.text = news[indexPath.row].title
    content.secondaryText = dateString!.formatted(date: .complete, time: .shortened)
    
    content.textToSecondaryTextVerticalPadding = CGFloat(40.0)
    cell.contentConfiguration = content
    return cell
  }
}

