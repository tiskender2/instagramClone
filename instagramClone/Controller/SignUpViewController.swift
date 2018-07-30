//
//  SignUpViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 28.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class SignUpViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var singUp_Button: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.backgroundColor = UIColor.clear
        usernameTextField.textColor = UIColor.white
        usernameTextField.tintColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUser = CALayer()
        bottomLayerUser.frame = CGRect(x: 0, y:29, width: usernameTextField.frame.width, height: 0.6)
        bottomLayerUser.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 25/255, alpha: 1).cgColor
        usernameTextField.layer.addSublayer(bottomLayerUser)
        
        fullName.backgroundColor = UIColor.clear
        fullName.textColor = UIColor.white
        fullName.tintColor = UIColor.white
        fullName.attributedPlaceholder = NSAttributedString(string: fullName.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerName = CALayer()
        bottomLayerName.frame = CGRect(x: 0, y:29, width: fullName.frame.width, height: 0.6)
        bottomLayerName.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 25/255, alpha: 1).cgColor
        fullName.layer.addSublayer(bottomLayerName)
        
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.textColor = UIColor.white
        emailTextField.tintColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y:29, width: emailTextField.frame.width, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 25/255, alpha: 1).cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)
        
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.textColor = UIColor.white
        passwordTextField.tintColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPass = CALayer()
        bottomLayerPass.frame = CGRect(x: 0, y:29, width: passwordTextField.frame.width, height: 0.6)
        bottomLayerPass.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 25/255, alpha: 1).cgColor
        passwordTextField.layer.addSublayer(bottomLayerPass)
        
     
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        selectedImage = UIImage(named: "user")
        singUp_Button.isEnabled = false
        handleTextField()
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func handleTextField()
    {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFielddidChange), for: UIControlEvents.editingChanged)
         emailTextField.addTarget(self, action: #selector(SignUpViewController.textFielddidChange), for: UIControlEvents.editingChanged)
         passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFielddidChange), for: UIControlEvents.editingChanged)
    }
    @objc func textFielddidChange()
    {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            singUp_Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            
            return
        }
        singUp_Button.setTitleColor(UIColor.white, for: UIControlState.normal)
         singUp_Button.isEnabled = true
    }
    @objc func selectProfileImage()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_click(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1)
        {
            AuthService.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!,fullname:fullName.text!,bio: "", imageData: imageData, basarili: {
                ProgressHUD.showSuccess("Success")
                self.performSegue(withIdentifier: "signupTabbarVC", sender: nil)
            }) { (errorString) in
               ProgressHUD.showError(errorString)
            }
        }
    }
  
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print("calıstı")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            
            selectedImage = image
            profileImage.image = image
            profileImage.layer.cornerRadius = 30
            profileImage.clipsToBounds = true
        }
      
        dismiss(animated: true, completion: nil)
    }
}
