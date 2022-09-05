//
//  WebVC.swift
//  Project4
//
//  Created by Mymac on 5/9/2022.
//  Copyright © 2022 Paul Hudson. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController,WKNavigationDelegate {
    @IBOutlet var webView: WKWebView!
    var progressView: UIProgressView!

    var websites : [String] = []
    var web : String?

//    override func loadView() {
//        webView = WKWebView()
//
//        view = webView
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: "https://" + web!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "<<", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: ">>",style: .plain, target: webView, action: #selector(webView.goForward))

        toolbarItems = [back,forward,progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false

        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)

        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host{
            for website in websites {
                if (host.contains(website)) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        let ac = UIAlertController(title: "Alert!!", message: "It's Blocked", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
        

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

}
