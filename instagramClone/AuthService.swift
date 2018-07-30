//
//  AuthService.swift
//  instagramClone
//
//  Created by tolga iskender on 29.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class AuthService {
    
    static func signIn(email: String, password: String, basarili: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil
            {
                onError(error!.localizedDescription)
                return
            }
            basarili()
            
    }
        
        
}
    
    static func signUp(username:String, email: String, password: String, fullname:String, bio:String, imageData: Data, basarili: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void)
    {
        Auth.auth().createUser(withEmail: email , password: password) { (user, error) in
            if error != nil
            {
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.user.uid
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_resim").child((uid)!)
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/jpeg"
               
                storageRef.putData(imageData, metadata: metaDataForImage, completion: { (metadata, error) in
                    if error != nil
                    {
                        return
                    }
                    storageRef.downloadURL { url, error in
                        if error != nil {
                            return
                        } else {
                            self.userİnformation(profileImageUrl: (url?.absoluteString)!, username: username, email: email, password: password, fullname:fullname, bio:bio, uid: uid!, basarili: basarili)
                        }
                    }
                })
            
            
            
        }
    }
    static func userİnformation(profileImageUrl: String, username: String, email: String , password: String, fullname:String,bio:String, uid:String,basarili: @escaping () -> Void)
    {
        let ref = Database.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "fullname":fullname, "email":email, "password": password, "bio":bio, "profileImageUrl": profileImageUrl])
        basarili()
        
        
    }
    
}
