//
//  NetworkService.swift
//  NetworkService
//
//  Created by Shanmuganathan on 15/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit

import UIKit

public typealias DataTaskCompletionBlock = (NSData,URLResponse,Error?)->Void

/**
class which provides the API for downloading any data from url
*/
open class NetworkService: NSObject {
    
    private var session:URLSession
    private var downloadTask:URLSessionTask?
    private var downloadCancelled:Bool = false
    
    public init(_ session:URLSession!) {
        self.session = session
        self.downloadTask = nil
    }
    
    /**
    It download data from the url and calls completionHandler with Data

    - Parameters:
       - url: url to download data
       - completionHandler: block which gets called after download  completion
    - Returns: N/A
    */
    public func downloadFromURL(url:String, storeIn cacheManager:FileCache?, completionHandler:@escaping DataTaskCompletionBlock) {
        if !downloadCancelled {
            
            self.downloadTask = self.session.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
                if let data = data
                {
                    if data.count > 0
                    {
                        if cacheManager != nil
                        {
                            cacheManager!.setFile(data: data as NSData, forKey:url as NSString)
                        }
                        completionHandler(data as NSData,response!,error)
                    }
                }
            })
            
            self.downloadTask!.resume()
        }
    }
    
    /**
       It cancels the current Download task
       */
    public func cancelDownload() {
        downloadCancelled = true
        if self.downloadTask?.state == URLSessionTask.State.running
        {self.downloadTask!.cancel()}
    }
}

