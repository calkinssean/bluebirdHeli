//
//  CollectionViewDataSourceController.swift
//  Bluebird Heli
//
//  Created by Sean Calkins on 1/18/18.
//  Copyright © 2018 Sean Calkins. All rights reserved.
//

import Foundation

class CollectionViewDataSourceController {
    
    func numberOfSections() -> Int {
        return DataStore.shared.mediaSectionHeaders.count
    }
    
    func media(for indexPath: IndexPath) -> [Media] {
        let sectionHeader = self.sectionHeader(for: indexPath)
        return DataStore.shared.media.filter{ $0.dateString == sectionHeader }
    }
    
    func numberOfItems(for indexPath: IndexPath) -> Int {
        return media(for: indexPath).count
    }
    
    func sectionHeader(for indexPath: IndexPath) -> String {
        return DataStore.shared.mediaSectionHeaders[indexPath.section]
    }
    
}
