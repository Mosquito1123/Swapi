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
        
        // set mask into constraints to false
        
        detailScrollViewProtocol.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.leftArrow.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.rightArrow.translatesAutoresizingMaskIntoConstraints = false
        detailScrollViewProtocol.mainScrollView.translatesAutoresizingMaskIntoConstraints = false

        // set up content size for main scroll view and image scroll view

        detailScrollViewProtocol.mainScrollView.contentSize = CGSize(width: detailsVC.view.frame.width, height: 0)
        detailScrollViewProtocol.imageScrollView.contentSize = CGSize(width: detailScrollViewProtocol.imageScrollView.frame.width * 87, height: 0)
        
        // vertical main scroll view constraints
        
        if #available(iOS 11.0, *) {
            detailScrollViewProtocol.mainScrollView.topAnchor.constraint(equalTo: detailsVC.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            detailScrollViewProtocol.mainScrollView.topAnchor.constraint(equalTo: detailsVC.topLayoutGuide.bottomAnchor, constant: 30).isActive = true
        }

        detailScrollViewProtocol.mainScrollView.heightAnchor.constraint(equalTo: detailsVC.view.heightAnchor).isActive = true
        detailScrollViewProtocol.imageScrollView.widthAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.widthAnchor, constant: -80).isActive = true

        // horizontal image scroll view constraints

        if UIDevice.current.orientation.isLandscape {
            detailScrollViewProtocol.imageScrollView.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
            detailScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
            detailScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
        } else {
            detailScrollViewProtocol.mainScrollView.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height).isActive = true
            detailScrollViewProtocol.imageScrollView.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
            detailScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
            detailScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailScrollViewProtocol.mainScrollView.bounds.height / 5).isActive = true
        }

        detailScrollViewProtocol.imageScrollView.leftAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.leftAnchor, constant: 40).isActive = true
        detailScrollViewProtocol.imageScrollView.topAnchor.constraint(equalTo:
            detailScrollViewProtocol.mainScrollView.topAnchor).isActive = true

        // horizontal image scroll view left arrow constraints

        detailScrollViewProtocol.leftArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        detailScrollViewProtocol.leftArrow.leftAnchor.constraint(equalTo: detailsVC.view.leftAnchor).isActive = true
        detailScrollViewProtocol.leftArrow.topAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.topAnchor).isActive = true

        // horizontal image scroll view right arrow constraints

        detailScrollViewProtocol.rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        detailScrollViewProtocol.rightArrow.rightAnchor.constraint(equalTo: detailsVC.view.rightAnchor).isActive = true
        detailScrollViewProtocol.rightArrow.topAnchor.constraint(equalTo: detailScrollViewProtocol.mainScrollView.topAnchor).isActive = true
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
            previousImageViewContentOffset = detailScrollViewProtocol.imageScrollView.contentOffset
        }
 
        detailScrollViewProtocol.pageIndex = newPage
    }
}
