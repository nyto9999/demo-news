import UIKit
import WebKit

class NewsDetail: UIViewController, WKNavigationDelegate {
  var link = ""
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var webview: WKWebView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    webview.load(URLRequest(url: URL(string: link)!))
    webview.navigationDelegate = self
    
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    spinner.startAnimating()
  }
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    spinner.stopAnimating()
  }
}

