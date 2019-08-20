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
