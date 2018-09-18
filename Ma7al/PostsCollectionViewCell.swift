//
//  PostsCollectionViewCell.swift
//  Ma7al
//
//  Created by Mustafa on 9/14/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class PostsCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var containarView: UIView!
    
  //  private let ref = Database.database().reference()
    private var id:String?
    let dataService = FireBaseDataService()
    
    private var isLiked = false
  
    
    let imageView : UIImageView = {
        
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    
    let detaildView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        
        return view
        
    }()
    
    let cyanView : UIView = {
        let view = UIView()
        view.backgroundColor = colors.cyanBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        
        return view
        
    }()
    
    let lineView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = colors.lineViewBackgroundColor
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    
    let shoplabel : UILabel = {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .right
        view.font = fonts.massariBluePrintFont(size: 18)
        view.adjustsFontSizeToFitWidth = true
        view.textColor = colors.textColor
        return view
    }()
    
    let pricelabel : UILabel = {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = fonts.jennaFont(size: 16)
        view.textColor = colors.textColor
        return view
    }()
    
    let discriptionlabel : UILabel = {
        
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = fonts.jennaFont(size: 16)
        view.textAlignment = .right
        view.numberOfLines = 0
        view.sizeToFit()
        view.textColor = colors.textColor
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let likeImageView : UIImageView = {
        
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = #imageLiteral(resourceName: "heart (3).png")
        view.tintColor = UIColor.red
        view.isUserInteractionEnabled = true
        return view
    }()
    let likeLabel : UILabel = {
        let label = UILabel()
        label.font = fonts.jennaFont(size: 8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    let howManyLeftLabel:UILabel = {
        let label = UILabel()
        label.font = fonts.jennaFont(size: 9)
        label.textAlignment = .center
        label.text = "القطع المتبقية"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = colors.textColor
        
        return label
    }()
    
    let howManyLabel:UILabel = {
        let label = UILabel()
        label.font = fonts.jennaFont(size: 15)
        label.textAlignment = .center
        label.text = "30"
        label.textColor = colors.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    
    override func draw(_ rect: CGRect) {
       
        setupView()
        
    }
    
    
    func configureCell(post:Post) {
        let url = URL(string: post.imageUrl)
        self.imageView.sd_setImage(with:url!)
        self.pricelabel.text = post.price
        self.shoplabel.text = post.shopName
        self.discriptionlabel.text = post.description
        self.likeLabel.text = "\(post.likes)"
        self.id = post.id
        ref.child("NormalUsers").child((Auth.auth().currentUser?.uid)!).child("likes").child(id!).observeSingleEvent(of: .value,  with: {(snapshot) in
            print("likes value\(String(describing: snapshot.value))")
            if  !snapshot.exists() {
                self.likeImageView.image = #imageLiteral(resourceName: "heart (3).png")
                
            }
            else {
                self.likeImageView.image = #imageLiteral(resourceName: "heart (1).png")
            }
            
            
            
        })

       
        
    }
    
    
   
    
    func likeButtonPressed(sender:UITapGestureRecognizer) {
        var likes = Int(likeLabel.text!)
        likeImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            // animate it to the identity transform (100% scale)
            self.likeImageView.transform = CGAffineTransform.identity
        }, completion: {(_ finished: Bool) -> Void in
            // if you want to do something once the animation finishes, put it here
        })

        
        ref.child("NormalUsers").child((Auth.auth().currentUser?.uid)!).child("likes").child(id!).observeSingleEvent(of: .value,  with: {(snapshot) in
            
            if !snapshot.exists() {
                self.likeImageView.image = #imageLiteral(resourceName: "heart (1).png")
                likes = likes! + 1
                self.likeLabel.text = "\(likes!)"
                ref.child("posts").child(self.id!).child("likes").setValue(likes)
                ref.child("NormalUsers").child((Auth.auth().currentUser?.uid)!).child("likes").child(self.id!).setValue(true)

            }
            else {
                self.likeImageView.image = #imageLiteral(resourceName: "heart (3).png")
                likes = likes! - 1
                self.likeLabel.text = "\(likes!)"
                ref.child("posts").child(self.id!).child("likes").setValue(likes)
                ref.child("NormalUsers").child((Auth.auth().currentUser?.uid)!).child("likes").child(self.id!).removeValue()

            }
        })
    }
    
}


    extension PostsCollectionViewCell {
    func setupView() {
        
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(likeButtonPressed(sender:)))
        likeImageView.addGestureRecognizer(tapGestrue)
        //  containarView.addShadow()
        self.containarView.addSubview(imageView)
        self.imageView.addSubview(detaildView)
        detaildView.addSubview(self.discriptionlabel)
        detaildView.addSubview(cyanView)
        self.containarView.addSubview(shoplabel)
        self.cyanView.addSubview(pricelabel)
        self.cyanView.addSubview(lineView)
        self.imageView.addSubview(likeImageView)
        self.likeImageView.addSubview(likeLabel)
        self.cyanView.addSubview(howManyLeftLabel)
        self.cyanView.addSubview(howManyLabel)
        //  lineView.addShadow()
        self.containarView.addConsWithFormat(format: "H:|-1-[v0]-1-|", views: imageView)
        self.containarView.addConsWithFormat(format: "V:|-5-[v0(30)]-1-[v1]-1-|", views: shoplabel,imageView)
        self.containarView.addConsWithFormat(format: "H:[v0]-5-|", views: shoplabel)
        
        self.imageView.addConsWithFormat(format: "H:|[v0]|", views: detaildView)
        self.imageView.addConsWithFormat(format: "V:[v0(90)]|", views: detaildView)
        
        detaildView.addConsWithFormat(format: "V:|-3-[v0]-2-|", views: discriptionlabel)
        detaildView.addConsWithFormat(format: "H:|[v0(60)]-6-[v1]-10-|", views: cyanView,discriptionlabel)
        detaildView.addConsWithFormat(format: "V:|[v0]|", views: cyanView)
        
        self.cyanView.addConsWithFormat(format: "H:|[v0]|", views: pricelabel)
        self.cyanView.addConsWithFormat(format: "V:|-1-[v0(40)]-1-[v1(2)]-4-[v2(20)]-2-[v3(20)]-2-|", views: pricelabel,lineView,howManyLeftLabel,howManyLabel)
        self.cyanView.addConsWithFormat(format: "H:|[v0]|", views: howManyLabel)
        self.cyanView.addConsWithFormat(format: "H:|[v0]|", views: howManyLeftLabel)
        self.cyanView.addConsWithFormat(format: "H:|-1-[v0]-1-|", views: lineView)
        self.imageView.addConsWithFormat(format: "H:|-5-[v0(30)]", views: likeImageView)
        self.imageView.addConsWithFormat(format: "V:|-5-[v0(30)]", views: likeImageView)
        self.likeImageView.addConsWithFormat(format: "H:|-5-[v0]-5-|", views: likeLabel)
        self.likeImageView.addConsWithFormat(format: "V:|-2-[v0]-5-|", views: likeLabel)
    }
    
}

