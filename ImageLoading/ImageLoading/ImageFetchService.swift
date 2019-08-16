//
//  ImageFetchService.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 16/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit
typealias ImageFetchCompletion = (Array<ImageDetailsModel>?)->Void

import Foundation
import NetworkService
typealias LoadJsonSuccess = (Array<ImageDetailsModel>?)->Void

/**
class which provides the API to download image details from JSON 
*/

class ImageFetchService: NSObject {
    
    /**
    It fetches details and urls for all images from json downloaded from the given url  calls completionHandler with imageDetails

    - Parameters:
       - url: url to download json file
       - downloader : ImageDownloader instance which  downloads images asynchronously
       - completionBlock: block which gets called after download  completion with array of ImageDetails
    - Returns: N/A
    */
    public func fetchImageDetails(url : String, downloader : ImageDownloader, completion completionBlock :@escaping ImageFetchCompletion ){
        
        var imageModelArray : Array = Array<ImageDetailsModel>()
        let networkService:NetworkService = NetworkService(URLSession.shared)
        networkService.downloadFromURL(url: url, storeIn: nil) { (data : NSData, response :URLResponse, error : Error?) in
            
            let jsonData : Array = self.nsdataToJSON(data: data) as! Array<Any>
            
            for item in jsonData
            {
                let imagedictionary : NSDictionary = item as! NSDictionary
                let userID = imagedictionary.value(forKey: "id") as! String
                let userName =  ((imagedictionary.value(forKey: "user")) as! NSDictionary).value(forKey: "name") as! String
                let imageURL =  ((imagedictionary.value(forKey: "urls")) as! NSDictionary).value(forKey: "thumb") as! String
                let imageModel : ImageDetailsModel = ImageDetailsModel(userID: userID, userName: userName, imageURL: imageURL)
                imageModelArray.append(imageModel)
            }
            completionBlock(imageModelArray)
        }
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .fragmentsAllowed) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
