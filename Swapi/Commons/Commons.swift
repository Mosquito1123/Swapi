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

/**
 Common Image scroll view for detail view controller. CharacterDetailViewController,
 FilmDetailsViewController, SpeciesDetailsViewController, StarshipDetailsViewController,
 PlanetDetailsViewController, and VehicleDetailsViewController
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

    lazy var imageScrollViewWidth: CGFloat = {
        return detailScrollViewProtocol.imageScrollView.frame.width
    }()

    var detailScrollViewProtocol: DetailScrollViewProtocol

    private(set) var previousImageScrollViewContentOffset: CGPoint = .zero

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
        case .right:
            newPage = detailScrollViewProtocol.pageIndex + 1
        default:
            newPage = detailScrollViewProtocol.pageIndex
        }
        visibleRect.origin.x = detailScrollViewProtocol.imageScrollView.frame.width * CGFloat(newPage)
        detailScrollViewProtocol.imageScrollView.contentOffset = visibleRect.origin
        detailScrollViewProtocol.imageScrollView.scrollRectToVisible(visibleRect, animated: true)
        previousImageScrollViewContentOffset = detailScrollViewProtocol.imageScrollView.contentOffset
        detailScrollViewProtocol.pageIndex = newPage
    }

    func setUIImageViewCenterXContraint(identifier: String, constant: CGFloat?) {
        if let constant = constant {
            detailScrollViewProtocol.imageScrollView.constraintWithIdentifier(identifier)?.constant = constant
        } else {
            if previousImageScrollViewContentOffset.x != 0.0 {
                detailScrollViewProtocol.imageScrollView.constraintWithIdentifier(identifier)?.constant = previousImageScrollViewContentOffset.x
            } else {
                /**
                    FIXMEs: just a temporary fix. Otherwise, when scroll to the first page of the scroll view,
                    it stop responding. Nevertheless, the constant should be 0, since we are at the first page.
                    But it won't work with 0, so 1 is a quick fix for now.
                **/
                detailScrollViewProtocol.imageScrollView.constraintWithIdentifier(identifier)?.constant = 1
            }
        }
    }

    func setPreviousImageViewContentOffset(with point: CGPoint) {
        previousImageScrollViewContentOffset = point
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

    private func imageResize(image: UIImage?, sizeChange: CGSize) -> UIImage? {
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
        case characterDetails
        case filmDetails
        case planetDetails
        case specieDetails
        case starshipDetails
        case vehicleDetails
    }
    static func routeTo(from: UIViewController, to route: Router.Route, page: Int, entityName: [String]?) {
        var toVC: UIViewController = UIViewController()
        switch route {
        case .characterDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailsViewController")
            if let characterDetailsVC = toVC as? CharacterDetailsViewController {
                characterDetailsVC.pageIndex = page
                characterDetailsVC.characterNames = entityName
            }
        case .filmDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "FilmDetailsViewController")
            if let filmDetailsVC = toVC as? FilmDetailsViewController {
                filmDetailsVC.pageIndex = page
                filmDetailsVC.filmTitles = entityName
            }
        case .planetDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "PlanetDetailsViewController")
            if let planetDetailsVC = toVC as? PlanetDetailsViewController {
                planetDetailsVC.pageIndex = page
                planetDetailsVC.planetNames = entityName
            }
        case .specieDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "SpecieDetailsViewController")
            if let specieDetailsVC = toVC as? SpecieDetailsViewController {
                specieDetailsVC.pageIndex = page
                specieDetailsVC.specieNames = entityName
            }
        case .starshipDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "StarshipDetailsViewController")
            if let starshipDetailsVC = toVC as? StarshipDetailsViewController {
                starshipDetailsVC.pageIndex = page
                starshipDetailsVC.starshipNames = entityName
            }
        case .vehicleDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "VehicleDetailsViewController")
            if let vehicleDetailsVC = toVC as? VehicleDetailsViewController {
                vehicleDetailsVC.pageIndex = page
                vehicleDetailsVC.vehicleNames = entityName
            }
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
