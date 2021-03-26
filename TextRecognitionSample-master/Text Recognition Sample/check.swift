//
//  check.swift
//  Text Recognition Sample
//
//  Created by cdceic on 2021/3/26.
//  Copyright © 2021 Stefan Blos. All rights reserved.
//

import Foundation
import SwiftUI




func checksend (source: String) -> Bool {
    
    let lowercaseSource = source.lowercased()
    
    func isValidID(str: String) -> Bool {
        let IDRegEx: String = "[a-z]{1}[1-2]{1}[0-9]{8}$"

        let IDPred = NSPredicate(format:"SELF MATCHES %@", IDRegEx)
        return IDPred.evaluate(with: str)
    }
    if isValidID(str: lowercaseSource) == true
    {
        let cityAlphabets: [String: Int] = [
            "a":10,"b":11,"c":12,"d":13,"e":14,"f":15,"g":16,"h":17,"i":34,"j":18,"k":19,
            "m":21,"n":22,"o":35,"p":23,"q":24,"t":27,"u":28,"v":29,"w":32,"x":30,"z":33,
            "l":20,"r":25,"s":26,"y":31,            // 已停用代碼
        ]
        let ints = lowercaseSource.compactMap{ Int(String($0)) }
        
        guard let key = lowercaseSource.first,
            let cityNumber = cityAlphabets[String(key)] else {
            return false
        }
        // 經過公式計算出來的總和
        let firstNumberConvert = (cityNumber / 10) + ((cityNumber % 10) * 9)
        let section1 = (ints[0] * 8) + (ints[1] * 7) + (ints[2] * 6)
        let section2 = (ints[3] * 5) + (ints[4] * 4) + (ints[5] * 3)
        let section3 = (ints[6] * 2) + (ints[7] * 1) + (ints[8] * 1)
        let total = firstNumberConvert + section1 + section2 + section3

        /// 總和如果除以10是正確的那就是真的
        if total % 10 == 0
        {
            return true
            
        }
        else
        {
            return false

        }
    }
    return false
}


struct Validation<Value>: ViewModifier {
    var value: Value
    var validator: (Value) -> Bool

    func body(content: Content) -> some View {
        // Here we use Group to perform type erasure, to give our
        // method a single return type, as applying the 'border'
        // modifier causes a different type to be returned:
        Group {
            if validator(value) {
                content.border(Color.green)
                //content.border(Color.red)
            } else {
                //content
                content.border(Color.red)
            }
        }
    }
}
