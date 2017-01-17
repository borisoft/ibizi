//
//  BitOperations.swift
//  IBIZI
//
//  Created by alex borisoft on 15.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation

class BitOperations {
    
    static func leftShift(arg0: UInt8, arg1: UInt8, arg2: UInt8 , offset: UInt32 ) -> (arg0: UInt8, arg1: UInt8, arg2: UInt8 ){
        var num: uint32 = uint32(arg0)
        num = num << 8
        num |= uint32(arg1)
        num = num << 8
        num |= uint32(arg2)
        
        num = num << offset
        let temp = num >> 24
        num = (num << 8) >> 8
        num |= temp
        
        let val1 = uint8(num & 255)
        let val2 = uint8((num >> 8) & 255)
        let val3 = uint8((num >> 16) & 255)
        return (val3, val2, val1)
    }
    
    static func rightShift(arg0: UInt8, arg1: UInt8, arg2: UInt8 , offset: UInt32 ) -> (arg0: UInt8, arg1: UInt8, arg2: UInt8 ){
        var num: uint32 = uint32(arg0)
        num = num << 8
        num |= uint32(arg1)
        num = num << 8
        num |= uint32(arg2)
        var rs = (num << (24  + (8 - offset)))
        let temp = rs  >> (24  + (8 - offset))
        num = num >> offset
        num |= temp << (24 - offset)
        
        
        let val1 = uint8(num & 255)
        let val2 = uint8((num >> 8) & 255)
        let val3 = uint8((num >> 16) & 255)
        return (val3, val2, val1)
    }

}
