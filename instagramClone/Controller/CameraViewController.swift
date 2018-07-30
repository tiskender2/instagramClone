//
//  CameraViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 28.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import ImagePicker
class CameraViewController: UIViewController,ImagePickerDelegate {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    @IBOutlet weak var remove: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.selectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    func handlePost()
    {
        if selectedImage != nil
        {
            self.shareButton.isEnabled = true
            self.remove.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else
        {
              self.shareButton.isEnabled = false
              self.remove.isEnabled = false
              self.shareButton.backgroundColor = .lightGray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func remove_click(_ sender: Any) {
        clean()
        handlePost()
    }
   
    @IBAction func cameraButton_click(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        guard let image = images.first else{
             dismiss(animated: true, completion: nil)
            return
        }
        selectedImage = image
        photo.image = image
        dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController)
    {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton_click(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1)
        {
            let photoId = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("posts").child((photoId))
            let metaDataForImage = StorageMetadata()
            metaDataForImage.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: metaDataForImage, completion: { (metadata, error) in
                if error != nil
                {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL { url, error in
                    if error != nil {
                        return
                    }
                    else{
                        self.sendDataToDatabase(photoUrl: (url?.absoluteString)!)
                    }
                }
            })

        } else
        {
            ProgressHUD.showError("İmage can't be empty")
        }
    }
    func sendDataToDatabase(photoUrl: String)
    {
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let newPostId = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPostId)
        newPostReference.setValue(["photoUrl":photoUrl, "caption": captionTextView.text!]) { (error, ref) in
            if error != nil
            {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
    }
    func clean()
    {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "photos")
        self.selectedImage = nil
    }
    
    @objc func selectPhoto()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
   

}
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("calıstı")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            
            selectedImage = image
            photo.image = image
           
        }
        
        dismiss(animated: true, completion: nil)
    }
}
