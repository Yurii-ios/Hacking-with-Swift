//
//  DetailWebViewViewController.swift
//  Project16
//
//  Created by Yurii Sameliuk on 24/05/2020.
//  Copyright © 2020 Yurii Sameliuk. All rights reserved.
//

import UIKit
import WebKit
class DetailWebViewViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ""
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
        navigationController?.isToolbarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string:"https://ru.wikipedia.org/wiki/\(websites)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        progressView = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
               toolbarItems = [progressButton]
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}
