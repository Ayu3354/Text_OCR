////
////  RSA_swift.swift
////  Text Recognition Sample
////
////  Created by cdceic on 2021/3/25.
////  Copyright © 2021 Stefan Blos. All rights reserved.
////
//import SwiftyRSA
//import CryptoSwift
//
//
/////rsa加密
//func rsa_encrypt(_ str:String) -> String{
//    var reslutStr = ""
//    do{
//        let rsa_publicKey = try PublicKey(pemEncoded: pubkey)
//        let clear = try ClearMessage(string: str, using: .utf8)
//        reslutStr = try clear.encrypted(with: rsa_publicKey, padding: .PKCS1).base64String
//             
//    }
//    catch{
//        print("RSA加密失败")
//    }
//    return reslutStr;
//}
//
/////rsa解密
//func rsa_decrypt(_ str:String) -> String{
//    var reslutStr = ""
//    let enData = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
//    do{
//        let rsa_privateKey = try PrivateKey(pemEncoded: privkey)
//        let data = try EncryptedMessage(data: enData).decrypted(with: rsa_privateKey, padding: .PKCS1).data
//        reslutStr = String(bytes: data.bytes, encoding: .utf8) ?? ""
//    }
//    catch{
//        print("RSA解密失败")
//    }
//    return reslutStr
//}
//
////AES加密
//func aes_encrypt(_ str:String, aes_key:String) -> String{
//  
//    var encryptedStr = ""
//    do {
//        //  AES encrypt
//        let encrypted = try AES(key: Array(aes_key.utf8), blockMode: ECB(), padding: .pkcs7).encrypt(str.bytes);
//        let data = Data(base64Encoded: Data(encrypted), options: .ignoreUnknownCharacters)
//        //加密结果从data转成string 转换失败  返回""
//        encryptedStr = String(bytes: data!.bytes, encoding: .utf8) ?? ""
//    }
//    catch {
//        print(error.localizedDescription)
//    }
//    return encryptedStr
//}
//
//
/////AES解密
//func aes_decrypt(_ str:String , aes_key:String) -> String{
//    //decode base64
//    let data = Data(base64Encoded: str, options: .ignoreUnknownCharacters)!
//    var decrypted: [UInt8] = []
//    do {
//        // decode AES
//        decrypted = try AES(key: Array(aes_key.utf8), blockMode: ECB(), padding: .pkcs7).decrypt(data.bytes);
//    }
//    catch {
//        print(error.localizedDescription)
//    }
//    //解密结果从data转成string 转换失败  返回""
//    return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? ""
//}
//
