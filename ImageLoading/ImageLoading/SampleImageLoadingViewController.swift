//
//  SampleImageLoadingViewController.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 12/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit
import NetworkService

/**
class which is used to test image downloader class
*/
class SampleImageLoadingViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private var downloader: ImageDownloader!
    private var cacheManager: FileCache!
    
    override func viewDidLoad() {
        downloader = ImageDownloader()
        cacheManager = FileCache(size: 100)
    }
    
    @IBAction func cancelDownload(_ sender: Any) {
        downloader?.cancelDownloadForURL(url: "https://images.unsplash.com/photo-1464550883968-cec281c19761")
    }
    
    @IBAction func startDownload(_ sender: Any) {
        
        let imageData: NSData! = (cacheManager?.getFileForKey(key: "https://images.unsplash.com/photo-1464550883968-cec281c19761"))
        if imageData != nil
        {
            imageView.image = UIImage(data: imageData! as Data)
        }
        else
        {
            downloader.downloadFromURL(url: "https://images.unsplash.com/photo-1464550883968-cec281c19761", saveInto: cacheManager, success: { (image: UIImage?) in
                if image != nil
                {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            })
            { (isCancelled: Bool) in
                
            }
        }
        
    }
    
    @IBAction func resetImageView(_ sender: Any)  {
        imageView.image = nil
    }
}
