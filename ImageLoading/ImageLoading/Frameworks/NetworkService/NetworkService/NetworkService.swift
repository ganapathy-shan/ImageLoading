//
//  NetworkService.swift
//  NetworkService
//
//  Created by Shanmuganathan on 15/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit

import UIKit

public typealias DataTaskCompletionBlock = (Data, Error?)->Void

/**
class which provides the API for downloading any data from url
*/
open class NetworkService: NSObject {
    
    private var session : URLSession
    private var downloadTask : URLSessionTask?
    private var downloadCancelled : Bool = false
    
    public init(_ session:URLSession!) {
        self.session = session
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
                    if let cacheManager = cacheManager
                    {
                        cacheManager.setFile(data: data, forKey:url as NSString)
                    }
                    completionHandler(data, error)
                }
            })
            
            self.downloadTask?.resume()
        }
    }
    
    /**
       It cancels the current Download task
       */
    public func cancelDownload() {
        guard let downloadTask = self.downloadTask else { return }
        downloadCancelled = true
        if downloadTask.state == URLSessionTask.State.running
        {
            downloadTask.cancel()
        }
    }
}

