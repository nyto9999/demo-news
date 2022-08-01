import UIKit
import WebKit

class NewsDetail: UIViewController {
  
  //properties
  var link = ""
  
  //layouts
  lazy var webview:WKWebView = {
    let webview = WKWebView()
    let url = URL(string: link)!
    webview.load(URLRequest(url: url))
    webview.allowsLinkPreview = true
    webview.allowsBackForwardNavigationGestures = true
    return webview
  }()
  
  var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  //constraints
  private func _setupConstraint() {
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webview.navigationDelegate = self
    view = webview
    view.addSubview(spinner)
    _setupConstraint()
  }
}

extension NewsDetail: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    spinner.startAnimating()
  }
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    spinner.stopAnimating()
  }
}
