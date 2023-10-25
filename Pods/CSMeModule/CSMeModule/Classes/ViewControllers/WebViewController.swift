//
//  WebViewController.swift
//  CSMeModule
//
//  Created by 于冬冬 on 2023/6/5.
//

import Foundation
import CSBaseView
import WebKit

class WebViewController: BaseViewController {
    
    let url: URL?
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    override var backgroundType: BackgroundType {
        return .dark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let webView = WKWebView(frame: view.bounds)
            view.addSubview(webView)
            webView.snp.makeConstraints { make in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            self.emptyStyle = .noInternet("")
        }
    }
}
