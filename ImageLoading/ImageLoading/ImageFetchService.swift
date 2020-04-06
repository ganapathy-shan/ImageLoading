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
        
        let networkService:NetworkService = NetworkService(URLSession.shared)
        networkService.downloadFromURL(url: url, storeIn: nil) { (data : Data, error : Error?) in
            
            do {
                let imageModel = try JSONDecoder().decode([ImageDetailsModel].self, from: data)
                completionBlock(imageModel)
            } catch {
                print(error.localizedDescription)
                completionBlock(nil)
            }

        }
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
