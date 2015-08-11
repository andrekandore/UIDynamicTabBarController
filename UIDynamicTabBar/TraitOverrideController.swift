//
//  TraitOverrideController.swift
//  TestLotsTabBar
//
//  Created by アンドレ on 2015/08/11.
//  Copyright © 2015年 Company. All rights reserved.
//

import UIKit

@available(iOS 8.0, *)
class TraitOverrideController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var forcedTraitCollection: UITraitCollection? {
        didSet {
            updateForcedTraitCollection()
        }
    }
    
    override func viewDidLoad() {
        setForcedTraitForSize(view.bounds.size)
    }
    
    var viewController: UIViewController? {
        willSet {
            if let previousVC = viewController {
                if newValue !== previousVC {
                    previousVC.willMoveToParentViewController(nil)
                    setOverrideTraitCollection(nil, forChildViewController: previousVC)
                    previousVC.view.removeFromSuperview()
                    previousVC.removeFromParentViewController()
                }
            }
        }
        
        didSet {
            if let vc = viewController {
                addChildViewController(vc)
                view.addSubview(vc.view)
                vc.didMoveToParentViewController(self)
                updateForcedTraitCollection()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setForcedTraitForSize(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    func setForcedTraitForSize(size: CGSize) {
        
        let device = traitCollection.userInterfaceIdiom
        var portrait: Bool {
            if device == .Phone {
                return size.width > 320
            } else {
                return size.width > 768
            }
        }
        
        switch (device, portrait) {
        case (.Phone, true):
            forcedTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        case (.Pad, false):
            forcedTraitCollection = UITraitCollection(horizontalSizeClass: .Compact)
        default:
            forcedTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        }
    }
    
    func updateForcedTraitCollection() {
        if let vc = viewController {
            setOverrideTraitCollection(self.forcedTraitCollection, forChildViewController: vc)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performSegueWithIdentifier("loadMain", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "loadMain" {
            let destinationVC = segue.destinationViewController as UIViewController
            viewController = destinationVC
        }
    }
    
    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
}
