//
//  KeyGenerator.swift
//  IBIZI
//
//  Created by alex borisoft on 16.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation

class KeyGenerator {
    
    
    static func modPow(baseNumber: Int64, exponenta: Int64, modulo: Int64, numberM: Int64)->Int64 {
        var res:Int64 = numberM
        var exp:Int64 = exponenta
        var base:Int64 = baseNumber
        while exp != 0  {
            if (exp & 1) == 1 {
                res =  res*base % modulo
            }
            
            exp = exp >> 1
            
            base = (base*base) % modulo
        }
        return res
    }
    
   static func methodLehmana(numberForCheck:Int64) -> Bool {
        let p:Int64 = numberForCheck
        let numberA:Int64 =  Int64(arc4random_uniform(UInt32(INT32_MAX)))
        let exp = (p - 1)/2
        let temp = modPow(baseNumber: numberA, exponenta: exp, modulo: p, numberM: 1)
        
        let res = temp % p
        if  ( Int64(res) != 1) && (Int64(res) != p - 1)  {
            return false
        }
        return true;
        
    }
    
    static func generateSimpleNumber()->Int64  {
        var procent:Double = 0
        var res:Int64 = 0
        while res == 0 {
            var index:Double = 0
            let candidate:Int64 =  Int64(arc4random_uniform(UInt32(INT16_MAX))) + Int64(256)
            while procent < 0.9999 {
                index += 1
                if !methodLehmana(numberForCheck: candidate) {
                    break
                }
                procent = 1 - Double(1/pow(2.0,index))
            }
            if procent > 0.9999 {
                res = candidate
            }
        }
        return res
    }
    
    static func simpleToSimple(num1: Int64, num2: Int64)->Bool {
        var g:Int64
        var x = num1
        var y = num2
        if x < 0 {
            x = -x
        }
        
        if y < 0 {
            y = -y
        }
        
        if (x + y) == 0 {
            return false
        }
        
        g = y
        while x > 0 {
            g = x
            x = y % x
            y = g
        }
        
        if g == 1 {
            return true
        }
        
        return false
    }
    
    static func generateModuloSimpleNumber(simple: Int64) -> Int64 {
        var res:Int64 = 0
        while res == 0 {
            let g = generateSimpleNumber()
            if simpleToSimple(num1: simple, num2: g) {
                res = g
            }
        }
        return res
    }
    
   static func encryption(pass:String, p:Int64, g:Int64,y:Int64)->String{
        var res = ""
        for char in pass.unicodeScalars {
            let  k:Int64 = Int64(Int(arc4random_uniform(255)))
            
            let M:UInt32 = char.value
            let  a = KeyGenerator.modPow(baseNumber: g, exponenta: k, modulo: p, numberM: 1)
            let  b = KeyGenerator.modPow(baseNumber: y, exponenta: k, modulo: p, numberM: Int64(M))
            res += String(a) + " " + String(b) + " "
        }
        return res
    }
    
   static func decryption(passCode:String, p:Int64, g:Int64,y:Int64, x:Int64)->String{
        var res = ""
        var index = 0
        var text = passCode.characters.split{$0 == " "}.map(String.init)
        while index < text.count-1 {
            let a = Int64.init(text[index])
            let b = Int64.init(text[index+1])
            let M:UInt32 = uint32(KeyGenerator.modPow(baseNumber: a!, exponenta: (p - 1 - x), modulo: p, numberM: b!))
            res += String(Character(UnicodeScalar(M)!))
            index += 2
        }
        return res
    }

}
