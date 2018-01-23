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
        setUpTapGesture()
        setUpToolBar()
        let indexPath = IndexPath(item: item, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCollectionView() {
        let width = view.frame.size.width
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.isPagingEnabled = true
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleToolBar))
        self.view.addGestureRecognizer(tap)
    }
    
    func setUpToolBar() {
        navigationController?.isToolbarHidden = true
        if let toolBar = navigationController?.toolbar {
            toolBar.tintColor = UIColor.white
            toolBar.barTintColor = UIColor.black
            toolBar.sizeToFit()
        }
    }
    
    @objc func toggleToolBar() {
        if let hidden = navigationController?.isToolbarHidden {
            navigationController?.isToolbarHidden = !hidden
        }
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        sharePhoto()
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
        let mediaItem = mediaArray[indexPath.item]
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        if let data = mediaItem.data {
            imageCell.imageView.image = UIImage(data: data)
        }
        return imageCell
    }
    
}

// MARK: - UIActivityViewController
extension MediaDetailViewController {
    func sharePhoto() {
        if let cell = collectionView.visibleCells.first as? ImageCollectionViewCell {
            if let image = cell.imageView.image {
                let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(controller, animated: true , completion: nil)
            }
        }
    }
}
