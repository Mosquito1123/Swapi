//
//  FilmsModels.swift
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

enum Films {
  // MARK: Use cases
  
  enum Fetch {
    struct Request {
    }
    struct Response {
        var films: Data?
    }
    struct ViewModel {
        var films: [Film]
    }
  }
}