//
//  SimultaniouslyScroll.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import Foundation
import UIKit
import SwiftUI

class SimultaneouslyScrollViewHandler: NSObject {
    private var scrollViews: [UIScrollView] = []
    private var scrollingScrollView: UIScrollView?
    
    func register(scrollView: UIScrollView) {
        guard !scrollViews.contains(scrollView) else {
            return
        }
        scrollView.delegate = self
        scrollViews.append(scrollView)
        guard let currentContentOffset = scrollViews
            .first?
            .contentOffset else {
            return
        }
        scrollView.setContentOffset(
            currentContentOffset,
            animated: false
        )
    }
}

extension SimultaneouslyScrollViewHandler: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingScrollView = scrollView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollingScrollView == scrollView else {
            return
        }
        scrollViews
            .filter { $0 != scrollingScrollView }
            .forEach {
                $0.setContentOffset(
                    scrollView.contentOffset,
                    animated: false
                )
            }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingScrollView = nil
    }
}

