//
//  ViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 28.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        handleTextField()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil
        {
            self.performSegue(withIdentifier: "signinTabbarVC", sender: nil)
        }
    }
    func handleTextField()
    {
        emailTextField.addTarget(self, action: #selector(ViewController.textFielddidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(ViewController.textFielddidChange), for: UIControlEvents.editingChanged)
    }
    @objc func textFielddidChange()
    {
        guard  let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signIn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signIn.isEnabled = false
            return
        }
        signIn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signIn.isEnabled = true
    }

    @IBAction func singin_click(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        AuthService.signIn(email: emailTextField.text!, password: passwordTextField.text!, basarili: {
            ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signinTabbarVC", sender: nil)
        }, onError: {error in
            ProgressHUD.showError(error)
            
        })
        
        
    }
    

}

