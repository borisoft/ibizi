//
//  BlockEncryption.swift
//  IBIZI
//
//  Created by alex borisoft on 15.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation

class ECB {
    var pass: String
    let countBytes: Int  = 3
    var offset: UInt32 = 3
    let inputFile:String
    let outputFile:String

    init(pass: String , inputFile: String, outputFile: String) {
        self.pass =  pass
        
        self.inputFile = inputFile
        self.outputFile = outputFile
    }
    
    func encryption (text: String) -> String {
        offset = UInt32(setOffset(pass: pass))
        var temp : [UInt8] = initTempArray()
        var index = 0
        var resText = ""
        for char in text.unicodeScalars {
            temp[index] = UInt8.init(exactly: char.value)!
            if index == 2 {
                let res = BitOperations.leftShift(arg0: temp[0], arg1: temp[1], arg2: temp[2], offset: self.offset)
                resText += intToChar(val: res)
                temp = initTempArray()
                index = -1;
            }
            index += 1
        }
        if index != 1 {
            let res = BitOperations.leftShift(arg0: temp[0], arg1: temp[1], arg2: temp[2], offset: self.offset)
            resText += intToChar(val: res)
        }
        return resText
    }
    
    
    func decryption (text: String) -> String {
        offset = UInt32(setOffset(pass: pass))
        var temp : [UInt8] = initTempArray()
        var index = 0
        var resText = ""
        for char in text.unicodeScalars {
            temp[index] = UInt8.init(exactly: char.value)!
            if index == 2 {
                let res = BitOperations.rightShift(arg0: temp[0], arg1: temp[1], arg2: temp[2], offset: self.offset)
                resText += intToChar(val: res)
                temp = initTempArray()
                index = -1;
            }
            index += 1
        }
        if index != 1 {
            let res = BitOperations.rightShift(arg0: temp[0], arg1: temp[1], arg2: temp[2], offset: self.offset)
            resText += intToChar(val: res)
        }
        return resText
    }

    
    func setOffset(pass: String)->Int {
        var hash = 0
        for char in pass.unicodeScalars {
            hash = Int(char.value) ^ hash
        }
        return Int(Double(hash).truncatingRemainder(dividingBy: 8))
    }
    
    func writeResultEncryption(text: String) {
        
        let wr = IOFileWorker(file: self.outputFile)
        wr.write(text: text)
    }
    
    func initTempArray()->[UInt8]{
        return [0,0,0];
    }
    
    
    func intToChar(val : (arg0: UInt8, arg1: UInt8, arg2: UInt8) ) -> String {
        var str = ""
            str += String(Character.init(UnicodeScalar.init(val.arg0)))
            str += String(Character.init(UnicodeScalar.init(val.arg1)))
            str += String(Character.init(UnicodeScalar.init(val.arg2)))
        return str
    }
}

class OFBEncryption  {
    let pass:String
    let x0: Int = 0
    init(pass: String) {
        self.pass = pass
    }
    
    func createBaseVector()-> [UInt8] {
        let qg = QuadraticGenerator(x0: getX0())
        return [UInt8(qg.nextNumber()),UInt8(qg.nextNumber()),UInt8(qg.nextNumber())]
    }
    
    
    func getX0()-> Int{
        var hash = 0
        for char in pass.unicodeScalars {
            hash = Int(char.value) ^ hash
        }
        return hash<<2

    }
    
    func startEncryption(text: String)->String{
        var vector:[UInt8] = createBaseVector()
        var temp : [UInt8] = initTempArray()
        var index = 0
        var resText = ""
        for char in text.unicodeScalars {
            temp[index] = UInt8.init(exactly: char.value)!
            if index == 2 {
                let res = BitOperations.leftShift(arg0: vector[0], arg1: vector[1], arg2: vector[2], offset: UInt32(getOffset(pass: self.pass)))
                vector = [res.arg0, res.arg1, res.arg2]
                resText += XORString(str1:temp, str2: vector)
                temp = initTempArray()
                index = -1;
            }
            index += 1
        }
        if index != 1 {
            let res = BitOperations.leftShift(arg0: vector[0], arg1: vector[1], arg2: vector[2], offset: UInt32(getOffset(pass: self.pass)))
            vector = [res.arg0, res.arg1, res.arg2]
            resText += XORString(str1:temp, str2: vector)
        }
    
        return resText
    }
    
    func startDecryption(text: String)->String{
        var vector:[UInt8] = createBaseVector()
        var temp : [UInt8] = initTempArray()
        var index = 0
        var resText = ""
        for char in text.unicodeScalars {
            temp[index] = UInt8.init(exactly: char.value)!
            if index == 2 {
                let res = BitOperations.leftShift(arg0: vector[0], arg1: vector[1], arg2: vector[2], offset: UInt32(getOffset(pass: self.pass)))
                vector = [res.arg0, res.arg1, res.arg2]
                resText += XORString(str1:temp, str2: vector)
                temp = initTempArray()
                index = -1;
            }
            index += 1
        }
        if index != 1 {
            let res = BitOperations.leftShift(arg0: vector[0], arg1: vector[1], arg2: vector[2], offset: UInt32(getOffset(pass: self.pass)))
            vector = [res.arg0, res.arg1, res.arg2]
            resText += XORString(str1:temp, str2: vector)
        }
        
        return resText
    }

    
    
    func getOffset(pass: String)->Int {
        var hash = 0
        for char in pass.unicodeScalars {
            hash = Int(char.value) ^ hash
        }
        return Int(Double(hash).truncatingRemainder(dividingBy: 8))
    }
    
    func XORString(str1: [UInt8] , str2: [UInt8])->String {
        return intToChar(val: (str1[0]^str2[0], str1[1]^str2[1], str1[2]^str2[2]))
    }
    
    func initTempArray()->[UInt8]{
        return [0,0,0];
    }
    
    
    func intToChar(val : (arg0: UInt8, arg1: UInt8, arg2: UInt8) ) -> String {
        var str = ""
        str += String(Character.init(UnicodeScalar.init(val.arg0)))
        str += String(Character.init(UnicodeScalar.init(val.arg1)))
        str += String(Character.init(UnicodeScalar.init(val.arg2)))
        return str
    }

    
}
