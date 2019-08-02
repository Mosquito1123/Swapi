//
//  SpeciesWorker.swift
//  Swapi
//
//  Created by TuyenLe on 7/29/19.
//  Copyright (c) 2019 TuyenLe. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class SpeciesWorker
{
    var category: CategoryProtocol
    
    init(category: CategoryProtocol) {
        self.category = category
    }
    
    func getSpecies(sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
    {
        category.getSpecies(sequence) { (data: [Data?]) in
            completion(data)
        }
    }
}
