import UIKit
import Resolver
import Combine
import UIKit

class SearchView: UIViewController {
   
  // MARK: Properties
  @Injected var viewModel: NewsViewModel
  var subscriptions = Set<AnyCancellable>()
  
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
    view.addSubview(tableview)
  }
  private func _setupConstraints() {
    let vd = [
      "tableview" : tableview
    ]
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[tableview]-|", options: [], metrics: nil, views: vd))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[tableview]-(10)-|", options: [], metrics: nil, views: vd))
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
    viewModel.search(searchText: "trump")
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
      } receiveValue: { news in
        print(news)
      }.store(in: &subscriptions)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
  }
}

// MARK: tableview delegates
extension SearchView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableview.dequeueReusableCell(withIdentifier: NewsCell.id, for: indexPath) as! NewsCell
    return cell
  }
}


