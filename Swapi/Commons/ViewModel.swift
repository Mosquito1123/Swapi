//
//  ViewModel.swift
//  Swapi
//
//  Created by TuyenLe on 8/15/19.
//  Copyright © 2019 TuyenLe. All rights reserved.
//

import Foundation

protocol ImageScrollViewProtocol {
    var scrollView: UIScrollView { get }
    var leftArrow: UIButton { get }
    var rightArrow: UIButton { get }
    var pageIndex: Int { get set }
}

class ViewModel {
    
    var imageScrollViewProtocol: ImageScrollViewProtocol
    var detailsVC: UIViewController
    
    enum PageDirection {
        case left
        case right
        case same
    }

    // MARK: view constraints

    var imageScrollViewWidthConstraint: NSLayoutConstraint!

    var imageScrollViewLeftConstraint: NSLayoutConstraint!

    var imageScrollViewTopConstraint: NSLayoutConstraint!

    var imageScrollViewHeightConstraint: NSLayoutConstraint!

    var imageRightArrowTopConstraint: NSLayoutConstraint!

    var imageRightArrowHeightConstraint: NSLayoutConstraint!

    var imageLeftArrowTopConstraint: NSLayoutConstraint!

    var imageLeftArrowHeightConstraint: NSLayoutConstraint!

    // MARK: initialization

    init(imageScrollViewProtocol: ImageScrollViewProtocol, detailVC: UIViewController) {
        self.imageScrollViewProtocol = imageScrollViewProtocol
        self.detailsVC = detailVC
    }

    // MARK: view logic

    func charactersScrollViewSetup() {

        imageScrollViewProtocol.scrollView.contentSize = CGSize(width: imageScrollViewProtocol.scrollView.frame.width * 87, height: 0)
        setCharacter(page: .same)

        if UIDevice.current.orientation.isLandscape {
            imageScrollViewHeightConstraint = imageScrollViewProtocol.scrollView.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 2)
            imageLeftArrowHeightConstraint = imageScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 2)
            imageRightArrowHeightConstraint = imageScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 2)
        } else {
            imageScrollViewHeightConstraint = imageScrollViewProtocol.scrollView.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 5)
            imageLeftArrowHeightConstraint = imageScrollViewProtocol.leftArrow.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 5)
            imageRightArrowHeightConstraint = imageScrollViewProtocol.rightArrow.heightAnchor.constraint(equalToConstant: detailsVC.view.bounds.height / 5)
        }

        imageScrollViewHeightConstraint.isActive = true
        imageLeftArrowHeightConstraint.isActive = true
        imageRightArrowHeightConstraint.isActive = true

        imageScrollViewProtocol.scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollViewProtocol.leftArrow.translatesAutoresizingMaskIntoConstraints = false
        imageScrollViewProtocol.rightArrow.translatesAutoresizingMaskIntoConstraints = false

        imageScrollViewProtocol.scrollView.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)
        imageScrollViewProtocol.rightArrow.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)
        imageScrollViewProtocol.leftArrow.backgroundColor = UIColor(red: 125/241, green: 125/243, blue: 125/244, alpha: 0.1)

        imageScrollViewLeftConstraint = imageScrollViewProtocol.scrollView.leftAnchor.constraint(equalTo: detailsVC.view.leftAnchor, constant: 40)
        imageScrollViewLeftConstraint.isActive = true
        imageScrollViewWidthConstraint = imageScrollViewProtocol.scrollView.widthAnchor.constraint(equalToConstant: detailsVC.view.bounds.width - 80)
        imageScrollViewWidthConstraint.isActive = true
        imageScrollViewTopConstraint = imageScrollViewProtocol.scrollView.topAnchor.constraint(equalTo: detailsVC.view.topAnchor,
                                                                                         constant: detailsVC.navigationController?.navigationBar.frame.maxY ?? 0)
        imageScrollViewTopConstraint.isActive = true

        imageScrollViewProtocol.leftArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageScrollViewProtocol.leftArrow.leftAnchor.constraint(equalTo: detailsVC.view.leftAnchor).isActive = true
        imageLeftArrowTopConstraint = imageScrollViewProtocol.leftArrow.topAnchor.constraint(equalTo: detailsVC.view.topAnchor,
                                                                   constant: detailsVC.navigationController?.navigationBar.frame.maxY ?? 0)
        imageLeftArrowTopConstraint.isActive = true

        imageScrollViewProtocol.rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageScrollViewProtocol.rightArrow.rightAnchor.constraint(equalTo: detailsVC.view.rightAnchor).isActive = true
        imageRightArrowTopConstraint = imageScrollViewProtocol.rightArrow.topAnchor.constraint(equalTo: detailsVC.view.topAnchor,
                                                                     constant: detailsVC.navigationController?.navigationBar.frame.maxY ?? 0)
        imageRightArrowTopConstraint.isActive = true
    }

    func setCharacter(page: PageDirection) {
        var newPage = 0
        var scrollToVisibleRect = imageScrollViewProtocol.scrollView.frame.origin

        switch page {
        case .left:
            newPage = imageScrollViewProtocol.pageIndex - 1
            break
        case .right:
            newPage = imageScrollViewProtocol.pageIndex + 1
            break
        default:
            newPage = imageScrollViewProtocol.pageIndex
        }

        scrollToVisibleRect.x = imageScrollViewProtocol.scrollView.frame.width * CGFloat(newPage)
        scrollToVisibleRect.y = 0
        imageScrollViewProtocol.scrollView.setContentOffset(scrollToVisibleRect, animated: true)
        imageScrollViewProtocol.pageIndex = newPage
    }
    
    func updateConstraints(to size: CGSize) {

        if UIDevice.current.orientation.isLandscape {
            imageScrollViewHeightConstraint.constant = size.height / 2
            imageLeftArrowHeightConstraint.constant = size.height / 2
            imageRightArrowHeightConstraint.constant = size.height / 2
        } else if UIDevice.current.orientation.isPortrait {
            imageScrollViewHeightConstraint.constant = size.height / 5
            imageLeftArrowHeightConstraint.constant = size.height / 5
            imageRightArrowHeightConstraint.constant = size.height / 5
        }

        imageScrollViewTopConstraint.constant = detailsVC.navigationController?.navigationBar.frame.height ?? 0
        imageLeftArrowTopConstraint.constant = detailsVC.navigationController?.navigationBar.frame.height ?? 0
        imageRightArrowTopConstraint.constant = detailsVC.navigationController?.navigationBar.frame.height ?? 0
        imageScrollViewWidthConstraint.constant = size.width - 80
        imageScrollViewLeftConstraint.constant = 40
    }
}
