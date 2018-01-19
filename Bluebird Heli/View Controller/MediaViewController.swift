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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.size.width / 3
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: width, height: width)
        setUpToolBar()
        let selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectTapped))
        self.navigationItem.rightBarButtonItem = selectButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let cell = collectionView?.cellForItem(at: index) as! MediaCollectionViewCell
            cell.isEditing = editing
        }
    }
    
    @IBAction func shareTapped(_ sender: UIBarButtonItem) {
        var images: [UIImage] = []
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! MediaCollectionViewCell
                if let image = cell.imageView.image {
                    images.append(image)
                }
            }
        }
        let controller = UIActivityViewController(activityItems: images, applicationActivities: nil)
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
    
    func image(for indexPath: IndexPath, completion: (UIImage) -> ()){
        let cell = collectionView.cellForItem(at: indexPath) as! MediaCollectionViewCell
        if let image = cell.imageView.image {
            completion(image)
        }
    }
    
    func mediaItem(for indexPath: IndexPath) -> Media {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        let media = mediaItem(for: indexPath)
        cell.imageView.image = UIImage(data: media.data)
        return cell
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
