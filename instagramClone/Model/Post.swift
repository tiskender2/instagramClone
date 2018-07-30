//
//  Post.swift
//  instagramClone
//
//  Created by tolga iskender on 29.07.2018.
//  Copyright © 2018 tolga iskender. All rights reserved.
//

import Foundation
class Post {
    
    var caption: String
    var photoUrl: String
    
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
}
