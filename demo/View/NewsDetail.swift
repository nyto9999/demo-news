import UIKit
import WebKit

class NewsDetail: UIViewController, WKUIDelegate {
  var link : String = ""
  @IBOutlet weak var webview: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let myURL = URL(string:"\(link)")
    let myRequest = URLRequest(url: myURL!)
    webview.load(myRequest)
  }
  
  override func loadView() {
    webview.uiDelegate = self
    view = webview
  }
}
