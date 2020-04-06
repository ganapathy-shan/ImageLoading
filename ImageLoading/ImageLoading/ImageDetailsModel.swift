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
struct ImageDetailsModel : Decodable
{
    let userID : String
    let userName : String
    let imageURL : String
    
    enum CodingKeys : String, CodingKey {
        case user
        case userID = "id"
        case userName = "username"
        case profile_image
        case imageURL = "large"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let user = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        userID = try user.decode(String.self, forKey: .userID)
        userName = try user.decode(String.self, forKey: .userName)
        let profileImages = try user.nestedContainer(keyedBy: CodingKeys.self, forKey: .profile_image)
        imageURL = try profileImages.decode(String.self, forKey: .imageURL)
    }
}
