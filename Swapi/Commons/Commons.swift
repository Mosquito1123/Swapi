//
//  ViewModel.swift
//  Swapi
//
//  This file is intended to store common class, properties,
//  and protocol that can be used throughout the app
//
//  Created by TuyenLe on 8/15/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

// MARK: Common functionns

func imageResize(image: UIImage?, sizeChange: CGSize) -> UIImage? {
    guard image != nil else {
        return nil
    }
    let hasAlpha = true
    let scale: CGFloat = 0.0 // Use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    image?.draw(in: CGRect(origin: .zero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    return scaledImage
}

/**
 Common Image scroll view for detail view controller. CharacterDetailViewController
 **/
protocol DetailScrollViewProtocol {
    var imageScrollView: UIScrollView { get }
    var pageIndex: Int { get set }
}

/**
 Subclass ViewModel for common functionality like setting up image sceollview
 contentsize and set new page number for image scroll view upon user interaction
 **/

class ViewModel {

    var detailScrollViewProtocol: DetailScrollViewProtocol
    
    var previousImageViewContentOffset: CGPoint = .zero

    enum PageDirection {
        case left
        case right
        case same
    }

    // MARK: initialization

    init(detailScrollViewProtocol: DetailScrollViewProtocol) {
        self.detailScrollViewProtocol = detailScrollViewProtocol
    }

    // MARK: view logic

    func scrollViewSetup() {
        set(direction: .same)
    }

    func set(direction: PageDirection) {
        var newPage = 0
        var visibleRect = detailScrollViewProtocol.imageScrollView.frame

        switch direction {
        case .left:
            newPage = detailScrollViewProtocol.pageIndex - 1
            break
        case .right:
            newPage = detailScrollViewProtocol.pageIndex + 1
            break
        default:
            newPage = detailScrollViewProtocol.pageIndex
        }
        visibleRect.origin.x = detailScrollViewProtocol.imageScrollView.frame.width * CGFloat(newPage)
        detailScrollViewProtocol.imageScrollView.contentOffset = visibleRect.origin
        detailScrollViewProtocol.imageScrollView.scrollRectToVisible(visibleRect, animated: true)
        previousImageViewContentOffset = detailScrollViewProtocol.imageScrollView.contentOffset
        detailScrollViewProtocol.pageIndex = newPage
    }
}

/**
 This class is for reusable uicollection view cell with "detail"
 arrow indicator on the right
 **/
class Cell: UICollectionViewCell {
    var name: String? {
        didSet {
            guard let name = name else { return }
            label.text = name
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewMoreIndicator: UIButton = {
        let button = UIButton()
        let arrowRight = imageResize(image: UIImage(named: "arrowRight"), sizeChange: CGSize(width: 12, height: 12))
        button.setImage(arrowRight, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupLabel() {
        contentView.addSubview(label)
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
    }
    
    private func setupViewMoreIndicator() {
        contentView.addSubview(viewMoreIndicator)
        viewMoreIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
        setupViewMoreIndicator()
    }
}

class CharacterCell: Cell {
    // leave this class empty on purpose just for the sake of readability for characterCollection cell
}

class PlanetCell: Cell {
    // leave this class empty on purpose just for the sake of readability for planetCollection cell
}

class FilmCell: Cell {
    // leave this class empty on purpose just for the sake of readability for filmCollection cell
}

class SpecieCell: Cell {
    // leave this class empty on purpose just for the sake of readablility for specieCollection cell
}

class VehicleCell: Cell {
    // leave this class empty on purpose just for the sake of readablility for vehicleCollection cell
}

class StarshipCell: Cell {
    // leave this class empty on purpose just for the sake of readablility for starshipCollection cell
}

/**
 This is responsible for routing from one uiviewcontroller to another
 **/
enum Router {

    // MARK: Routing

    enum Route: String {
        case CharacterDetails
        case FilmDetails
        case PlanetDetails
        case SpecieDetails
        case StarshipDetails
        case VehicleDetails
    }
    static func routeTo(from: UIViewController, to route: Router.Route, page: Int, entityName: [String]?) {
        var toVC: UIViewController = UIViewController()
        switch route {
        case .CharacterDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailsViewController")
            let characterDetailsVC = toVC as! CharacterDetailsViewController
            characterDetailsVC.pageIndex = page
            characterDetailsVC.characterNames = entityName
            break
        case .FilmDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "FilmDetailsViewController")
            let filmDetailsVC = toVC as! FilmDetailsViewController
            filmDetailsVC.pageIndex = page
            filmDetailsVC.filmTitles = entityName
            break
        case .PlanetDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "PlanetDetailsViewController")
            let planetDetailsVC = toVC as! PlanetDetailsViewController
            planetDetailsVC.pageIndex = page
            planetDetailsVC.planetNames = entityName
            break
        case .SpecieDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "SpecieDetailsViewController")
            let specieDetailsVC = toVC as! SpecieDetailsViewController
            specieDetailsVC.pageIndex = page
            specieDetailsVC.specieNames = entityName
            break
        case .StarshipDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "StarshipDetailsViewController")
            let starshipDetailsVC = toVC as! StarshipDetailsViewController
            starshipDetailsVC.pageIndex = page
            starshipDetailsVC.starshipNames = entityName
            break
        case .VehicleDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "VehicleDetailsViewController")
            let vehicleDetailsVC = toVC as! VehicleDetailsViewController
            vehicleDetailsVC.pageIndex = page
            vehicleDetailsVC.vehicleNames = entityName
            break
        }
        from.show(toVC, sender: nil)
    }
}

extension UIView {
    /// - Parameter identifier: The constraint identifier.
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }
}

