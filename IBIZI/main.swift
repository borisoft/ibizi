//
//  main.swift
//  IBIZI
//
//  Created by alex borisoft on 10.01.17.
//  Copyright © 2017 robolife. All rights reserved.
//

import Foundation


func coderTest() {
    let  generator = QuadraticGenerator(x0:1)
    
    
    let coder = Coder(pass: "qwerty")
    
    coder.encode()
    coder.decode()

}


func  ecbTest(){
    let ir = IOFileWorker(file: "text.txt")
    let wr = IOFileWorker(file: "outputECB.txt")
    
    let ecb =  ECB.init(pass: "qwerty", inputFile: "decode" , outputFile: "outputECB.txt")
    
    let dec = ECB.init(pass: "qwerty", inputFile: "", outputFile: "decodeECB.txt")
    
    print(ir.read())
    ecb.writeResultEncryption(text: ecb.encryption(text: ir.read()))
    dec.writeResultEncryption(text: ecb.decryption(text: wr.read()))
}

func ofbTest() {
    let  input = IOFileWorker (file: "text.txt")
    let output = IOFileWorker (file: "outputOFB.txt")
    let  dec = IOFileWorker (file:"deOFB.txt")
    
    let ofb = OFBEncryption(pass:"qwerty")
    
    let  res = ofb.startEncryption(text: input.read())
    output.write(text: res)
    let  decode = ofb.startDecryption(text: res)
    
    dec.write(text: decode)
    
}

func getX0(pass: String)-> Int{
    var hash = 0
    for char in pass.unicodeScalars {
        hash = Int(char.value) ^ hash
    }
    return hash<<2
}


func generatorsTest(){
    let ir = IOFileWorker(file: "quadratic.txt")
    let wr = IOFileWorker(file: "fib.txt")
    let quadratic: QuadraticGenerator = QuadraticGenerator(x0: getX0(pass: "qwerty"))
    let fibonachi: FibonachiGenerator = FibonachiGenerator()
    
    var  text = ""
    for _ in 1...10000 {
        text += String(quadratic.nextNumber(), radix:2)
    }
    ir.write(text: text)
    
      text = ""
    for _ in 1...10000 {
        text += String(fibonachi.generateFibonachi(), radix:2)
    }
    wr.write(text: text)
    
}

//generatorsTest()

//coderTest()
//ofbTest()

//ecbTest()

func createSimpleNumber() {
    
    let p:Int64 = KeyGenerator.generateSimpleNumber()
    
    let g = KeyGenerator.generateModuloSimpleNumber(simple: p)
    
    let x = Int64(arc4random_uniform(UInt32(p)) + 1)
    
    let y = KeyGenerator.modPow(baseNumber: g, exponenta: x, modulo: p, numberM: 1)
    

    var  openKeySender = IOFileWorker(file: "open_key.txt")
    var  closeKeyReciept = IOFileWorker(file: "close_key.txt")
    
    var open = String(p) + " " + String(g) + " " + String(y)
    var close = String(x)
    
    openKeySender.writeInDirectory(text: open, directory: "sender/")
    closeKeyReciept.writeInDirectory(text: close, directory: "reciept/")
}



func ecnryptionPass(){
        var  passSender = IOFileWorker(file: "pass.txt")
        var  passReciept = IOFileWorker (file: "pass.cod")
        var  openKeySender = IOFileWorker(file: "open_key.txt")
        var passOpen = (openKeySender.readInDirectory(directory: "sender/")).characters.split{$0 == " "}.map(String.init)
        var p = Int64(passOpen[0])!
        var g = Int64(passOpen[1])!
        var y = Int64(passOpen[2])!
    
        let passCode = KeyGenerator.encryption(pass: passSender.readInDirectory(directory:"sender/"), p: p, g: g, y: y)
        passReciept.writeInDirectory(text: passCode, directory: "reciept/")
}

func  blockOFBSender(){
    let  input = IOFileWorker (file: "sender/message.txt")
    let output = IOFileWorker (file: "reciept/message.cod")
    let  dec = IOFileWorker (file:"sender/pass.txt")
    
    var pass = dec.read()
    let ofb = OFBEncryption(pass:pass)
    
    let  res = ofb.startEncryption(text: input.read())
    output.write(text: res)
}


func decryptionPass()->String{
    let  passReciept = IOFileWorker(file: "reciept/pass.cod")
    let  openKeySender = IOFileWorker(file: "open_key.txt")
    let  closeKeyReciept = IOFileWorker(file: "reciept/close_key.txt")
    var passOpen = (openKeySender.readInDirectory(directory: "sender/")).characters.split{$0 == " "}.map(String.init)
    let p:Int64 = Int64(passOpen[0])!
    let g:Int64 = Int64(passOpen[1])!
    let y:Int64 = Int64(passOpen[2])!
    
    var passClose = (closeKeyReciept.read()).characters.split{$0 == " "}.map(String.init)
    let  x:Int64 = Int64(passClose[0])!
    
    let passDecode = KeyGenerator.decryption(passCode: passReciept.read(), p: p, g: g, y: y, x:x)

    return passDecode

}

func blockOFBReciept(){
    let  input = IOFileWorker (file: "reciept/message.cod")
    let output = IOFileWorker (file: "reciept/message.txt")
    
    let ofb = OFBEncryption(pass:decryptionPass())
    
    
    let  decode = ofb.startDecryption(text: input.read())
    
    output.write(text: decode)
}





createSimpleNumber()
ecnryptionPass()
blockOFBSender()
blockOFBReciept()
