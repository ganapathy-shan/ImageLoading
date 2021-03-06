//
//  ImageCollectionViewController.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 14/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit
import NetworkService

private let reuseIdentifier = "Cell"
private let IMAGE_WIDTH = 200.0
private let IMAGE_HEIGHT = 200.0
private let JSONURL = "http://pastebin.com/raw/wgkJgazE"

/**
class which downloads and shows list of images in UIcollectionView
*/
class ImageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public var userDetailsArray: Array<UserDetailsModel>?
    private var cacheManager: FileCache?
    private var downloader: ImageDownloader = ImageDownloader()
    private let refreshControl : UIRefreshControl = UIRefreshControl()
    private let loadingAlert : UIAlertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    private let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cacheManager = FileCache(size: 100)
        
        fetchUserDetailsFromJson()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        refreshControl.addTarget(self, action: #selector(refreshImages(_:)), for: .valueChanged)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
 
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        showLoader()
        refreshImages(sender)
        dismissLoader()
    }
    
    /**
    Pull to Refresh action method
    */
    @objc private func refreshImages(_ sender: Any) {
        // Fetch image Details
        fetchUserDetailsFromJson()
        cacheManager?.clearCache()
        self.collectionView.reloadData()
    }
    
    private func fetchUserDetailsFromJson(){
        
        let imageFetchServie : ImageFetchService = ImageFetchService()
        group.enter()
        imageFetchServie.fetchUserDetails(url: JSONURL, downloader: downloader) { (userDetailsArray : Array<UserDetailsModel>?) in
            self.userDetailsArray = userDetailsArray
            DispatchQueue.main.async {
                if(self.refreshControl.isRefreshing)
                {
                    self.refreshControl.endRefreshing()
                }
            }
            self.group.leave()
        }
    }
    
    private func showLoader(){
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true, completion: nil)
    }
    
    private func dismissLoader(){
        loadingAlert.dismiss(animated: false, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        group.wait()
        guard let userDetailsArray = userDetailsArray else {return 1}
        return userDetailsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        // Configure the cell
        guard let userDetailsArray = userDetailsArray else {return cell}
        let userDetails : UserDetailsModel = userDetailsArray[indexPath.row];

        if let imageData = cacheManager?.getFileForKey(key: userDetails.imageURL as NSString)
        {
            cell.pinImageView.image = UIImage(data: imageData as Data)
            cell.imageName.text = userDetails.userName
        }
        else
        {
            self.downloader.downloadFromURL(url: userDetails.imageURL, saveInto: self.cacheManager, success: { (image: UIImage?) in
                if let image = image
                {
                    DispatchQueue.main.async {
                        self.showImage(image: image, withAnimation: cell.pinImageView)
                        cell.imageName.text = userDetails.userName
                    }
                }
                })
            { (isCancelled: Bool) in
                
            }
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let userDetailsArray = userDetailsArray else {return }
        let userDetails : UserDetailsModel = userDetailsArray[indexPath.row];
        self.downloader.cancelDownloadForURL(url: userDetails.imageURL)
    }
    
    func showImage(image : UIImage, withAnimation imageView : UIImageView) {
        
        CATransaction.begin()
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0 * Double.pi / 180
        animation.toValue = 180 * Double.pi  / 180
        animation.duration = 0.5;
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        
        imageView.image = UIImage(named: "")
        
        CATransaction.setCompletionBlock {
            imageView.image = image
        }
        imageView.layer.animation(forKey: "rotationAnimation")
        
        CATransaction.commit()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: IMAGE_WIDTH, height: IMAGE_HEIGHT)
    }
}
