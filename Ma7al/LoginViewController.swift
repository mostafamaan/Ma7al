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
        textField.attributedPlaceholder = NSAttributedString(string: "الرمز السري",
                                                             attributes: [NSForegroundColorAttributeName: colors.textFiledTextColor])
        textField.textColor = UIColor.white
        
        return textField
    }()
    
    let adImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "store.png")
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    
    
    
    @IBOutlet weak var countinarView: UIView!
    let loginButton:FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupView()
        loginButton.delegate = self
        //REQUIRED BY FACEBOOK SDK TO GET THE EMAIL FROM A GRAPH REQUEST.
        //WITHOUT IT I CANT GET THE EAMIL ADDRESS
        loginButton.readPermissions = ["email"]
    }
    
    
    //MARK:- SKY FLOATING LABEL TEXTFILED DELEGATION CHEAKING FOR TYPING ERRORS.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //I HAVE TWO TEXTFILEDS SO I USE THE TAG TO IDENTIFY THEM.
        if textField.tag == 1 {
            if let text = textField.text {
                if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                    if(text.characters.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = "البريد الألكتروني غير صالح"
                        errorCheak = false
                        emailLoginButton.isEnabled = false
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string.
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
                        // The error message will only disappear when we reset it to nil or empty string.
                        floatingLabelTextField.errorMessage = ""
                        errorCheak = true
                        emailLoginButton.isEnabled = true
                    }
                }
            }
        }
        return true
    }
    
    //MAKR:- FACEBOOK LOGIN BUTTON DELEGATION.
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            //error here should do an alerte to it
            print(error.localizedDescription)
        }
        else {
            /* making a facebook graph request to get info about the loged in user,
             in this case im getting the id and email and the name,
             getting the id to add it to the firebase database as a node id,
             so i can cheak if the user info is exist in the database,
             to avoid overwritting.
             */
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start {
                (connection,result,err) in
                
                if err != nil {
                    //TODO:- ADDING AN ERROR ALEART.
                    print(err?.localizedDescription ?? "")
                    
                }
                    
                else {
                    //getting the access token from facebook
                    let accessToken = FBSDKAccessToken.current()
                    //getting the user info by using the access token above
                    let cerdentials = FacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
                    Auth.auth().signIn(with: cerdentials, completion: { (user, err) in
                        if err != nil {
                            //TODO:- ADDING AN ERROR ALEART.
                            print(err?.localizedDescription ?? "")
                        }
                        else {
                            //MAKING A DECTIONARY FROM THE USER.
                            let dic = ["displayName":user?.displayName,"email":user?.email,"photoUrl":user?.photoURL?.absoluteString]
                            //CHEAK IF IT EXSIT IN THE DATABASE
                            ref.child("NormalUsers").observeSingleEvent(of: .value, with: {(snapshot) in
                                if let snaps = snapshot.value as? [String:Any] {
                                    let uid = user?.uid
                                    //IF THE USER NOT EXSIT IN THE DATABASE THEN ADD IT TO IT.
                                    if !snaps.keys.contains(uid!) {
                                        ref.child("NormalUsers").child((user?.uid)!).setValue(dic)
                                    }
                                }
                            })
                            
                            //DONT KNOW WHY I ADD THIS I HAVE TO KNOW WHY
                            ref.child("NormalUsers").child("defualtUser").setValue(dic)
                            
                            //SWITCHING FROM LOGIN VIEW TO THE APP VIEW
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
    
    //MARK:- SETING UP SEGUE
    func signUpButtonPressed(sender:UIButton) {
        
        
        performSegue(withIdentifier: "signup", sender: self)
        
    }
    //MARK:- SIGN IN VIA EMAIL AND PASSWORD
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
    
    
    
    //for hiding the keyboard when pressing enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK:- SETING UP THE VIEWS AND ADDING FUNCTION TO THE BUTTONS
    func setupView() {
        self.emailLoginButton.addTarget(self, action: #selector(signInButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
        let viewsArray = [emailTextField,passwordTextField,signUpButton,emailLoginButton,loginButton,adImageView]
        for view in viewsArray {
            self.countinarView.addSubview(view)
            // view.addShadow()
        }
        //  adImageView.layer.cornerRadius = 130
        //  adImageView.layer.masksToBounds = false
        adImageView.clipsToBounds = true
        self.countinarView.addConsWithFormat(format: "H:|-100-[v0]-100-|", views: adImageView)
        
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
        self.countinarView.addConsWithFormat(format: "V:|-50-[v0(256)]-10-[v1(50)]-5-[v2(50)]-20-[v3(40)]-120-[v4(40)]-10-[v5(40)]-50-|", views: adImageView,self.emailTextField,self.passwordTextField,self.emailLoginButton,self.loginButton,self.signUpButton)
    }
    
    
    
    
}



