//
//  ImageDetailsModel.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 14/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import Foundation

/**
class that stores details about images
*/
class ImageDetailsModel
{
    let userID : String
    let userName : String
    let imageURL : String
    
    init(userID: String, userName: String, imageURL: String){
        self.userID = userID
        self.userName = userName
        self.imageURL = imageURL
    }
}
