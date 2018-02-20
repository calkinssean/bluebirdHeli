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
    @IBOutlet var shareButton: UIBarButtonItem!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(addItemsToCollectionView), name: mediaItemAddedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeItemsFromCollectionView), name: mediaItemRemovedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItemsInCollectionView), name: mediaItemChangedNotificationName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCollectionView() {
        let width = view.frame.size.width
        let height = view.frame.size.height * 0.9
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: width, height: height)
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
        if let visibleIndexPath = collectionView.indexPathsForVisibleItems.first {
            if let _ = collectionView.cellForItem(at: visibleIndexPath) as? ImageCollectionViewCell {
                if let hidden = navigationController?.isToolbarHidden {
                    navigationController?.isToolbarHidden = !hidden
                    if hidden == true {
                        hideToolBarAfterThreeSeconds()
                    }
                }
            } 
        }
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        sharePhoto()
    }
    
    func hideToolBarAfterThreeSeconds() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.navigationController?.isToolbarHidden = true
        }
    }
    
    @objc func updateCollectionView() {
        let item = UserDefaults.standard.integer(forKey: "itemToUpdate")
        let sectionIndex = UserDefaults.standard.integer(forKey: "sectionToUpdate")
        let sectionHeader = DataStore.shared.mediaSectionHeaders[sectionIndex]
        if sectionHeader == self.title {
            if let array = DataStore.shared.mediaDict[sectionHeader] {
                mediaArray = array
                let indexPath = IndexPath(item: item, section: 0)
                collectionView.insertItems(at: [indexPath])
            }
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
        let mediaItem = mediaArray[indexPath.item]
        switch mediaItem.mediaType {
        case .Image:
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            if let data = mediaItem.data {
                imageCell.imageView.image = UIImage(data: data)
            }
            return imageCell
        case .Video:
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
            videoCell.mediaItem = mediaItem
            return videoCell
        }
    }
    
}

// MARK: - UIActivityViewController
extension MediaDetailViewController {
    func sharePhoto() {
        if let cell = collectionView.visibleCells.first as? ImageCollectionViewCell {
            if let image = cell.imageView.image {
                let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                if let popoverController = controller.popoverPresentationController {
                    popoverController.barButtonItem = shareButton
                }
                present(controller, animated: true , completion: nil)
            }
        }
    }
}

