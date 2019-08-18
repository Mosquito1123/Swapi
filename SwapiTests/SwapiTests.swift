//
//  SwapiTests.swift
//  SwapiTests
//
//  Created by TuyenLe on 7/29/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import XCTest
@testable import Swapi

class SwapiTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCharactersServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getCharacters(1..<10) { (datas: [Data?])  in
            for data in datas {
                if data == nil {
                    assert(false, "fail to fetch all characters")
                    return
                }
            }
        }
        assert(true, "success fetchinng all characters")
    }
    
    func testFilmsServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getFilms { (data: Data?) in
            if data == nil {
                assert(false, "fail to fetch films")
                return
            }
        }
        assert(true, "success fetching all films")
    }
    
    func testPlanetsServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getPlanets(1..<8) { (datas: [Data?]) in
            for data in datas {
                if data == nil {
                    assert(false, "fail to fetch all planets")
                    return
                }
            }
        }
        assert(true, "success fetching all planets")
    }
    
    func testSpeciesServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getSpecies(1..<5) { (datas: [Data?]) in
            for data in datas {
                if data == nil {
                    assert(false, "fail to fetch all species")
                    return
                }
            }
        }
        assert(true, "sucess fetching all species")
    }
    
    func testStarshipsServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getStarships(1..<5) { (datas: [Data?]) in
            for data in datas {
                if data == nil {
                    assert(false, "fail to fetch all species")
                    return
                }
            }
        }
        assert(true, "success fetching all starships")
    }
    
    
    func testVehiclesServiceRequest() {
        let category = CategoryProtocolImplementation()
        category.getVehicles(1..<5) { (datas: [Data?]) in
            for data in datas {
                if data == nil {
                    assert(false, "fail to fetch all species")
                    return
                }
            }
        }
        assert(true, "success fetching all vehicles")
    }
    
    func testAsyncServiceRequest() {
        let launchScreenVC = LaunchScreenViewController()
        let loadingIndicator = UIActivityIndicatorView(frame: .zero)
        launchScreenVC.loadingIndicator = loadingIndicator
        launchScreenVC.preFetchAllStarwarsEntities()
        Service.dispatchGroup.notify(queue: .main) {
            guard let _ = LocalCache.characters, let _ = LocalCache.films, let _ = LocalCache.planets, let _ = LocalCache.species,
                  let _ = LocalCache.starships, let _ = LocalCache.vehicles else {
                    assert(false, "async service request fail for all starwar entities")
            }
            assert(true, "async service request succeed for all starwar entities")
        }
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
