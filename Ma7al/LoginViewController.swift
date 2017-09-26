//
//  LoginViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/17/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import SkyFloatingLabelTextField

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate,UITextFieldDelegate {

    private var errorCheak = false
    
    let signUpButton : UIButton = {
       let button = UIButton()
        button.setTitle("تسجيل محل", for: UIControlState.normal)
        button.backgroundColor = colors.loginButtonColor
        
        
        return button
    }()
    let emailLoginButton : UIButton = {
        let button = UIButton()
        button.setTitle("تسجيل دخول محل", for: UIControlState.normal)
        button.backgroundColor = colors.loginButtonColor
        
        
        return button
    }()
    
    let emailTextField : SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
       // textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .left
        textField.lineColor = colors.textFiledTextColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.iconFont = UIFont(name: "FontAwesome", size: 15)
        textField.iconText = "\u{f0e0}"
        textField.tag = 1
        textField.attributedPlaceholder = NSAttributedString(string: "البريد الألكتروني",
                                                             attributes: [NSForegroundColorAttributeName: colors.textFiledTextColor])
        textField.textColor = UIColor.white
        return textField
    }()
   
    let passwordTextField : SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextFieldWithIcon()
        textField.textAlignment = .left
        textField.lineColor = colors.textFiledTextColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.iconFont = UIFont(name: "FontAwesome", size: 15)
        textField.iconText = "\u{f084}"
        textField.tag = 2
        textField.isSecureTextEntry = true
        
      //  textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.attributedPlaceholder = NSAttributedString(string: "الرمز السري",
                                                             attributes: [NSForegroundColorAttributeName: colors.textFiledTextColor])
        textField.textColor = UIColor.white
        
        return textField
    }()
    
    let adImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo.png")
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    
    
    
   
    
    @IBOutlet weak var countinarView: UIView!
    let loginButton:FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        
        return button
    }()
    
    private let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupView()
        loginButton.delegate = self
        loginButton.readPermissions = ["email"]
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "البريد الألكتروني غير صالح"
                        errorCheak = false
                        emailLoginButton.isEnabled = false
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                        errorCheak = true
                        emailLoginButton.isEnabled = true
                    }
                }
            }

        }
        else {
            
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count < 6) {
                        floatingLabelTextField.errorMessage = "الرمز السري قصير جدا"
                        errorCheak = false
                        emailLoginButton.isEnabled = false
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                        errorCheak = true
                        emailLoginButton.isEnabled = true
                    }
                }
            }
        }
        return true
    }

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
        }
        else {
           
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start {
            (connection,result,err) in
                
                if err != nil {
                    print(err?.localizedDescription ?? "")
                    
                }
            
                else {
                    let accessToken = FBSDKAccessToken.current()
                    let cerdentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
                    Auth.auth().signIn(with: cerdentials, completion: { (user, err) in
                        if err != nil {
                            print(err?.localizedDescription ?? "")
                        }
                        else {
                            print("login to firebase", user?.photoURL ?? "")
                            let dic = ["displayName":user?.displayName,"email":user?.email,"photoUrl":user?.photoURL?.absoluteString]
                            self.ref.child("NormalUsers").observeSingleEvent(of: .value, with: {(snapshot) in
                                if let snaps = snapshot.value as? [String:Any] {
                                    let uid = user?.uid
                                    if !snaps.keys.contains(uid!) {
                                        self.ref.child("NormalUsers").child((user?.uid)!).setValue(dic)
                                    }
                                }
                            })
                            self.ref.child("NormalUsers").child("defualtUser").setValue(dic)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "init")
                            //just need a loading indicatier to pass time until the view is loaded
                            self.present(initialViewController, animated: true, completion: nil)

                        }
                    })
                }
            
            
            }
        }
    }
   func signUpButtonPressed(sender:UIButton) {
    
    
    performSegue(withIdentifier: "signup", sender: self)
        
    }
    
    func signInButtonPressed(sender:UIButton) {
        
        if errorCheak {
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, err) in
            if err != nil {
                print(err?.localizedDescription ?? "error sign in user")
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "init")
                //just need a loading indicatier to pass time until the view is loaded
                self.present(initialViewController, animated: true, completion: nil)
            }
        })
    }
    }
    
    
 /*   func secondSignUpButtonPressed(sender:UIButton) {
        
        
        Auth.auth().createUser(withEmail: signUpEmailTextField.text!, password: signUpPasswordTextField.text!) { (user, err) in
            if err != nil {
                print(err?.localizedDescription ?? "error creating user")
            }
            else {
                //adding user to the database
                let userDictionary = ["shopName":self.shopNameTextField.text!,"email":self.signUpEmailTextField.text!,"phoneNumber":self.phoneNumberTextField.text!]
                self.ref.child("storeUser").child((user?.uid)!).setValue(userDictionary)
                Auth.auth().signIn(withEmail: self.signUpEmailTextField.text!, password: self.signUpPasswordTextField.text!, completion: { (user, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "error sign in user")
                    }
                    else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "init")
                        //just need a loading indicatier to pass time until the view is loaded
                        self.present(initialViewController, animated: true, completion: nil)
                    }
                })
                
            }
        }
        
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func setupView() {
        self.emailLoginButton.addTarget(self, action: #selector(signInButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        let viewsArray = [emailTextField,passwordTextField,signUpButton,emailLoginButton,loginButton,adImageView]
        for view in viewsArray {
            self.countinarView.addSubview(view)
           // view.addShadow()
        }
        adImageView.layer.cornerRadius = 130
        adImageView.layer.masksToBounds = false
        adImageView.clipsToBounds = true
        self.countinarView.addConsWithFormat(format: "H:|-90-[v0(256)]", views: adImageView)
        
        self.countinarView.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: emailTextField)
        self.countinarView.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: passwordTextField)
        self.countinarView.addConsWithFormat(format: "H:|-10-[v0]-10-|", views: self.signUpButton)
        self.countinarView.addConsWithFormat(format: "H:|-30-[v0]-30-|", views: self.emailLoginButton)
        self.loginButton.layer.cornerRadius = 5
        self.emailLoginButton.layer.cornerRadius = 5
        self.signUpButton.addShadow()
        self.signUpButton.layer.cornerRadius = 5
        loginButton.addShadow()
        self.countinarView.addConsWithFormat(format: "H:|-10-[v0]-10-|", views: loginButton)
        self.countinarView.addConsWithFormat(format: "V:[v0(256)]-10-[v1(50)]-5-[v2(50)]-20-[v3(40)]-120-[v4(40)]-10-[v5(40)]-50-|", views: adImageView,self.emailTextField,self.passwordTextField,self.emailLoginButton,self.loginButton,self.signUpButton)
    }
    
   
    
    
}



