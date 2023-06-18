//
//  PersonalPageViewController.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/15.
//

import UIKit

protocol PersonalPageViewControllerDelegate: AnyObject {
    func updateTabCell(index: Int)
}

class PersonalPageViewController: UIPageViewController {
    var pageViewControllers = [PersonalViewController]()
    var currentViewController: PersonalViewController?
    var currentIndex: Int = 0

    weak var pageDelegate: PersonalPageViewControllerDelegate?
    weak var scrollDelegate: ScrollDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<5 {
            let colors: [UIColor] = [.black, .blue, .brown, .cyan, .purple]
            let viewController = PersonalViewController()
            viewController.view.backgroundColor = colors[index]
            viewController.delegate = self
            self.pageViewControllers.append(viewController)
            
        }
        
        self.delegate = self
        self.dataSource = self
        if let firstViewController = pageViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        
    }
    
    func updatePage(_ index: Int) {
        let viewController = self.pageViewControllers[index]

        let direction: UIPageViewController.NavigationDirection = self.currentIndex <= index ? .forward : .reverse
        self.currentIndex = index
        
        self.setViewControllers([viewController], direction: direction, animated: true) { (result) in }
    }
    
}

extension PersonalPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers,
              viewControllers.count > 0,
              let viewController = viewControllers.first as? PersonalViewController,
              let index = pageViewControllers.firstIndex(of: viewController) else {
            return
        }
        
        self.pageDelegate?.updateTabCell(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? PersonalViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let beforeIndex = index - 1
            currentIndex = index
            if beforeIndex >= 0, beforeIndex < pageViewControllers.count {
                currentViewController = pageViewControllers[beforeIndex]
                return pageViewControllers[beforeIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController =  viewController as? PersonalViewController {
            guard let index = pageViewControllers.firstIndex(of: viewController) else { return nil }
            let afterIndex = index + 1
            currentIndex = index
            if afterIndex >= 0, afterIndex < pageViewControllers.count {
                currentViewController = pageViewControllers[afterIndex]
                return pageViewControllers[afterIndex]
            }
        }
        return nil
        
    }
    
    
}

extension PersonalPageViewController: ScrollDelegate {
    
    func scrollUp(to height: CGFloat) {
        scrollDelegate?.scrollUp(to: height)
    }
    
    func scrollDown(to height: CGFloat) {
        scrollDelegate?.scrollDown(to: height)
    }
    
}
