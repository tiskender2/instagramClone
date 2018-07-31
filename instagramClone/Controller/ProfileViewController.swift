//
//  ProfileViewController.swift
//  instagramClone
//
//  Created by tolga iskender on 28.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
class ProfileViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UIStackView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var profile_Edit: UIButton!
    @IBOutlet weak var isim_Label: UILabel!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.layer.cornerRadius = 45
        profile_image.clipsToBounds = true
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
        loadProfileData()
        loadPost()
      
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
                   self.profile_image.sd_setImage(with: URL(string: profilePhoto), completed: nil)
                }
                
                self.isim_Label.text = values["fullname"] as? String
                    
                self.bioLabel.text = values["bio"] as? String
               
                 
               
            }
        }
    }
    func loadPost()
    {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any]
            {
                let captionText = dict["caption"] as! String
                let photoUrlString = dict["photoUrl"] as! String
                let post = Post(captionText: captionText, photoUrlString: photoUrlString, profilPhotoUrl: "", fullName: "")
                self.posts.append(post)
                self.collectionView.reloadData()
                self.postLabel.text="\(self.posts.count)"
                ProgressHUD.showSuccess("Success")
            }
        }
    }


}
extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let width = view.frame.width
        let cellWidth = (width / 3) - 1
       
        return CGSize(width: cellWidth, height: cellWidth)
    }
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! postCollectionViewCell
         cell.postResim.sd_setImage(with: URL(string: posts[indexPath.row].photoUrl), completed: nil)
        return cell
        
    }
    
    
}
