//
//  ImageDownloadOperation.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 13/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import Foundation
import NetworkService
@objc enum OperationState: Int{
    case ready
    case executing
    case finished
    case cancelled
}

/**
class which inherits from Operation class and uses NetworkService API for download Operation
*/
class ImageDownloaderOperation : Operation {
    
    private var urlToDownload:String
    private var cacheManager:FileCache?
    private var downloadService:NetworkService
    private var _state: OperationState = .ready
    
    //Using Queue to avoid race condition while accessing Operation state
    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
    
    //Operation State
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { _state } }
        set { stateQueue.async(flags: .barrier) { self._state = newValue } }
    }
    
    init(url:String!, with cacheManger:FileCache!) {
        urlToDownload = url
        cacheManager = cacheManger
        downloadService = NetworkService(URLSession.shared)
    }
    
    open override var isReady:  Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    
    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    public final func finish() {
        if !isFinished { state = .finished }
    }
    
    override func start() {
        if self.isCancelled {
            state = .cancelled
            return
        }
        state = .executing
        main()
    }
    
    override func main() {
        self.downloadService.downloadFromURL(url: self.urlToDownload, storeIn:self.cacheManager, completionHandler:{ (data: Data, error:Error?) in
            if self.isCancelled
            {return }
            if data.count > 0
            {
                self.cacheManager?.setFile(data: data, forKey:self.urlToDownload as NSString)
                self.finish()
            }
            } as DataTaskCompletionBlock)
    }
    
    override func cancel() {
        self.downloadService.cancelDownload()
    }
}
