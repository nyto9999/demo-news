import UIKit
import Combine
import Resolver
import Veximoji

class CountryListView: UIViewController{
  typealias countriesTuple = (flag: String, name: String)
  var array = [countriesTuple]()
  
  lazy var countries: [countriesTuple] = {
    
    for country in Constants.isoCountryCode.allCases {
      var tupple:countriesTuple
      tupple.name = country.rawValue
      tupple.flag =  Veximoji.country(code: tupple.name.uppercased())!
      
      array.append(tupple)
    }
    return array
  }()
  
  //layouts
  lazy var tableview:UITableView = {
    let tableview = UITableView(frame: view.frame)
    tableview.register(UITableViewCell.self, forCellReuseIdentifier: "countryList")
    return tableview
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableview)
    
    tableview.delegate = self
    tableview.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.title = "國家"
    
  }
 
}

extension CountryListView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countries.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "countryList", for: indexPath)
    let content = cell.defaultContentConfiguration()
    cell.contentConfiguration = _configure(content, with: indexPath)
    return cell
  }
  
  private func _configure(_ content: UIListContentConfiguration, with indexPath: IndexPath) -> UIListContentConfiguration {
    
    var content = content
 
    content.text = countries[indexPath.row].flag
    content.secondaryText = countries[indexPath.row].name
    
    return content
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let name = countries[indexPath.row].name
//    self.dismiss(animated: true)
    
    let vc = NewsView()
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
