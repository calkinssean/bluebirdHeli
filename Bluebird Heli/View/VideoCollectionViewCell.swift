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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var webView: WKWebView!
    
    var mediaItem: Media? {
        didSet {
            if let mediaItem = mediaItem {
                
                let configuration = WKWebViewConfiguration()
                configuration.allowsInlineMediaPlayback = false
                webView = WKWebView(frame: self.frame, configuration: configuration)
                webView.translatesAutoresizingMaskIntoConstraints = false
                playButton.isHidden = true
                webView.uiDelegate = self
                webView.navigationDelegate = self
                webView.allowsBackForwardNavigationGestures = false
                guard let youtubeURL = URL(string: mediaItem.url) else { return }
                addSubview(webView)
                webView.isHidden = true
                webView.load(URLRequest(url: youtubeURL))

               // if let data = mediaItem.data {
           //         imageView.image = UIImage(data: data)
                    
              //  }
            }
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        if let mediaItem = mediaItem {
            spinner.startAnimating()
         
        }
    }
    
}

extension VideoCollectionViewCell: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        print("didClose")
        imageView.isHidden = false
        playButton.isHidden = false
        webView.isHidden = true
    }
    
}

extension VideoCollectionViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        imageView.isHidden = true
        webView.isHidden = false
    }
    
}

