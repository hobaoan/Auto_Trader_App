//
//  PopupPresentationController.swift
//  AutoTrader
//
//  Created by An Bảo on 05/07/2024.
//

import UIKit

class PopupPresentationController: UIPresentationController {

    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let containerBounds = containerView.bounds
        let presentedViewContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        let presentedViewControllerFrame = CGRect(
            x: (containerBounds.width - presentedViewContentSize.width) / 2,
            y: (containerBounds.height - presentedViewContentSize.height) / 2,
            width: presentedViewContentSize.width,
            height: presentedViewContentSize.height
        )
        return presentedViewControllerFrame
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}

