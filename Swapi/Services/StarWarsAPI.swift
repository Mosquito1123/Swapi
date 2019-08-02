//
//  StarWarsAPI.swift
//  Star Wars Index
//
//  Created by TuyenLe on 7/26/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation
import Alamofire

protocol CategoryProtocol {
    func getCharacters(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
    func getFilms(completion: @escaping (() throws -> Data?) -> Void)
    func getPlanets(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
    func getSpecies(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
    func getStarships(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
    func getVehicles(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void)
}

final class Service {
    static var dispatchGroup = DispatchGroup()

    static func request(url: String, _ completionHandler: @escaping (() throws -> Data?) -> Void) {
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                completionHandler {
                    switch response.result {
                    case .success:
                        return response.data
                    case .failure(let error):
                        throw error
                    }
                }
        }
    }
}


class CategoryProtocolImplementation: CategoryProtocol {
    func getCharacters(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void) {
        var datas: [Data?] = []

        for page in sequence {
            Service.dispatchGroup.enter()
            Service.request(url: "https://swapi.co/api/people/?page=\(page)") { (people: () throws -> Data?) in
                do {
                    let data = try people()
                    datas.append(data)
                    Service.dispatchGroup.leave()
                } catch let error {
                    print("Error fetching characters: ", error)
                    datas.append(nil)
                    Service.dispatchGroup.leave()
                }
            }
        }
        
        Service.dispatchGroup.notify(queue: .main) {
            completion(datas)
        }

    }

    func getFilms(completion: @escaping (() throws -> Data?) -> Void) {
        let url = "https://swapi.co/api/films/"
        Service.request(url: url, completion)
    }

    func getPlanets(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void) {
        var datas: [Data?] = []

        for page in sequence {
            Service.dispatchGroup.enter()
            Service.request(url: "https://swapi.co/api/planets/?page=\(page)") { (people: () throws -> Data?) in
                do {
                    let data = try people()
                    datas.append(data)
                    Service.dispatchGroup.leave()
                } catch let error {
                    print("Error fetching planets: ", error)
                    datas.append(nil)
                    Service.dispatchGroup.leave()
                }
            }
        }
        
        Service.dispatchGroup.notify(queue: .main) {
            completion(datas)
        }
    }

    func getSpecies(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void) {
        var datas: [Data?] = []
        
        for page in sequence {
            Service.dispatchGroup.enter()
            Service.request(url: "https://swapi.co/api/species/?page=\(page)") { (species: () throws -> Data?) in
                do {
                    let data = try species()
                    datas.append(data)
                    Service.dispatchGroup.leave()
                } catch let error {
                    print("Error fetching species: ", error)
                    datas.append(nil)
                    Service.dispatchGroup.leave()
                }
            }
        }
        
        Service.dispatchGroup.notify(queue: .main) {
            completion(datas)
        }
    }

    func getStarships(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void) {
        var datas: [Data?] = []
        
        for page in sequence {
            Service.dispatchGroup.enter()
            Service.request(url: "https://swapi.co/api/starships/?page=\(page)") { (starShips: () throws -> Data?) in
                do {
                    let data = try starShips()
                    datas.append(data)
                    Service.dispatchGroup.leave()
                } catch let error {
                    print("Error fetching starships: ", error)
                    datas.append(nil)
                    Service.dispatchGroup.leave()
                }
            }
        }
        
        Service.dispatchGroup.notify(queue: .main) {
            completion(datas)
        }
    }

    func getVehicles(_ sequence: Range<Int>, completion: @escaping ([Data?]) -> Void) {
        var datas: [Data?] = []
        
        for page in sequence {
            Service.dispatchGroup.enter()
            Service.request(url: "https://swapi.co/api/vehicles/?page=\(page)") { (vehicles: () throws -> Data?) in
                do {
                    let data = try vehicles()
                    datas.append(data)
                    Service.dispatchGroup.leave()
                } catch let error {
                    print("Error fetching vehicles: ", error)
                    datas.append(nil)
                    Service.dispatchGroup.leave()
                }
            }
        }
        
        Service.dispatchGroup.notify(queue: .main) {
            completion(datas)
        }
    }
}

