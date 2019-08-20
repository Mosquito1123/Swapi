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


protocol DetailScrollViewProtocol {
    var mainScrollView: UIScrollView { get }
    var imageScrollView: UIScrollView { get }
    var leftArrow: UIButton { get }
    var rightArrow: UIButton { get }
    var pageIndex: Int { get set }
}

class ViewModel {

    var detailScrollViewProtocol: DetailScrollViewProtocol

    var detailsVC: UIViewController
    
    var previousImageViewContentOffset: CGPoint = .zero

    enum PageDirection {
        case left
        case right
        case same
    }

    // MARK: initialization

    init(detailScrollViewProtocol: DetailScrollViewProtocol, detailVC: UIViewController) {
        self.detailScrollViewProtocol = detailScrollViewProtocol
        self.detailsVC = detailVC
    }

    // MARK: view logic

    func scrollViewSetup() {
        set(direction: .same)
        detailScrollViewProtocol.imageScrollView.contentSize = CGSize(width: detailScrollViewProtocol.imageScrollView.frame.width * 87, height: 0)
    }

    func set(direction: PageDirection) {
        var newPage = 0
        var scrollToVisibleRect = detailScrollViewProtocol.imageScrollView.frame.origin

        switch direction {
        case .left:
            newPage = detailScrollViewProtocol.pageIndex - 1
            break
        case .right:
            newPage = detailScrollViewProtocol.pageIndex + 1
            break
        default:
            newPage = detailScrollViewProtocol.pageIndex
            scrollToVisibleRect.x = detailScrollViewProtocol.imageScrollView.frame.width * CGFloat(newPage)
            scrollToVisibleRect.y = 0
            detailScrollViewProtocol.imageScrollView.setContentOffset(scrollToVisibleRect, animated: true)
        }
        previousImageViewContentOffset = detailScrollViewProtocol.imageScrollView.contentOffset
        detailScrollViewProtocol.pageIndex = newPage
    }
}

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
        contentView.addSubview(viewMoreIndicator)
        viewMoreIndicator.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
}

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
    static func routeTo(from: UIViewController, to route: Router.Route, param: Any?) {
        var toVC: UIViewController = UIViewController()
        switch route {
        case .CharacterDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "CharacterDetailsViewController")
            (toVC as! CharacterDetailsViewController).pageIndex = param as? Int ?? 0
            break
        case .FilmDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "FilmDetailsViewController")
            (toVC as! FilmDetailsViewController).pageIndex = param as? Int ?? 0
            break
        case .PlanetDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "PlanetDetailsViewController")
            (toVC as! PlanetDetailsViewController).routePlanetData = param as? Planet
            break
        case .SpecieDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "SpecieDetailsViewController")
            (toVC as! SpecieDetailsViewController).routeSpecieData = param as? Specie
            break
        case .StarshipDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "StarshipDetailsViewController")
            (toVC as! StarshipDetailsViewController).routeStarshipData = param as? Starship
            break
        case .VehicleDetails:
            toVC = from.storyboard!.instantiateViewController(withIdentifier: "VehicleDetailsViewController")
            (toVC as! VehicleDetailsViewController).routeVehiclepData = param as? Vehicle
            break
        }
        from.show(toVC, sender: nil)
    }
}

