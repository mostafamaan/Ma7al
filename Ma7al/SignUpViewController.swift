//
//  SignUpViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/25/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var countinerView: UIView!
    //signup views
    let signUpEmailTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
      //  textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.lineColor = colors.loginButtonColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "البريد الألكتروني",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    let signUpPasswordTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
      //  textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.selectedTitleColor = colors.loginButtonColor
        textField.lineColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "الرمز السري",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    let shopNameTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
       // textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.lineColor = colors.loginButtonColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "اسم المحل",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    let phoneNumberTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
       // textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.lineColor = colors.loginButtonColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "رقم الهاتف",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    let secondSignUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("تسجيل محل", for: UIControlState.normal)
        button.backgroundColor = colors.loginButtonColor
        
        
        return button
    }()

    let adressTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
      //  textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.lineColor = colors.loginButtonColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "اسم المحل",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    
    let storeImageView : UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
   func setupView() {
   let viewsArray = [storeImageView,adressTextField,secondSignUpButton,phoneNumberTextField,shopNameTextField,signUpEmailTextField,signUpPasswordTextField]
     for view in viewsArray {
      self.view.addSubview(view)
      
       view.addShadow()
        
        
    }
    
    adressTextField.delegate = self
    phoneNumberTextField.delegate = self
    shopNameTextField.delegate = self
    signUpEmailTextField.delegate = self
    signUpPasswordTextField.delegate = self
    storeImageView.backgroundColor = UIColor.yellow
    self.view.addConsWithFormat(format: "H:|-100-[v0]-100-|", views: storeImageView)
    self.view.addConsWithFormat(format: "V:|-30-[v0(100)]-10-[v1(50)]-10-[v2(50)]-10-[v3(50)]-10-[v4(50)]-10-[v5(50)]-50-[v6(50)]", views: storeImageView,signUpEmailTextField,signUpPasswordTextField,phoneNumberTextField,shopNameTextField,adressTextField,secondSignUpButton)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: signUpPasswordTextField)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: signUpEmailTextField)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: phoneNumberTextField)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: shopNameTextField)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: adressTextField)
    self.view.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: secondSignUpButton)
   
    
   }
   
}
