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
    
    enum PageDirection {
        case left
        case right
        case same
    }

    // MARK: horizontal image view constraints

    var imageScrollViewWidthConstraint: NSLayoutConstraint!

    var imageScrollViewLeftConstraint: NSLayoutConstraint!

    var imageScrollViewTopConstraint: NSLayoutConstraint!

    var imageScrollViewHeightConstraint: NSLayoutConstraint!

    var imageRightArrowTopConstraint: NSLayoutConstraint!

    var imageRightArrowHeightConstraint: NSLayoutConstraint!

    var imageLeftArrowTopConstraint: NSLayoutConstraint!

    var imageLeftArrowHeightConstraint: NSLayoutConstraint!
    
    // MARK: vertical main view constraints
    
    var mainScrollViewTopConstraint: NSLayoutConstraint!
    
    var mainScrollViewHeightConstraint: NSLayoutConstraint!

    // MARK: initialization

    init(detailScrollViewProtocol: DetailScrollViewProtocol, detailVC: UIViewController) {
        self.detailScrollViewProtocol = detailScrollViewProtocol
        self.detailsVC = detailVC
    }

    // MARK: view logic

    func scrollViewSetup() {
        
        detailScrollViewProtocol.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.leftArrow.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.rightArrow.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.mainScrollView.translatesAutoresizingMaskIntoConstraints = false

        // set up content size for main scroll view and image scroll view

        detailScrollViewProtocol.mainScrollView.contentSize = CGSize(width: detailsVC.view.frame.width, height: 0)
        detailScrollViewProtocol.imageScrollView.contentSize = CGSize(width: detailScrollViewProtocol.imageScrollView.frame.width * 87, height: 0)
        set(direction: .same)
        
        // vertical main scroll view constraints
        
        mainScrollViewTopConstraint = detailScrollViewProtocol.mainScrollView.topAnchor.constraint(equalTo: detailsVC.view.topAnchor, constant: detailsVC.navigationController?.navigationBar.frame.maxY ?? 0)
        mainScrollViewTopConstraint.isActive = true
        mainScrollViewHeightConstraint = detailScrollViewProtocol.mainScrollView.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height)
        mainScrollViewHeightConstraint.isActive = true
        imageScrollViewWidthConstraint = detailScrollViewProtocol.imageScrollView.widthAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.widthAnchor, constant: -80)
        imageScrollViewWidthConstraint.isActive = true

        // horizontal image scroll view constraints

        if UIDevice.current.orientation.isLandscape {
            imageScrollViewHeightConstraint = detailScrollViewProtocol.imageScrollView.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 2)
            imageLeftArrowHeightConstraint = detailScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 2)
            imageRightArrowHeightConstraint = detailScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 2)
        } else {
            mainScrollViewHeightConstraint = detailScrollViewProtocol.mainScrollView.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height)
            imageScrollViewHeightConstraint = detailScrollViewProtocol.imageScrollView.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5)
            imageLeftArrowHeightConstraint = detailScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5)
            imageRightArrowHeightConstraint = detailScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5)
        }

        imageScrollViewHeightConstraint.isActive = true
        imageLeftArrowHeightConstraint.isActive = true
        imageRightArrowHeightConstraint.isActive = true

        detailScrollViewProtocol.imageScrollView.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)
        detailScrollViewProtocol.rightArrow.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)
        detailScrollViewProtocol.leftArrow.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)

        imageScrollViewLeftConstraint = detailScrollViewProtocol.imageScrollView.leftAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.leftAnchor, constant: 40)
        imageScrollViewLeftConstraint.isActive = true
        imageScrollViewTopConstraint = detailScrollViewProtocol.imageScrollView.topAnchor.constraint(equalTo:
            detailScrollViewProtocol.mainScrollView.topAnchor)
        imageScrollViewTopConstraint.isActive = true

        // horizontal image scroll view left arrow constraints

        detailScrollViewProtocol.leftArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        detailScrollViewProtocol.leftArrow.leftAnchor.constraint(equalTo: detailsVC.view.leftAnchor).isActive = true
        imageLeftArrowTopConstraint = detailScrollViewProtocol.leftArrow.topAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.topAnchor)
        imageLeftArrowTopConstraint.isActive = true

        // horizontal image scroll view right arrow constraints

        detailScrollViewProtocol.rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        detailScrollViewProtocol.rightArrow.rightAnchor.constraint(equalTo: detailsVC.view.rightAnchor).isActive = true
        imageRightArrowTopConstraint = detailScrollViewProtocol.rightArrow.topAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.topAnchor)
        imageRightArrowTopConstraint.isActive = true
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
        }

        scrollToVisibleRect.x = detailScrollViewProtocol.imageScrollView.frame.width * CGFloat(newPage)
        scrollToVisibleRect.y = 0
        detailScrollViewProtocol.imageScrollView.setContentOffset(scrollToVisibleRect, animated: true)
        detailScrollViewProtocol.pageIndex = newPage
    }
    
    func updateConstraints(to size: CGSize) {

        if UIDevice.current.orientation.isLandscape {
            mainScrollViewTopConstraint.constant /= 2
            imageScrollViewHeightConstraint.constant = size.height / 2
            imageLeftArrowHeightConstraint.constant = size.height / 2
            imageRightArrowHeightConstraint.constant = size.height / 2
        } else if UIDevice.current.orientation.isPortrait {
            mainScrollViewTopConstraint.constant *= 2
            imageScrollViewHeightConstraint.constant = size.height / 5 + 44
            imageLeftArrowHeightConstraint.constant = size.height / 5 + 44
            imageRightArrowHeightConstraint.constant = size.height / 5 + 44
        }

        imageScrollViewLeftConstraint.constant = 40
    }
}
