//
//  VideoCollectionViewCell.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/23/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit
import WebKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var webView: WKWebView!
    
    var mediaItem: Media? {
        didSet {
            if let mediaItem = mediaItem {
                spinner.startAnimating()
                webView = createWebView()
                guard let youtubeURL = URL(string: mediaItem.url) else { return }
                addSubview(webView)
                webView.isHidden = true
                webView.load(URLRequest(url: youtubeURL))
            }
        }
    }
    
    func createWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let wkWebView = WKWebView(frame: self.frame, configuration: configuration)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.contentMode = .scaleAspectFit
        wkWebView.navigationDelegate = self
        wkWebView.allowsBackForwardNavigationGestures = false
        return wkWebView
    }
    
}

extension VideoCollectionViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        webView.isHidden = false
    }
    
}

