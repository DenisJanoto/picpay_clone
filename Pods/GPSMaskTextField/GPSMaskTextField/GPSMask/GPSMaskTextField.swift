//
//  GPSMaskTextField.swift
//  GPSMaskTextFieldProject
//
//  Created by Gilson Santos on 19/02/19.
//  Copyright © 2019 Gilson Santos. All rights reserved.
//


import UIKit
import Foundation


// MARK: - PROTOCOL -
public protocol GPSMaskTextFieldDelegate: NSObjectProtocol {
    func updateMask(textField: UITextField, textUpdate: String) -> String?
}

protocol GPSValidationFieldManagerDelegate: NSObjectProtocol {
    func updateRequired(_ textField: GPSMaskTextField, isEmptyField: Bool)
    func updateValidationField(_ textField: GPSMaskTextField, errorValidation: ErrorValidateMask, notificationUser: Bool)
    func verifyHideKeyboard(_ textField: GPSMaskTextField)
    func addFieldInValidation(_ textField: GPSMaskTextField)
    func forceValidationInTextField(textField: GPSMaskTextField)
}

@IBDesignable public class GPSMaskTextField: UITextField {
    private var maskFormatter = ""
    private var minSize = -1
    private var maxSize = -1
    private var nameField = ""
    private var decimalSeparatorCurrency = ""
    private var mainSeparatorCurrency = ""
    private var type = UIKeyboardType.default
    private var validation = Validation()
    private var firstStart = false
    
    weak var validationDelegate: GPSValidationFieldManagerDelegate?
    public weak var gpsDelegate: GPSMaskTextFieldDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupDelegate()
        self.getTypeTextField()
        
    }
    
    deinit {
        self.validationDelegate = nil
        self.updateTextWithMask = nil
    }
    
    @IBInspectable open var customMask: String {
        set{
            self.maskFormatter = newValue
            self.minSize = self.maskFormatter.count
            self.maxSize = self.maskFormatter.count
        }get{
            return self.maskFormatter
        }
    }
    
    @IBInspectable open var minimumSize: Int {
        set{
            if !self.maskFormatter.isEmpty {
                self.minSize = self.maskFormatter.count
            }else {
                self.minSize = newValue
            }
        }get{
            return self.minSize
        }
    }
    
    @IBInspectable open var maximumSize: Int {
        set{
            if !self.maskFormatter.isEmpty {
                self.maxSize = self.maskFormatter.count
            }else {
                self.maxSize = newValue
            }
        }get{
            return self.maxSize
        }
    }
    
    @IBInspectable open var nameTextField: String {
        set{
            self.nameField = newValue
        }get{
            return self.nameField
        }
    }
    
    @IBInspectable open var isCurrency: Bool = false
    
    @IBInspectable open var mainSeparator: String {
        set{
            self.mainSeparatorCurrency = newValue
        }get{
            return self.mainSeparatorCurrency
        }
    }
    
    @IBInspectable open var decimalSeparator: String {
        set{
            self.decimalSeparatorCurrency = newValue
        }get{
            return self.decimalSeparatorCurrency
        }
    }
    
    @IBInspectable open var isRequired: Bool = false {
        didSet {
            if self.self.firstStart {
                self.validationDelegate?.addFieldInValidation(self)
            }
            self.firstStart = true
        }
    }
    
    public var updateTextWithMask: String? {
        set {
            guard let value = newValue else { return }
            self.setTextWithMask(text: value)
        }
        get {
            return nil
        }
    }
    
    var textoFinal = ""
}

extension GPSMaskTextField {
    private func setupDelegate(){
        guard let _ = self.delegate else {
            self.delegate = self
            return
        }
    }
    
    private func getTypeTextField(){
        self.type = self.keyboardType
    }
}

// MARK: - UITEXTFIELDDELEGATE -
extension GPSMaskTextField: UITextFieldDelegate{
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldUpdate: NSString = textField.text as NSString? else {return false}
        var textUpdate = ""
        if range.location <= self.maskFormatter.count - 1, !string.isEmpty, !self.isCurrency {
            let indexText = self.maskFormatter.index(self.maskFormatter.startIndex, offsetBy: range.location)
            let element = !self.maskFormatter.suffix(from: indexText).contains("#") ? "" : string
            textUpdate = textFieldUpdate.replacingCharacters(in: range, with: element)
        }else {
            textUpdate = textFieldUpdate.replacingCharacters(in: range, with: string)
        }
        
        if self.isCurrency, !self.mainSeparator.isEmpty, !self.decimalSeparator.isEmpty {
            let symbolMain = self.mainSeparator.first ?? "."
            let symbolDecimal = self.decimalSeparator.first ?? "'"
            textUpdate = self.validation.formatValueText(text: textUpdate, symbolMain: symbolMain, symbolDecimal: symbolDecimal)
        }else {
            textUpdate = self.insertMask(textField, index: range.location, isRemove: string.isEmpty, textUpdate: textUpdate)
        }
        
        if self.validation.isValidMax(maxValue: self.maxSize, text: textUpdate) {
            textField.text = textUpdate
            
            self.setValidMinTextField(textUpdate, notificationUser: false)
            self.validationDelegate?.updateRequired(self, isEmptyField: textUpdate.isEmpty)
            
            if (textUpdate.count == self.maskFormatter.count || textUpdate.count == self.maxSize), !textUpdate.isEmpty {
                self.becomeFirstResponder()
            }
        }
        
        if let newMask = self.gpsDelegate?.updateMask(textField: textField, textUpdate: textUpdate), newMask != self.customMask {
            self.updateMask(newMask: newMask, string: string)
        }
        
        if self.maxSize != -1, textUpdate.count == self.maxSize {
            self.validationDelegate?.verifyHideKeyboard(self)
        }
        return false
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.setValidMinTextField(textField.text ?? "", notificationUser: true)
        return true
    }
}

// MARK: - PUBLICS FUNCTIONS -
extension GPSMaskTextField {
    //RETURN TEXT WITHOUT THE MASK
    public func getTextWithoutMask() -> String {
        if self.maskFormatter.isEmpty { return self.text ?? "" }
        return self.removeMaskText()
    }
    
    //INSERT TEXT WITH CONFIGURED MASK
    private func setTextWithMask(text: String) {
        guard self.maxSize != -1 || !self.maskFormatter.isEmpty else { self.text = text; return }
        let maskCount = self.maskFormatter.filter({$0 == "#"}).count
        var newText = ""
        if text.count <= maskCount {
            for element in text {
                newText += String(element)
                let index = newText.count - 1
                newText = self.insertMask(self, index: index, isRemove: false, textUpdate: newText)
            }
        } else if text.count > maskCount, maskCount > 0 {
            let index = text.index(text.startIndex, offsetBy: maskCount)
            newText = String(text.prefix(upTo: index))
        } else if text.count > self.maxSize, self.maxSize > 0 {
            let index = text.index(text.startIndex, offsetBy: self.maxSize)
            newText = String(text.prefix(upTo: index))
        } else {
            newText = text
        }
        self.text = newText
    }
}

// MARK: - AUXILIARY FUNCTIONS -
extension GPSMaskTextField {
    private func setValidMinTextField(_ text: String, notificationUser: Bool) {
        var typeError = ErrorValidateMask.none
        if !self.validation.isValidMin(minValue: self.minSize, text: text) {
            typeError = .minimumValueIsNotValid
        }else if text.isEmpty, self.isRequired {
            typeError = .requiredFieldIsEmpty
        }
        self.validationDelegate?.updateValidationField(self, errorValidation: typeError, notificationUser: notificationUser)
    }
    
    private func insertMask(_ textField: UITextField, index: Int, isRemove: Bool, textUpdate: String) -> String {
        var textUpdateNew = textUpdate
        if !self.maskFormatter.isEmpty, textUpdate.count <= self.maskFormatter.count {
            let indexText = self.maskFormatter.index(self.maskFormatter.startIndex, offsetBy: index)
            let nextIndex = self.maskFormatter.index(self.maskFormatter.startIndex, offsetBy: !isRemove ? index + 1 : isRemove && index != 0 ? index - 1 : index)
            if self.maskFormatter[indexText] != "#", !isRemove {
                textUpdateNew.insert(self.maskFormatter[indexText], at: indexText)
                if index + 1 <= self.maskFormatter.count - 1 {
                    textUpdateNew = self.insertMask(textField, index: index + 1, isRemove: isRemove, textUpdate: textUpdateNew)
                }
            }else if !self.maskFormatter.suffix(from: nextIndex).contains("#"), index + 1 <= self.maskFormatter.count - 1 {
                textUpdateNew = self.insertMask(textField, index: index + 1, isRemove: isRemove, textUpdate: textUpdateNew)
            }
            if isRemove, (self.maskFormatter[indexText] != "#" || self.maskFormatter[nextIndex] != "#") {
                textUpdateNew = self.removeMask(textField, index: index, textUpdate: textUpdateNew)
            }
        }
        return textUpdateNew
    }
    
    private func removeMask(_ textField: UITextField, index: Int, textUpdate: String) -> String {
        if index <= 0 { return "" }
        var textUpdateNew = textUpdate
        let indexText = self.maskFormatter.index(self.maskFormatter.startIndex, offsetBy: textUpdateNew.count - 1)
        if self.maskFormatter[indexText] != "#" {
            textUpdateNew.remove(at: indexText)
            textUpdateNew = self.removeMask(textField, index: index - 1, textUpdate: textUpdateNew)
        }
        return textUpdateNew
    }
    
    private func removeMaskText() -> String {
        let textForReturn = self.text ?? ""
        var returnString = ""
        for (index, text) in self.maskFormatter.enumerated() {
            if text == "#" {
                let indexText = textForReturn.index(textForReturn.startIndex, offsetBy: index)
                returnString += String(textForReturn[indexText])
            }
        }
        return returnString
    }
    
    private func updateMask(newMask: String, string: String) {
        let oldText = self.removeAllMask() + string
        self.customMask = newMask
        self.setTextWithMask(text: oldText)
        self.validationDelegate?.forceValidationInTextField(textField: self)
    }
    
    private func removeAllMask() -> String {
        var textWithoutMask = self.text ?? ""
        let characterList = self.maskFormatter.filter({$0 != "#"})
        characterList.forEach { (characterRow) in
            textWithoutMask = textWithoutMask.replacingOccurrences(of: String(characterRow), with: "")
        }
        return textWithoutMask
    }
}
