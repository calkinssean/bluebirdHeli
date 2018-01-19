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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
