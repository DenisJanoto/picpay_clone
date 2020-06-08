//
//  Validation.swift
//  GPSMaskTextFieldProject
//
//  Created by Gilson Santos on 19/02/19.
//  Copyright © 2019 Gilson Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ENUM ERROR -
public enum ErrorValidateMask: Error {
    case requiredFieldIsEmpty
    case minimumValueIsNotValid
    case none
}

//enum TypeField: String {
//    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//}

final class Validation {
//    func isValidEmail(testStr:String, typeField: TypeField) -> Bool {
//        let regex = typeField.rawValue
//        let elementTest = NSPredicate(format:"SELF MATCHES %@", regex)
//        return elementTest.evaluate(with: testStr)
//    }
    
    // MARK: - FORMATTER MAXIMUM VALUE -
    func isValidMax(maxValue:Int, text: String) -> Bool {
        if maxValue > -1, text.count > maxValue {
            return false
        }
        return true
    }
    
    // MARK: - FORMATTER MINIMUM VALUE -
    func isValidMin(minValue: Int, text: String) -> Bool {
        if minValue > -1 {
            if text.count < minValue {
                return false
            }
        }
        return true
    }
    
    // MARK: - FORMATTER CURRENCY -
    func formatValueText(text: String, symbolMain: Character, symbolDecimal:Character) -> String{
        var newText = text
        newText = newText.replacingOccurrences(of: String(symbolDecimal), with: "").replacingOccurrences(of: String(symbolMain), with: "").trimmingCharacters(in: .whitespaces)
        
        let point = Int( ((newText.count - 2) - 1) / 3)
        
        if newText.count > 1 && newText.count < 6{
            newText.insert(symbolDecimal, at: newText.index(newText.endIndex, offsetBy: newText.count == 2 ? -1 : -2))
        }else if newText.count > 5 && point > 0{
            newText.insert(symbolDecimal, at: newText.index(newText.endIndex, offsetBy: -2))
            for index in 1...point{
                newText.insert(symbolMain, at: newText.index(newText.endIndex, offsetBy: -((index * 4) + 2)))
            }
        }
        return newText
    }
}
