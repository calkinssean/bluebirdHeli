//
//  MediaViewController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/16/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import UIKit
import FirebaseStorage

class MediaViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addItemsToCollectionView), name: mediaItemAddedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeItemsFromCollectionView), name: mediaItemRemovedNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItemsInCollectionView), name: mediaItemChangedNotificationName, object: nil)
        let width = view.frame.size.width / 3
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: width, height: width)
        setUpToolBar()
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTapped))
        self.navigationItem.rightBarButtonItem = selectButton
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMediaDetailSegue" {
            let indexPath = sender as! IndexPath
            let media = mediaArray(for: indexPath.section)
            let destination = segue.destination as! MediaDetailViewController
            destination.mediaArray = media
            destination.item = indexPath.item
            destination.title = sectionHeader(for: indexPath.section)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView?.allowsMultipleSelection = editing
        if !editing {
            navigationController?.isToolbarHidden = true
        }
        guard let indexes = collectionView?.indexPathsForVisibleItems else {
            return
        }
        for index in indexes {
            if let cell = collectionView?.cellForItem(at: index) as? ImageCollectionViewCell {
                cell.isEditing = editing
            }
        }
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        var images: [UIImage] = []
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
                if cell.mediaType == .Image {
                    if let image = cell.imageView.image {
                        images.append(image)
                    }
                }
            }
        }
        let controller = UIActivityViewController(activityItems: images, applicationActivities: nil)
        if let popoverController = controller.popoverPresentationController {
            popoverController.barButtonItem = shareButton
        }
        present(controller, animated: true, completion: nil)
    }
    
    func setUpToolBar() {
        navigationController?.isToolbarHidden = true
        if let toolBar = navigationController?.toolbar {
            toolBar.tintColor = UIColor.white
            toolBar.barTintColor = UIColor.black
            toolBar.sizeToFit()
        }
    }
    
    @objc func selectTapped() {
        self.isEditing = !isEditing
    }
    
    @objc func addItemsToCollectionView() {
        let item = UserDefaults.standard.integer(forKey: itemToAddKey)
        let sectionIndex = UserDefaults.standard.integer(forKey: sectionToAddKey)
        let indexPath = IndexPath(item: item, section: sectionIndex)
        if sectionIndex > collectionView.numberOfSections - 1 {
            collectionView.performBatchUpdates({
                let set = IndexSet(integer: sectionIndex)
                collectionView.insertSections(set)
                self.collectionView.insertItems(at: [indexPath])
            }, completion: nil)
        } else {
            collectionView.insertItems(at: [indexPath])
        }
    }
    @objc func reloadItemsInCollectionView() {
        let item = UserDefaults.standard.integer(forKey: itemToReloadKey)
        let sectionIndex = UserDefaults.standard.integer(forKey: sectionToReloadKey)
        let indexPath = IndexPath(item: item, section: sectionIndex)
        collectionView.reloadItems(at: [indexPath])
    }
    @objc func removeItemsFromCollectionView() {
        let item = UserDefaults.standard.integer(forKey: itemToRemoveKey)
        let sectionIndex = UserDefaults.standard.integer(forKey: sectionToRemoveKey)
        let indexPath = IndexPath(item: item, section: sectionIndex)
        if mediaArray(for: sectionIndex).isEmpty {
            collectionView.performBatchUpdates({
                let set = IndexSet(integer: sectionIndex)
                collectionView.deleteSections(set)
                self.collectionView.deleteItems(at: [indexPath])
                DataStore.shared.mediaSectionHeaders.remove(at: sectionIndex)
            }, completion: nil)
        } else {
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
}

// MARK: - Data Source Helper Methods
extension MediaViewController {
    
    func numberOfSections() -> Int {
        return DataStore.shared.mediaSectionHeaders.count
    }
    
    func mediaArray(for section: Int) -> [Media] {
        let sectionHeader = self.sectionHeader(for: section)
        if let mediaArray = DataStore.shared.mediaDict[sectionHeader] {
            return mediaArray
        }
        return []
    }
    
    func image(for indexPath: IndexPath, completion: (UIImage) -> ()) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        if let image = cell.imageView.image {
            completion(image)
        }
    }
    
    func getMediaItem(for indexPath: IndexPath) -> Media {
        return mediaArray(for: indexPath.section)[indexPath.item]
    }
    
    func numberOfItems(for section: Int) -> Int {
        return mediaArray(for: section).count
    }
    
    func sectionHeader(for section: Int) -> String {
        return DataStore.shared.mediaSectionHeaders[section]
    }
}

extension MediaViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaItem = getMediaItem(for: indexPath)
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        if let data = mediaItem.data {
            imageCell.imageView.image = UIImage(data: data)
        }
        if mediaItem.mediaType == .Video {
            imageCell.mediaType = .Video
            imageCell.playImage.isHidden = false
        } else {
            imageCell.playImage.isHidden = true
            imageCell.mediaType = .Image
        }
        return imageCell
    }
    
}

extension MediaViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "ShowMediaDetailSegue", sender: indexPath)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        header.titleLabel.text = sectionHeader(for: indexPath.section)
        return header
    }
    
}
