//
//  FileCache.swift
//  ImageLoading
//
//  Created by Shanmuganathan on 12/08/19.
//  Copyright © 2019 Shanmuganathan. All rights reserved.
//

import UIKit

class FileCache: NSObject {
        
    private var fileCache : NSCache<NSString, NSData>
        
        init(size:Int) {
                /*Initialize Cache */
                self.fileCache = NSCache()
                self.fileCache.countLimit = size
        }
        
        func setFile(data:NSData, forKey key:NSString) {
            self.fileCache.setObject(data, forKey: key)
        }
        
        func getFileForKey(key:NSString) -> NSData! {
            return self.fileCache.object(forKey: key)
        }
        
        func clearCache() {
            self.fileCache.removeAllObjects()
        }
}
