//
//  CSBaseWebView.swift
//  AuthManagerKit
//
//  Created by li on 5/18/23.
//
import UIKit
import WebKit

class CSBaseWebViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let accessToken = message.body as? String {
                    // Handle the access token data here
                    print("Access token received: \(accessToken)")
                }
    }
    
    var webUrl:String?
    public required init(webUrl url: String?) {
        super.init(nibName: nil, bundle: nil)
        self.webUrl = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        
        let controller = WKUserContentController()
        controller.add(self, name: "callbackHandler")
        config.userContentController = controller

        webView = WKWebView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), configuration: config)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
//        webView.tintColor = .white
        
        let url = URL(string: self.webUrl ?? "")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    // WKNavigationDelegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
//        let color = "red"
//        let script = "var style = document.createElement('style'); style.innerHTML = 'header { color: \(color) }'; document.head.appendChild(style);"
//        webView.evaluateJavaScript(script, completionHandler: nil)

    }
}

