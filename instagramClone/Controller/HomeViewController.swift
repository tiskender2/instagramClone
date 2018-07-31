//
//  HomeViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 28.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class HomeViewController: UIViewController {
    var posts = [Post]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        loadPost()
    }
    func loadPost()
    {
         ProgressHUD.show("Loading...", interaction: false)
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]
            {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let profilPhoto = dict["photoUrl2"] as! String
                let fullname = dict["fullname"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString, profilPhotoUrl: profilPhoto, fullName: fullname)
                self.posts.append(post)
                self.tableView.reloadData()
                ProgressHUD.showSuccess("Success")
            }
        }
    }

    @IBAction func logOut(_ sender: Any) {
        
        do
        {
            try Auth.auth().signOut()
        } catch let logOutError {
            print(logOutError)
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signOutVc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.present(signOutVc, animated: true, completion: nil)
    }
    
    

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! postCellTableViewCell
        cell.profil_image.layer.cornerRadius = 18
        cell.profil_image.clipsToBounds = true
        cell.userName.text = posts[indexPath.row].fullname
        cell.profil_image.sd_setImage(with: URL(string: posts[indexPath.row].profilPhoto), completed: nil)
        cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].photoUrl), completed: nil)
        cell.caption.text = posts[indexPath.row].caption
        return cell
    }
}
