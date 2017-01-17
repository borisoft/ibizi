//
//  Generators.swift
//  IBIZI
//
//  Created by alex borisoft on 10.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation

class QuadraticGenerator {
    var x:Double
    let a:Double
    let c:Double
    let m:Double
    
    init(x0: Int) {
        self.x = Double(x0)
        self.a = pow(7,13)
        self.c = 29071995
        self.m = pow(2, 31) - 1.0
    }
    
    func nextNumber() -> Int {
        self.x = (a * pow(x,2) + c).truncatingRemainder(dividingBy: m)
        return Int(self.x.truncatingRemainder(dividingBy: 255))
    }
}

class FibonachiGenerator  {
    
    var fibonachiArray =  [Int]()
    let fibonachA:Int = 17
    let fibonachiB: Int = 5
    var index:Int
    
    init() {
        index = 0
        initFibonachiArray()
    }
    
    func max(arg1: Int, arg2: Int) -> Int {
        return ((arg1 > arg2) ? arg1 :arg2)
    }
    
    func initFibonachiArray() {
        for _ in 1...max(arg1: fibonachA, arg2: fibonachiB)+1 {
            fibonachiArray.append(abs(Int(arc4random_uniform(255))))
        }
    }
    
    func generateFibonachi() -> Int {
        
        let currentIndex = index > max(arg1: fibonachA, arg2: fibonachiB) ? index % max(arg1: fibonachA, arg2: fibonachiB) :index;
        
        let resIndex = currentIndex + max(arg1: fibonachA, arg2: fibonachiB)
        
        var  res = 0
        if fibonachiArray[resIndex - fibonachA] >  fibonachiArray[resIndex - fibonachiB] {
            res =  abs(fibonachiArray[resIndex - fibonachA] - fibonachiArray[resIndex - fibonachiB])
            
        }else {
            res  =  abs(fibonachiArray[resIndex - fibonachA] - fibonachiArray[resIndex - fibonachiB] + 1)
        }
        fibonachiArray[currentIndex] = res;
        return res
    }

}
