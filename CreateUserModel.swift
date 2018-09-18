//
//  CreateUserModel.swift
//  Ma7al
//
//  Created by Mustafa on 10/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation


class CreateUserModel {
    
    
    private var _shopName:String?
    private var _shopAdress : String?
    private var _email:String?
    private var _phoneNumber:String?
    private var _storeImageUrl:String?
    
    
  /*  var shopName : String {
        return _shopName!
    }
    
    var shopAdress : String {
        return _shopAdress!
    }
    
    var email : String {
        return _email!
    }
    
    var phoneNumber : String {
        return _phoneNumber!
    }
    
    var storeImageUrl : String {
        return _storeImageUrl!
    }*/
    
    
    init(shopName:String,shopAdress:String,email:String,phoneNumber:String,storeImageUrl:String) {
        self._shopName = shopName
        self._shopAdress = shopAdress
        self._email = email
        self._phoneNumber = phoneNumber
        self._storeImageUrl = storeImageUrl
    }
    
    
    func CreateUserDictionary() -> [String:String] {
        var dic = [String:String]()
        dic["shopName"] = self._shopName
        dic["email"] = self._email
        dic["phoneNumber"] = self._phoneNumber
        dic["address"] = self._shopAdress
        dic["storeImageUrl"] = self._storeImageUrl
        
        
        return dic
    }
    
}
