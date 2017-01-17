//
//  Writer.swift
//  IBIZI
//
//  Created by alex borisoft on 10.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation

class IOFileWorker {
    var file : String = ""
    
    init( file: String) {
        self.file = file
    }
    
    func write(text: String){
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(self.file)
            //writing
            do {
                try text.write(to: path, atomically: true, encoding: String.Encoding.unicode)
            }
            catch {
                print("crash")
            }
        }
    }
    
    func read() -> String {
        var  result = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(self.file)
            //writing
            do {
                result = try String.init(contentsOf: path, encoding: String.Encoding.unicode)
            }
            catch {
                print(error)
               
            }
        }
        return result
    }
    
    
    func writeInDirectory(text: String, directory:String){
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let newDirectory = directory.appending(self.file)
            let path = dir.appendingPathComponent(newDirectory)
            //writing
            do {
                try text.write(to: path, atomically: true, encoding: String.Encoding.unicode)
            }
            catch {
                print("crash")
            }
        }
    }
    
    func readInDirectory(directory:String) -> String {
        var  result = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let newDirectory = directory.appending(self.file)

            let path = dir.appendingPathComponent(newDirectory)
            //writing
            do {
                result = try String.init(contentsOf: path, encoding: String.Encoding.unicode)
            }
            catch {
                print(error)
                
            }
        }
        return result
    }


}
