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
                let post = Post(captionText: captionText, photoUrlString: photoUrlString)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
}
