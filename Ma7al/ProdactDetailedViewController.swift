//
//  ProdactDetailedViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/16/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import ImageSlideshow


class ProdactDetailedViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var countaierView: UIView!
    @IBOutlet var imageSlideShow: ImageSlideshow!
    
    var post:Post?
    
    private var imageSource = [InputSource]()
    private var imagesUrl = [String]()
    
    let pricelabel : UILabel = {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = fonts.jennaFont(size: 16)
        view.textColor = colors.textColor
        view.layer.borderColor = colors.borderColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    let discriptionlabel : UILabel = {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = fonts.jennaFont(size: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.sizeToFit()
        view.textColor = colors.textColor
        view.adjustsFontSizeToFitWidth = true
        
        return view
    }()
    
    
    let howManyLabel:UILabel = {
        let label = UILabel()
        label.font = fonts.jennaFont(size: 14)
        label.textAlignment = .center
        label.text = "30"
        label.textColor = colors.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = colors.borderColor
        label.layer.borderWidth = 0.5
        
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        pricelabel.text = post?.price
        howManyLabel.text = howManyLabel.text! + " قطعة متبقية "
        discriptionlabel.text = post?.description
        self.title = post?.shopName
        
        if post?.images != nil {
            
            for (_, image) in (post?.images)! {
                imageSource.append(SDWebImageSource(urlString: image)!)
                
            }
            
        }
        
        // setting image source
        imageSlideShow.setImageInputs(imageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProdactDetailedViewController.didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
        
        
    }
    
    
    @objc private func didTap() {
        let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    
    
    @objc private func setupView() {
        self.automaticallyAdjustsScrollViewInsets = false
        imageSlideShow.translatesAutoresizingMaskIntoConstraints = false
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: fonts.massariBluePrintFont(size: 18)]
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.tintColor = colors.tintColor
        tabBarController?.tabBar.backgroundColor = UIColor.white
        
        self.countaierView.addSubview(pricelabel)
        self.countaierView.addSubview(discriptionlabel)
        self.countaierView.addSubview(howManyLabel)
        self.discriptionlabel.addShadow()
        self.pricelabel.addShadow()
        self.howManyLabel.addShadow()
        self.countaierView.addConsWithFormat(format: "H:|[v0]|", views: imageSlideShow)
        self.countaierView.addConsWithFormat(format: "V:|[v0(300)]-10-[v1(65)]", views: imageSlideShow,discriptionlabel)
        self.countaierView.addConsWithFormat(format: "V:|[v0(300)]-10-[v1(30)]-5-[v2(30)]-10-[v3]", views: imageSlideShow,pricelabel,howManyLabel,longDescriptionLabel)
        
        self.countaierView.addConsWithFormat(format: "H:|-10-[v0]-5-[v1(100)]-10-|", views:  discriptionlabel,pricelabel)
        self.countaierView.addConsWithFormat(format: "H:[v0(100)]-10-|", views: howManyLabel)
        self.countaierView.addConsWithFormat(format: "H:|-10-[v0]-10-|", views: longDescriptionLabel)
        imageSlideShow.backgroundColor = UIColor.white
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageControlPosition = PageControlPosition.underScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor(red:0.15, green:0.32, blue:0.54, alpha:1.0)
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.currentPageChanged = { page in
            // print("current page:", page)
        }
        
        
        
    }
}


