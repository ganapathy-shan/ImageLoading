//
//  ImageDownloader.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 12/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//
import UIKit
import NetworkService
typealias DownloadSuccess = (UIImage?)->Void
typealias DownloadFailed = (Bool)->Void

/**
class which downloads images from the URL. It maintains operation queue to facilitate concurrent image downloads
*/
class ImageDownloader {
    
    private var _downloadQueue:OperationQueue!
    private var downloadQueue:OperationQueue! {
        get { return _downloadQueue }
        set { _downloadQueue = newValue }
    }
    private var _downloadOperations:NSMutableDictionary!
    private var downloadOperations:NSMutableDictionary! {
        get { return _downloadOperations }
        set { _downloadOperations = newValue }
    }
    
    init(){
        _downloadQueue = OperationQueue()
        _downloadOperations = NSMutableDictionary()
    }
    
    func downloadFromURL(url:String!, saveInto cacheManger:FileCache!, success successBlock:@escaping DownloadSuccess, failure failureBlock:@escaping DownloadFailed) {
        let download:ImageDownloaderOperation = ImageDownloaderOperation(url: url, with:cacheManger)
        weak var weakDownload:ImageDownloaderOperation! = download
        download.completionBlock = {
            if weakDownload.isCancelled
            {
                failureBlock(true)
            }
            else
            {
                let image:UIImage! = UIImage(data: cacheManger.getFileForKey(key: url as NSString) as Data)
                successBlock(image)
            }
        }
        self.downloadOperations.setObject(download as Any, forKey:url! as NSCopying)
        self.downloadQueue.addOperation(download)
    }
    
    func cancelDownloadForURL(url:String!) {
        let downloadOperation:ImageDownloaderOperation! = self.downloadOperations.object(forKey: url as Any) as? ImageDownloaderOperation
        downloadOperation.cancel()
    }
}
