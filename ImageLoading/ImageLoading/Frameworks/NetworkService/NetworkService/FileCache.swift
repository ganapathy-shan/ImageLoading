//
//  FileCache.swift
//  NetworkService
//
//  Created by Shanmuganathan on 15/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit
/**
class which provides caching functionality
*/
open class FileCache: NSObject {
    
    private var fileCache : NSCache<NSString, NSData>
    
    public init(size:Int) {
        /*Initialize Cache */
        self.fileCache = NSCache()
        self.fileCache.countLimit = size
    }
    
    public func setFile(data:Data, forKey key:NSString) {
        self.fileCache.setObject(data as NSData, forKey: key)
    }
    
    public func getFileForKey(key:NSString) -> NSData! {
        return self.fileCache.object(forKey: key)
    }
    
    public func clearCache() {
        self.fileCache.removeAllObjects()
    }
}
