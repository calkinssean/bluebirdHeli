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
    
    @IBOutlet var webView: WKWebView!
    
    func setupCell(with mediaItem: Media) {
        guard mediaItem.mediaType == .Video else { return }
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsLinkPreview = true
        guard let youtubeURL = URL(string: mediaItem.url) else { return }
        webView.load(URLRequest(url: youtubeURL) )
    }
    
}
