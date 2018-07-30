//
//  EditViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 30.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import ImagePicker
class EditViewController: UIViewController,ImagePickerDelegate {
  

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var bio: UITextField!
    @IBOutlet weak var fullname: UITextField!
    var selectedImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        loadProfileData()
    }
    
    func loadProfileData()
    {
        if let userID = Auth.auth().currentUser?.uid
        {
            ProgressHUD.show("Loading...", interaction: false)
            Database.database().reference().child("users").child(userID).observe(.value) { (snapshot) in
                let values = snapshot.value as! NSDictionary
                
                if let profilePhoto = values["profileImageUrl"] as? String
                {
                    self.imageView.sd_setImage(with: URL(string: profilePhoto), completed: nil)
                }
                
                self.fullname.text = values["fullname"] as? String
                self.bio.text = values["bio"] as? String
                self.username.text =  values["username"] as? String
                ProgressHUD.showSuccess("Success")
                
                
            }
        }
    }
     func selectPhoto()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func cancel_click(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onay_click(_ sender: Any) {
        view.endEditing(true)
        updateUserProfile()
    }
    
    @IBAction func change_photo_click(_ sender: Any) {
         view.endEditing(true)
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ (UIAlertAction)in
            self.selectPhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .destructive , handler:{ (UIAlertAction)in
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.imageLimit = 1
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard let image = images.first else{
            dismiss(animated: true, completion: nil)
            return
        }
        selectedImage = image
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUserProfile()
    {
          ProgressHUD.show("Waiting...", interaction: false)
        if let userID = Auth.auth().currentUser?.uid
        {
            let storageItem = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("profile_resim").child(userID)
            guard let image = imageView.image else{return}
            if let newImage =  UIImageJPEGRepresentation(image, 0.1)
            {
                let metaDataForImage = StorageMetadata()
                metaDataForImage.contentType = "image/jpeg"
                storageItem.putData(newImage, metadata: metaDataForImage, completion: { (metadata, error) in
                    if error != nil
                    {
                        ProgressHUD.showError(error!.localizedDescription)
                        return
                    }
                    storageItem.downloadURL { url, error in
                        if error != nil {
                            ProgressHUD.showError(error!.localizedDescription)
                            return
                        }
                        else{
                           if let profilePhotoUrl = url?.absoluteString
                           {
                            guard let newUserName = self.username.text else {return}
                            guard let fullname = self.fullname.text else {return}
                            guard let bio = self.bio.text else {return}
                            
                            let newValues = ["username": newUserName, "fullname":fullname,"bio":bio, "profileImageUrl": profilePhotoUrl]
                            
                            Database.database().reference().child("users").child(userID).updateChildValues(newValues, withCompletionBlock: { (error, ref) in
                                if error != nil {
                                    ProgressHUD.showError(error!.localizedDescription)
                                    return
                                }
                                ProgressHUD.showSuccess("Success")
                                
                            })
                            
                            }
                        }
                    }
                })
            }
        }
    }
    
}
extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("calıstı")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            
            selectedImage = image
            imageView.image = image
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
