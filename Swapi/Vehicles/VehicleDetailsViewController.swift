//
//  VehicleDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit


struct VehicleDetailsViewModel {
    
    weak var vehicleDetailsVC: VehicleDetailsViewController?
    
    var films: [String] {
        let vehicleDatas = vehicleDetailsVC?.routeVehiclepData
        var result: [String] = []
        for film in vehicleDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }
    
    var pilots: [String] {
        let vehicleDatas = vehicleDetailsVC?.routeVehiclepData
        var result: [String] = []
        for pilot in vehicleDatas?.pilots ?? [] {
            let id = Int(pilot.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }
}


class VehicleDetailsViewController: UIViewController {
    var routeVehiclepData: Vehicle?
    
    var viewModel: VehicleDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = routeVehiclepData?.name
        viewModel = VehicleDetailsViewModel(vehicleDetailsVC: self)
        
        presentDetails()
    }
    
    func presentDetails() {
        // TODO: present details to UIView
    }
}
