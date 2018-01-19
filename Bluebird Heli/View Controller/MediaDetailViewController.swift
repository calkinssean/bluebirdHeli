//
//  MediaDetailViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/18/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var toolbarIsShown = false
    var item = 0
    var mediaArray: [Media] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCollectionView() {
        let indexPath = IndexPath(item: item, section: 0)
        let width = view.frame.size.width
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.isPagingEnabled = true
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleToolBar))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func toggleToolBar() {
        if let hidden = navigationController?.isToolbarHidden {
            navigationController?.isToolbarHidden = !hidden
        }
    }
    
}

extension MediaDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        let mediaItem = mediaArray[indexPath.item]
        cell.imageView.image = UIImage(data: mediaItem.data)
        return cell
    }
    
}
