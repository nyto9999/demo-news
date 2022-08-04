import UIKit
import WebKit

class NewsDetail: UIViewController {
  
  // MARK: Properties
  var link = ""
  
  // MARK: Layouts
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
   
  // MARK: Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _setupViews()
    _setupConstraint()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: UI
  private func _setupViews() {
    webview.navigationDelegate = self
    view = webview
    view.addSubview(spinner)
  }
  private func _setupConstraint() {
    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}

// MARK: WKWebView delegate
extension NewsDetail: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    spinner.startAnimating()
  }
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    spinner.stopAnimating()
  }
}
