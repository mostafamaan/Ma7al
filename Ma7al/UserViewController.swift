//
//  UserViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/19/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class UserViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    private let ref = Database.database().reference()
    
    let storeImageView : UIImageView = {
       let view = UIImageView()
        view.backgroundColor = UIColor.yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    let phoneNumberTextView : UITextView = {
       let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .right
        view.font?.withSize(20)
        view.text = "07701700107"
        return view
    }()
    let adressLabel :UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "سايدين المثنى قرب جامع فلان"
        return view
    }()
    let phoneNumberLabel : UILabel = {
       let view = UILabel()
        view.text = "رقم الهاتف:"
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
    /*    loadData {
            print("loaded")
        }*/
    }

    @IBAction func signOut(_ sender: Any) {
        
        try! Auth.auth().signOut()
       
        let manager = FBSDKLoginManager()
        manager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
         let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "login")
        
        present(initialViewController, animated: true, completion: nil)
        
        
    }
    
    
    func loadData(completed:@escaping DownloadComplete) {
        
        ref.child("storeUser").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value,  with: {(snapshot) in
            print(snapshot.value!)
             let dic = snapshot.value as! [String:Any]
            let shopName = dic["shopName"] as? String
            let phoneNumber = dic["phoneNumber"] as? String
            print(shopName)
            
            
        })
        completed()
        
        
    }
    
    func setupView() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.barTintColor = colors.tintColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: fonts.massariBluePrintFont(size: 18)]
        
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.tintColor = colors.tintColor
        tabBarController?.tabBar.backgroundColor = UIColor.white
        
        let views = [phoneNumberLabel,phoneNumberTextView,storeImageView,adressLabel]
        for view in views {
            containerView.addSubview(view)
        }
        containerView.addConsWithFormat(format: "H:|[v0]|", views: storeImageView)
        containerView.addConsWithFormat(format: "V:|[v0(200)]-2-[v1(60)]-2-[v2(60)]", views: storeImageView,phoneNumberLabel,adressLabel)
        containerView.addConsWithFormat(format: "H:[v0(100)]-2-[v1(100)]-1-|", views: phoneNumberTextView,phoneNumberLabel)
        containerView.addConsWithFormat(format: "V:|[v0(200)]-2-[v1(60)]", views: storeImageView,phoneNumberTextView)
        containerView.addConsWithFormat(format: "H:[v0]-1-|", views: adressLabel)
    }

}
