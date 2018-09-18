//
//  SignUpViewController.swift
//  Ma7al
//
//  Created by Mustafa on 9/25/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var countinerView: UIView!
    var storeImageUrl:String?
    //signup views
    let signUpEmailTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
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
        button.isEnabled = false
        
        
        return button
    }()
    
    let adressTextField:SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        //  textField.backgroundColor = UIColor.purple.withAlphaComponent(0.7)
        textField.textAlignment = .center
        textField.lineColor = colors.loginButtonColor
        textField.selectedTitleColor = colors.loginButtonColor
        textField.selectedLineColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "الموقع",
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.textColor = UIColor.white
        return textField
    }()
    
    let storeImageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.image = #imageLiteral(resourceName: "addImage.png")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //TODO:- add textfiled nill errro handling
    
    func signupButtonPressed(sender:UIButton) {
        
        
        if signUpPasswordTextField.text != nil || signUpPasswordTextField.text != nil || phoneNumberTextField.text != nil || adressTextField.text != nil || shopNameTextField.text != nil || storeImageUrl != nil {
            Auth.auth().createUser(withEmail: signUpEmailTextField.text!, password: signUpPasswordTextField.text!) { (user, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error creating user")
                }
                else {
                    //adding user to the database
                    let userData = CreateUserModel(shopName: self.shopNameTextField.text!, shopAdress: self.adressTextField.text!, email: self.signUpEmailTextField.text!, phoneNumber: self.phoneNumberTextField.text!, storeImageUrl: self.storeImageUrl!)
                    
                    let userDictionary = userData.CreateUserDictionary()
                    
                    ref.child("storeUser").child((user?.uid)!).setValue(userDictionary)
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
        }
        
        
        
        
    }
    
    
    func storeImageViewPressed() {
        //load the image picker
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //got the image
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
            uploadImageToFirebase(data: imageData!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func uploadImageToFirebase(data:Data){
        let uid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("storePhotos").child(uid + ".jpg")
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        let uploadTask =  storageRef.putData(data, metadata: uploadMetaData) { (metaData, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error uploading image")
            }
            else {
                print("uploaded to firebase storage")
                self.secondSignUpButton.isEnabled = true
                self.storeImageUrl = metaData?.downloadURL()?.absoluteString
                self.storeImageView.sd_setImage(with: metaData?.downloadURL())
            }
        }
        //update progress view
        uploadTask.observe(.progress) { [weak self] (snapshot) in
            guard let strongSelf = self else {return}
            guard let progress = snapshot.progress else {return}
            // update the progress view here instade of using self use strongself to get the progress view
            
        }
        
        
    }
    
    func setupView() {
        let viewsArray = [storeImageView,adressTextField,secondSignUpButton,phoneNumberTextField,shopNameTextField,signUpEmailTextField,signUpPasswordTextField]
        for view in viewsArray {
            self.view.addSubview(view)
            
            view.addShadow()
            
        }
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(storeImageViewPressed))
        storeImageView.addGestureRecognizer(tapGestrue)
        secondSignUpButton.addTarget(self, action: #selector(signupButtonPressed(sender:)), for: UIControlEvents.touchUpInside)
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
