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
    
    func mediaArray(for indexPath: IndexPath) -> [Media] {
        let sectionHeader = self.sectionHeader(for: indexPath)
        return DataStore.shared.media.filter{ $0.dateString == sectionHeader }
    }
    
    func mediaItem(for indexPath: IndexPath) -> Media {
        
    }
    
    func numberOfItems(for indexPath: IndexPath) -> Int {
        return media(for: indexPath).count
    }
    
    func sectionHeader(for indexPath: IndexPath) -> String {
        return DataStore.shared.mediaSectionHeaders[indexPath.section]
    }
}

extension MediaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCollectionViewCell
        let mediaItem = media(for: indexPath)
        cell.imageView.image = UIImage(data: mediaItem)
        return cell
    }
    
}
