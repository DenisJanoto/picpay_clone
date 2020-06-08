//
//  ValidationFields.swift
//  GPSMaskTextFieldProject
//
//  Created by Gilson Santos on 19/02/19.
//  Copyright © 2019 Gilson Santos. All rights reserved.
//

import Foundation
import UIKit

// MARK: - STRUCT -
public struct FieldsValidation {
    var validIsRequired = false
    public var name = ""
    public var errorValidation: ErrorValidateMask = .none
    public var textField = GPSMaskTextField()
}

// MARK: - PROTOCOL USED FOR COMMUNICATION WITH CONTROLLER -
public protocol GPSValidationFieldsDelegate: NSObjectProtocol {
    func allFieldsValid()
    func notValidAllFields(fildesNotValid: [FieldsValidation])
}

// MARK: - PROTOCOL USED FOR COMMUNICATION WITH CONTROLLER -
@objc public protocol GPSKeyboardDelegate: NSObjectProtocol {
    @objc optional func showKeyboard(notification: Notification)
    @objc optional func hideKeyboard(notification: Notification)
}

// MARK: - START OF THE VALIDATION CLASS -
public class ValidationFields: NSObject {
    
    // - DECLARATION OF VARIABLES -
    private weak var validateDelegate: GPSValidationFieldsDelegate?
    private weak var keyboardDelegate: GPSKeyboardDelegate?
    private lazy var textFieldListForValidation: [FieldsValidation] = [FieldsValidation]()
    private lazy var textFieldListNotValid: [FieldsValidation] = [FieldsValidation]()
    private lazy var textFieldListNotInclude: [FieldsValidation] = [FieldsValidation]()
    private var finish = false
    public override init(){}
    
    deinit {
        self.removeObserver()
    }
}

// MARK: - INITIAL SETTING -
extension ValidationFields {
    public func validationAllFields(for view: AnyObject, delegate: GPSValidationFieldsDelegate) {
        self.textFieldListForValidation.removeAll()
        self.textFieldListNotValid.removeAll()
        self.validateDelegate = delegate
        self.keyboardDelegate = view as? GPSKeyboardDelegate
        self.registerObserver()
        let object = Mirror(reflecting: view)
        for case let (label, value) in object.children {
            if value is UITextField, value is GPSMaskTextField {
                if (value as! GPSMaskTextField).isRequired {
                    let errorValidate: ErrorValidateMask = (value as! GPSMaskTextField).minimumSize != -1 ? .minimumValueIsNotValid : .none
                    (value as! GPSMaskTextField).validationDelegate = self
                    let name = (value as! GPSMaskTextField).nameTextField.isEmpty ? label : (value as! GPSMaskTextField).nameTextField
                    let validate = FieldsValidation(validIsRequired: false, name: name ?? "", errorValidation: errorValidate, textField: value as! GPSMaskTextField)
                    self.textFieldListForValidation.append(validate)
                } else {
                    (value as! GPSMaskTextField).validationDelegate = self
                    let validate = FieldsValidation(validIsRequired: true, name: (value as! GPSMaskTextField).nameTextField, errorValidation: .none, textField: value as! GPSMaskTextField)
                    self.textFieldListNotInclude.append(validate)
                }
            }
        }
    }
    
    private func addOrRemoveFieldForValidation(textField: GPSMaskTextField) {
        if textField.isRequired {
            guard self.textFieldListForValidation.filter({$0.textField == textField}).count == 0 else { return }
            let errorValidate:ErrorValidateMask = textField.minimumSize != -1 ? .minimumValueIsNotValid : .none
            textField.validationDelegate = self
            let validate = FieldsValidation(validIsRequired: false, name: textField.nameTextField, errorValidation: errorValidate, textField: textField)
            self.textFieldListForValidation.append(validate)
            self.validationFieldRow(textField: textField)
            self.textFieldListNotInclude.removeAll(where: {$0.textField == textField})
        } else {
            if let result = self.textFieldListForValidation.filter({$0.textField == textField}).first {
                self.textFieldListForValidation.removeAll(where: {$0.textField == result.textField})
                self.textFieldListNotInclude.append(result)
                let lastTextField = self.textFieldListForValidation.last?.textField ?? GPSMaskTextField()
                self.validationFieldRow(textField: lastTextField)
            }
        }
    }
    
    public func forceValidation() {
        self.textFieldListForValidation.forEach { (fieldRow) in
            self.validationFieldRow(textField: fieldRow.textField)
        }
    }
    
    private func validationFieldRow(textField: GPSMaskTextField) {
        let text = textField.text ?? ""
        let length = !text.isEmpty ? text.count - 1 : 0
        let range = NSRange(location: length, length: 0)
        var lastLatter = ""
        if !text.isEmpty {
            lastLatter = String(textField.text?.removeLast() ?? Character(""))
        }
        _ = textField.textField(textField, shouldChangeCharactersIn: range, replacementString: lastLatter)
    }
}

// MARK: - IMPLEMENTATION OF VALIDATIONFIELDDELEGATE (GPSTEXTFIELD CLASS COMMUNICATION DELEGATE) -
extension ValidationFields: GPSValidationFieldManagerDelegate {
    
    func forceValidationInTextField(textField: GPSMaskTextField) {
        self.validationFieldRow(textField: textField)
    }
    
    func addFieldInValidation(_ textField: GPSMaskTextField) {
        self.addOrRemoveFieldForValidation(textField: textField)
    }
    
    // UPDATES REQUIRED FIELD STATUS
    func updateRequired(_ textField: GPSMaskTextField, isEmptyField: Bool) {
        guard let index = self.getIndexForValidField(textField) else { return }
        self.textFieldListForValidation[index].validIsRequired = !isEmptyField
        self.verifyAllValidation(currentElement: self.textFieldListForValidation[index], isEmptyField: isEmptyField)
    }
    
    // UPDATES THE STATUS OF THE ELEMENT IN THE LIST OF FIELDS FOR VALIDATION AND IF IT IS ERROR ACTION THE DELEGATE FOR COMMUNICATION WITH CONTROLLER
    func updateValidationField(_ textField: GPSMaskTextField, errorValidation: ErrorValidateMask, notificationUser: Bool) {
        guard let index = self.getIndexForValidField(textField) else { return }
        self.textFieldListForValidation[index].errorValidation = errorValidation
        if errorValidation != .none, notificationUser {
            self.verifyAllValidation(currentElement: self.textFieldListForValidation[index], isEmptyField: false)
        }
    }
    
    // CHECK IF IT CAN HIDE THE KEYBOARD
    func verifyHideKeyboard(_ textField: GPSMaskTextField) {
        guard let index = self.getIndexForValidField(textField) else { return }
        if self.finish {
            self.textFieldListForValidation[index].textField.endEditing(true)
        }
    }
}

// MARK: - ACTIONS -
extension ValidationFields {
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func showKeyboard(notification: Notification) {
        self.keyboardDelegate?.showKeyboard?(notification: notification)
    }
    
    @objc private func hideKeyboard(notification: Notification) {
        self.keyboardDelegate?.hideKeyboard?(notification: notification)
    }
}

// MARK: - AUXILIARY FUNCTIONS -
extension ValidationFields {
    
    // ALWAYS VERIFY THE STATUS OF ALL THE FIELDS AND IF THEY ARE ALL WITH THE REQUIREMENTS ACQUAINTED THE DELEGATE OF COMMUNICATION WITH THE CONTROLLER
    private func verifyAllValidation(currentElement: FieldsValidation, isEmptyField: Bool) {
        var requiredsValids = false
        if currentElement.validIsRequired == isEmptyField {
            requiredsValids = self.verifyRequiredValidation()
        }else {
            requiredsValids = self.notValidRequiredList().count == 0
        }
        let minimumResult = self.verifyMinimumValidation()
        if minimumResult, requiredsValids, !self.finish {
            self.finish = true
            self.validateDelegate?.allFieldsValid()
        }else if !self.finish{
            self.validateDelegate?.notValidAllFields(fildesNotValid: self.textFieldListNotValid)
        }
    }
    
    private func getIndexForValidField(_ textField: GPSMaskTextField) -> Int? {
        return self.textFieldListForValidation.firstIndex(where: {$0.textField == textField})
    }
    
    // CHECK IF IN THE LIST OF FIELDS, ALL REQUIREDS ARE COMPLETED
    private func verifyRequiredValidation() -> Bool {
        self.textFieldListNotValid.removeAll()
        let notRequiredList = self.notValidRequiredList()
        if notRequiredList.count == 0 {
            return true
        }
        self.textFieldListNotValid += notRequiredList
        self.finish = false
        return false
    }
    
    // VERIFY IF IN THE LIST OF FIELDS, ALL THAT HAVE MINIMUM VALUE ARE CORRECT
    private func verifyMinimumValidation() -> Bool {
        self.textFieldListNotValid.removeAll()
        let notMinimumValidList = self.notValidAllMinValueList()
        if notMinimumValidList.count == 0{
            return true
        }
        self.textFieldListNotValid += notMinimumValidList
        self.finish = false
        return false
    }
    
    // RETURNS THE LIST OF FIELDS WITH REQUIRED NOT VALID
    private func notValidRequiredList() -> [FieldsValidation] {
        return self.textFieldListForValidation.filter({!$0.validIsRequired})
    }
    
    // RETURNS THE LIST OF FIELDS OF MINIMUM VALUE NOT VALID
    private func notValidAllMinValueList() -> [FieldsValidation] {
        return self.textFieldListForValidation.filter({$0.errorValidation != .none})
    }
}
