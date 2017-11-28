//
//  TimerPageViewController.swift
//  TimeSync
//
//  Created by Zackory Cramer on 11/18/17.
//  Copyright © 2017 Zackory Cramer. All rights reserved.
//

import UIKit

class TimerPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate{
    
    var currentIndex = 0
    var pageControl:UIPageControl!
    lazy var vc: [UIViewController] = {
        return [
            UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clockLabel"),
            UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "clockVisual"),
        ];
    }()
    
    func changeLabelTime(time:Double){
        (vc[1] as! TimeClockViewController).changeClockTime(time: time)
    }
    
    func changeLabelTime(time:String){
        (vc.first as! TimeLabelViewController).changeLabelTime(time: time)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vc.index(of: viewController) else {return nil}
        let preIndex = index - 1
        guard preIndex >= 0 else {return nil}
        guard vc.count > preIndex else {return nil}
        return vc[preIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vc.index(of: viewController) else {return nil}
        let preIndex = index + 1
        guard vc.count > preIndex else {return nil}
        return vc[preIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {return}
        if vc.index(of: previousViewControllers.first!) == 0{
            currentIndex = 1
        }else {
            currentIndex = 0
        }
        //pageControl.currentPage = currentIndex
        //pageControl.updateCurrentPageDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([vc.first!], direction: .forward, animated: true, completion: nil)
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                //scrollView.frame = UIScreen.main.bounds
            }
        }
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        /*pageControl = UIPageControl(frame: CGRect(x: 0, y: 100 - 50, width: 100, height: 50))//UIScreen.main.bounds.width
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        //pageControl.tintColor = UIColor.black
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        pageControl.transform = CGAffineTransform.init(scaleX: 3.0, y: 3.0)
        for view in pageControl.subviews{
            view.layer.backgroundColor = UIColor.red.cgColor
        }
        self.view.addSubview(pageControl)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.black
        appearance.currentPageIndicatorTintColor = UIColor.lightGray
        appearance.backgroundColor = UIColor.clear
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == 2 - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == 2 - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        setupPageControl()
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
