//
//  DMFileManager.swift
//  Dominant Investors
//
//  Created by Nekit on 21.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMFileManager: NSObject {

    static let sharedInstance = DMFileManager()
    
    open func saveToDocuments(obj : AnyObject, fileName : String) -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as String
        let fullPath = URL.init(fileURLWithPath: docs).appendingPathComponent(fileName)
        
        var writingObject = obj
        if (obj is UIImage) {
            writingObject = UIImageJPEGRepresentation(obj as! UIImage, 0.8) as AnyObject
        }
        
        _ = writingObject.write(toFile: fullPath.relativePath, atomically: true)
        
        return fullPath.absoluteString
    }
    
    open func getImageFromDocuments(filename : String) -> UIImage? {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as String
        let fullPath = URL.init(fileURLWithPath: docs).appendingPathComponent(filename)
        
        let image = UIImage(contentsOfFile: fullPath.path)
        
        return image
    }
    
    open func clearDocumentsDirectory() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
    }
    
}
