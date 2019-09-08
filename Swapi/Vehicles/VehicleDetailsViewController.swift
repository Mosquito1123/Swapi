//
//  VehicleDetailsViewController.swift
//  Swapi
//
//  Created by TuyenLe on 7/30/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import UIKit

// MARK: Extension

extension VehicleDetailsViewController: DetailScrollViewProtocol {
    var imageScrollView: UIScrollView {
        return vehicleImageScrollView
    }

    var pageIndex: Int {
        get {
            return vehicleIndex ?? 0
        }
        set {
            vehicleIndex = newValue
        }
    }
}

extension VehicleDetailsViewController: UIScrollViewDelegate {
    var endOfScrollViewContentOffsetX: CGFloat {
        let vehicleCount = vehicleNames?.count ?? (LocalCache.vehicles?.count ?? 1)

        return (viewModel?.imageScrollViewWidth ?? 0) * CGFloat(vehicleCount - 1)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == vehicleImageScrollView {
            if viewModel?.previousImageScrollViewContentOffset.x ?? 0 > scrollView.contentOffset.x {
                vehicleScrollVIewLeftArrowAction()
            } else if viewModel?.previousImageScrollViewContentOffset.x ?? 0 < scrollView.contentOffset.x {
                vehicleScrollViewRightArrowAction()
            }
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // prevent user scroll past the end of scroll view
        if scrollView.contentOffset.x > endOfScrollViewContentOffsetX {
            var visibleRect = scrollView.frame
            visibleRect.origin.x = endOfScrollViewContentOffsetX
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
    }
}

extension VehicleDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vehicleCellInformation = tableView.dequeueReusableCell(withIdentifier: "vehicleInformation", for: indexPath)

        if indexPath.row == 0 {
            vehicleCellInformation.textLabel?.text = "Model"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.model
        } else if indexPath.row == 1 {
            vehicleCellInformation.textLabel?.text = "Manufacturer"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.manufacturer
        } else if indexPath.row == 2 {
            vehicleCellInformation.textLabel?.text = "Cost in credits"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.costInCredits
        } else if indexPath.row == 3 {
            vehicleCellInformation.textLabel?.text = "Length"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.length
        } else if indexPath.row == 4 {
            vehicleCellInformation.textLabel?.text = "Max atmosphering speed"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.maxAtmospheringSpeed
        } else if indexPath.row == 5 {
            vehicleCellInformation.textLabel?.text = "Crew"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.crew
        } else if indexPath.row == 6 {
            vehicleCellInformation.textLabel?.text = "Passengers"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.passenger
        } else if indexPath.row == 7 {
            vehicleCellInformation.textLabel?.text = "Cargo capacity"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.cargoCapacity
        } else if indexPath.row == 8 {
            vehicleCellInformation.textLabel?.text = "Consumables"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.consumables
        } else if indexPath.row == 9 {
            vehicleCellInformation.textLabel?.text = "Vehicle class"
            vehicleCellInformation.detailTextLabel?.text = vehicleData?.vehicleClass
        }

        return vehicleCellInformation
    }
}

extension VehicleDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filmCollection {
            return viewModel?.films.count ?? 0
        } else if collectionView == pilotCollection {
            return viewModel?.pilots.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filmCollection, let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filmCell", for: indexPath) as? FilmCell {

            filmCell.name = viewModel?.films[indexPath.row]
            filmCell.showMoreIndicator = filmCell.showMoreIndicator ?? true
            return filmCell
        } else if collectionView == pilotCollection,
            let pilotCell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {

            pilotCell.name = viewModel?.pilots[indexPath.row]
            pilotCell.showMoreIndicator = pilotCell.showMoreIndicator ?? true
            return pilotCell
        }
        return UICollectionViewCell()
    }
}

extension VehicleDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        if collectionView == filmCollection {
            label.text = viewModel?.films[indexPath.row]
        } else if collectionView == pilotCollection {
            label.text = viewModel?.pilots[indexPath.row]
        }

        return CGSize(width: label.intrinsicContentSize.width + 24, height: label.intrinsicContentSize.height) // add 24 to make space for right arrow indicator
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filmCollection {
            Router.routeTo(from: self, to: .filmDetails, page: indexPath.row, entityName: viewModel?.films)
        } else if collectionView == pilotCollection {
            Router.routeTo(from: self, to: .characterDetails, page: indexPath.row, entityName: viewModel?.pilots)
        }
    }
}

// MARK: Main class

class VehicleDetailsViewModel: ViewModel {

    weak var vehicleDetailsVC: VehicleDetailsViewController?

    var films: [String] {
        let vehicleDatas = vehicleDetailsVC?.vehicleData
        var result: [String] = []
        for film in vehicleDatas?.films ?? [] {
            let id = Int(film.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.films?[id]?.title ?? "")
        }
        return result
    }

    var pilots: [String] {
        let vehicleDatas = vehicleDetailsVC?.vehicleData
        var result: [String] = []
        for pilot in vehicleDatas?.pilots ?? [] {
            let id = Int(pilot.string!.components(separatedBy: "/")[5])!
            result.append(LocalCache.characters?[id]?.name ?? "")
        }
        return result
    }

    init(vehicleDetailsVC: VehicleDetailsViewController) {
        super.init(detailScrollViewProtocol: vehicleDetailsVC)
        self.vehicleDetailsVC = vehicleDetailsVC
    }

    override func scrollViewSetup() {
        super.scrollViewSetup()
        if let vc = vehicleDetailsVC {
            vc.imageScrollView.contentSize.width = vc.imageScrollView.frame.width * 39
        }
    }

    override func set(direction: ViewModel.PageDirection) {
        super.set(direction: direction)
        guard let vc = vehicleDetailsVC else { return }
        vc.presentDetails()
    }

    func reloadAllTableAndCollection() {
        guard let vc = vehicleDetailsVC else { return }
        vc.vehicleInformation.reloadSections(IndexSet(integer: 0), with: .automatic)
        vc.filmCollection.reloadSections(IndexSet(integer: 0))
        vc.pilotCollection.reloadSections(IndexSet(integer: 0))
    }
}

class VehicleDetailsViewController: UIViewController {

    @IBOutlet weak var vehicleUIImageView: UIImageView!

    @IBOutlet weak var vehicleMainScrollView: UIScrollView!

    @IBOutlet weak var pilotCollection: UICollectionView!

    @IBOutlet weak var filmCollection: UICollectionView!

    @IBOutlet weak var vehicleInformation: UITableView!

    @IBOutlet weak var vehicleImageScrollView: UIScrollView!

    var vehicleData: Vehicle?

    var viewModel: VehicleDetailsViewModel?

    var vehicleIndex: Int?

    var vehicleNames: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = VehicleDetailsViewModel(vehicleDetailsVC: self)
        if let viewModel = self.viewModel {
            viewModel.scrollViewSetup()
            presentDetails()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewModel?.imageScrollViewWidth = size.width
        imageScrollView.setContentOffset(imageScrollView.contentOffset, animated: true)
        viewModel?.setPreviousImageViewContentOffset(with: imageScrollView.contentOffset)
        viewModel?.setUIImageViewCenterXContraint(identifier: "vehicleUIImageViewCenterX", constant: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageScrollView.setContentOffset(viewModel?.previousImageScrollViewContentOffset ?? .zero, animated: true)
    }

    override func viewDidLayoutSubviews() {
        if UIDevice.current.orientation.isLandscape {
            vehicleMainScrollView.constraintWithIdentifier("vehicleScrollViewBottom")?.constant = 250
        } else if UIDevice.current.orientation.isPortrait {
            vehicleMainScrollView.constraintWithIdentifier("vehicleScrollViewBottom")?.constant = -188
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let backItem = UIBarButtonItem()
        backItem.title = title
        backItem.tintColor = .yellow
        navigationItem.backBarButtonItem = backItem
        imageScrollView.setContentOffset(.zero, animated: true)
    }

    func presentDetails() {
        if let vehicleNames = vehicleNames {
            for vehicle in Array(LocalCache.vehicles?.values ?? [Int: Vehicle]().values) where vehicle.name == vehicleNames[pageIndex] {
                vehicleData = vehicle
                break
            }
        } else {
            vehicleData = Array(LocalCache.vehicles?.values ?? [Int: Vehicle]().values)[pageIndex]
        }
        title = vehicleData?.name
        if let title = title {
            if title.contains("/") {
                // image file's name cannot contain forward slash "/". That is why we replace it with colon ":"
                let newTitle = title.replacingOccurrences(of: "/", with: ":")
                vehicleUIImageView.image = UIImage(named: "Vehicles/\(newTitle)")
            } else {
                vehicleUIImageView.image = UIImage(named: "Vehicles/\(title)")
            }
        }
        viewModel?.setUIImageViewCenterXContraint(identifier: "vehicleUIImageViewCenterX", constant: nil)
    }

    func vehicleScrollVIewLeftArrowAction() {
        if pageIndex > 0 {
            viewModel?.set(direction: .left)
            viewModel?.reloadAllTableAndCollection()
        }
    }

    func vehicleScrollViewRightArrowAction() {
        let totalPage = vehicleNames == nil ? LocalCache.vehicles?.count ?? 0 : vehicleNames?.count ?? 0
        if pageIndex < totalPage - 1 {
            viewModel?.set(direction: .right)
            viewModel?.reloadAllTableAndCollection()
        }
    }
}
