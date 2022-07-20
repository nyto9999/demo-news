import UIKit
import Combine
import Swinject

class NewsView: UIViewController {
  
  @IBOutlet var tableview: UITableView!
  var subscriptions = Set<AnyCancellable>()
  
  let viewModel = NewsViewModel()
  var news = News()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.delegate = self
    tableview.dataSource = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    viewModel.decodeNews()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: {
          print("Completion: \($0)")
          self.tableview.reloadData()
        },
        receiveValue: {
          self.news = $0
        })
      .store(in: &subscriptions)
  }
}

extension NewsView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return news.articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = news.articles[indexPath.row].title
    content.secondaryText = news.articles[indexPath.row].author
    content.image = UIImage(systemName: "circle")
    cell.contentConfiguration = content
    return cell
  }
}

