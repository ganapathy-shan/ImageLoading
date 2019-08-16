//
//  NetworkService.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 12/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit

typealias DataTaskCompletionBlock = (NSData,URLResponse,Error?)->Void

class NetworkService {
    
    private var session:URLSession
    private var downloadTask:URLSessionTask?
    private var downloadCancelled:Bool = false
    
    init(_ session:URLSession!) {
        self.session = session
        self.downloadTask = nil
    }
    
    func downloadFromURL(url:String, storeIn cacheManager:FileCache?, completionHandler:@escaping DataTaskCompletionBlock) {
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
    
    
    func cancelDownload() {
        downloadCancelled = true
        if self.downloadTask?.state == URLSessionTask.State.running
        {self.downloadTask!.cancel()}
    }
}
