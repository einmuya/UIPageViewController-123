//
//  PageViewController.swift
//  UIPageViewController
//
//  Created by Edward Muya on 22/01/2018.
//  Copyright © 2018 com.einmuya. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    // MARK: Properties
    var currentIndex = Int()
    var pageViewController: UIPageViewController?
    var viewControllers: [UIViewController]?
    
    fileprivate lazy var pageImages: [UIImage] = {
        return [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three")]
    }()
    
    // MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "UIPageViewController") as? UIPageViewController
        pageViewController?.dataSource = self
        self.pageViewController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview((pageViewController?.view)!)
        self.pageViewController?.didMove(toParentViewController: self)
        
        // bring views to front to enable user interaction
        self.view.bringSubview(toFront: stackView)
        
        if let firstViewController = self.viewControllerAtIndex(index: 0) {
            pageViewController?.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // setup pagecontrol + update indicators on swipe or on next button tap
        pageControl.numberOfPages = pageImages.count
        pageControl.currentPage = currentIndex
        
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (pageImages.count == 0) || (index >= (pageImages.count)) {
            return nil
        }
        
        let onboardingContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        onboardingContentViewController.pageImage = self.pageImages[index]
        onboardingContentViewController.pageIndex = index
        return onboardingContentViewController
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentIndex += 1
        let firstView = viewControllerAtIndex(index: 0)
        let secondView = viewControllerAtIndex(index: 1)
        let thirdView = viewControllerAtIndex(index: 2)
        
        let viewControllers = [firstView, secondView, thirdView]
        
        if currentIndex < self.pageImages.count {
            pageViewController?.setViewControllers([viewControllers[currentIndex]!], direction: .forward, animated: true, completion: nil)
            
            pageControl.currentPage = currentIndex
        }
        
        // update next button state
        nextButtonState()
    }
    
    func nextButtonState() {
        if currentIndex == 2 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        
        // Update pagecontrol index
        pageControl.currentPage = index
        
        currentIndex = index
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        // update next button state
        nextButtonState()
        
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        
        // Update pagecontrol index
        pageControl.currentPage = index
        
        currentIndex = index
        
        if index == NSNotFound {
            return nil
        }
        
        // update next button state
        nextButtonState()
        
        index += 1
        if index == self.pageImages.count {
            return nil
        }
        return self.viewControllerAtIndex(index: index)
    }
    
}
