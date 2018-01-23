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
    @IBOutlet var webView: WKWebView!
    @IBOutlet var playButton: UIButton!
    
    var mediaItem: Media? {
        didSet {
            if let mediaItem = mediaItem {
                if let data = mediaItem.data {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        if let mediaItem = mediaItem {
            webView.allowsBackForwardNavigationGestures = false
            webView.allowsLinkPreview = true
            guard let youtubeURL = URL(string: mediaItem.url) else { return }
            webView.load(URLRequest(url: youtubeURL))
        }
    }

}

extension VideoCollectionViewCell: WKUIDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        imageView.isHidden = false
        playButton.isHidden = false
        webView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
}

extension VideoCollectionViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        imageView.isHidden = true
        playButton.isHidden = true
        webView.isHidden = false
    }
}

