//
//  Post.swift
//  Ma7al
//
//  Created by Mustafa on 9/14/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation


class Post {
    
  private  var _price: String?
  private  var _likes: Int?
  private  var _imageUrl: String?
  private  var _description:String?
  private  var _shopName:String?
  private  var _images:[String:String]?
  private  var _id:String?
  private  var _timeStamp : Int
    
    var price:String {
        return _price!
    }
    var likes:Int {
        return _likes!
    }
    var imageUrl:String {
        return _imageUrl!
    }
    var description:String {
        return _description!
    }
    var shopName:String {
        return _shopName!
    }
    var images:[String:String] {
        return _images!
    }
    
    var id:String? {
        return _id
    }
    
    var timeStamp : Int {
        return _timeStamp
    }
    
    //dont forget you cant make multipl init :)
    
    init(price:String,likes:Int,imageUrl:String,description:String,shopName:String,images:[String:String],id:String,timeStamp:Int) {
        self._price = price
        self._likes = likes
        self._imageUrl = imageUrl
        self._description = description
        self._shopName = shopName
        self._images = images
        self._id = id
        self._timeStamp = timeStamp
        
    }
}
