//
//  Coder.swift
//  IBIZI
//
//  Created by alex borisoft on 14.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation


class Coder {
    var pass: String
    let inputFile  = "text.txt"
    let outputFile = "outputCoder.txt"
    let decodeFile = "decodeCoder.txt"
    let inputFW: IOFileWorker
    let outputFW: IOFileWorker
    let decodeFW: IOFileWorker
    
    init(pass: String) {
        self.pass = pass
        self.inputFW = IOFileWorker(file: inputFile)
        self.outputFW = IOFileWorker(file: outputFile)
        self.decodeFW = IOFileWorker(file: decodeFile)
    }
    
    func encode() {
        let generator = QuadraticGenerator(x0: getHash(pass: pass))
        let text = self.inputFW.read()
        var resultsText = ""
        for char in text.unicodeScalars {
            let  val = UInt8.init(exactly: char.value)! ^ UInt8( generator.nextNumber())
            resultsText += String(Character.init(UnicodeScalar(val)))
        }
        self.outputFW.write(text: resultsText)
    }
    
    func  decode () {
        let generator = QuadraticGenerator(x0: getHash(pass: pass))
        let text = self.outputFW.read()
        var resultsText = ""
        for char in text.unicodeScalars {
            let  val = UInt8.init(exactly: char.value)! ^ UInt8( generator.nextNumber())
            resultsText += String(Character.init(UnicodeScalar(val)))
        }
        self.decodeFW.write(text: resultsText)

    }
    
    func getHash(pass: String)->Int {
        var hash = 0
        for char in pass.unicodeScalars {
            hash = Int(char.value) ^ hash
        }
        return hash/pass.lengthOfBytes(using: String.Encoding.unicode)
    }
    
}
