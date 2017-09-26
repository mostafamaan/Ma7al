//
//  FireBaseDataService.swift
//  Ma7al
//
//  Created by Mustafa on 9/23/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Firebase
import Foundation
class FireBaseDataService {
    
    private let ref = Database.database().reference()
    var likes : Bool?
    
    
    //not async dunno how to make this to work for now
    func observeLikes(id:String) -> Bool {
        
       var isItExist = false
        
    ref.child("NormalUsers").child((Auth.auth().currentUser?.uid)!).child("likes").child(id).observeSingleEvent(of: .value,  with: {(snapshot) in
        
        if snapshot.exists() {
            isItExist = false
        }
        else {
            isItExist = true
        }
            
       })
        
       return isItExist
        
    }
    
    
}
