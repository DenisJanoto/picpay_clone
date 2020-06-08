# GPSMaskTextField

GPSMaskTextField is a framework for UITextField that helps the development of forms without the developer worrying about the basics of validations that a field needs.

This framework has a validation system using reflection and in a simple and practical way, it is possible to validate all text fields in a ViewController using very little code.

## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 10.2+
- Swift 5+


## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate GPSMaskTextField into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'GPSMaskTextField', '~> 2.0.0'
```

## Usage

- First, you must create a UITextField in Interface Builder.

![criando um UITextField](https://uploaddeimagens.com.br/images/002/056/264/original/criacaoTextField.png)

- Second, just assign the custom class GPSMaskTextField to your UITextField

![atribuindo a classe customizada](https://uploaddeimagens.com.br/images/002/056/282/original/AtribuindoClasseCustomizada.png)

- Third, import the GPSMaskTextField and create the IBOutlet:

```swift
import GPSMaskTextField
```
![criando o Outlet](https://uploaddeimagens.com.br/images/002/056/625/original/CriandoOutlet.png)

```swift
@IBOutlet weak var textField: GPSMaskTextField!
```

This alone is enough for you to use all the basic validation features available in Interface Builder. With the GPSMaskTextField you do not even have to assign the delegate to your ViewController, this is already done automatically. 

But if you prefer to implement the UITextField delegate itself, you can do so in the conventional way that automatically becomes a priority in your ViewController.

- In the Interface Builder we have the following configurations:

![Configurações](https://uploaddeimagens.com.br/images/002/362/339/full/Captura_de_Tela_2019-09-20_%C3%A0s_15.05.24.png)

- `Custom Mask`: Mask to be used as examples:
```swift
1 - (##) #### - ####
2 - #### %
3 - ####### @gmail.com
```
The mask can be a string of characters, spaces, and so on. The # is where the text will be entered by the user.

The best thing about using Custom Mask is that for the convenience of the developer to redeem the value assigned to the UITextField, the GPSMaskTextField has a function, according to the example below, that returns the value entered by the user without the mask, no longer having to do replace for obtaining of this value:

```swift
let valueString = textField.getTextWithoutMask()
```

To cater for the reverse scenario, as in cases where the developer needs to assign a value returned from an persistence API or layer, this structure already provides a very simple way to add in this text the mask configured in the builder interface using the "updateTextWithMask" attribute, assigning the text to be inserted.

```swift
self.textField.updateTextWithMask = yourText
```

After assigning values to one or all text fields using the "updateTextWithMask" attribute you can invoke the "forceValidation()" function responsible for verifying that all fields meet the rules set in the isRequired fields and triggers the delegate informing them if they are all valid or not.

"See more details of the validationFields object right in the topic below."

```swift
self.textField.updateTextWithMask = yourText
...
self.validationFields.forceValidation()
```

- `Minimum Size`: Minimum of characters required for the field.
- `Maximum Size`: Maximum characters required for the field.

If Custom Mask field is filled in these 2 settings will be automatically assigned with the mask size set.

- `Name TextField`: Friendly name, used for the validation option of all the fields (treated below), in which returns to the invalid field this friendly name, in case the developer wants to use it for message presentation, if nothing is filled, it defaults to the declared @IBOutlet name for textField.

```swift
class ViewController: UIViewController, GPSValidationFieldsDelegate {

    @IBOutlet weak var emailTextField: GPSMaskTextField!

    func allFieldsValid() {
        print("=== ALL VALID")
    }
    
    func notValidAllFields(fildesNotValid: [FieldsValidation]) {
        fildesNotValid.forEach({print($0.name)})
    }
}

//Optional("emailTextField")
```

- `Is Currency`: A value that determines if the field is of the monetary type, if yes the fields "Main Separator and Decimal Separator" should be filled in. By default, this value is off (false).

- `Main Separator`: The character used when the field is of the monetary type, in the thousands, in the "Is Currency".

- `Decimal Separator`: The character used when the field is of the monetary type, in the decimal houses, configured in the "Is Currency".

Example of use:

![Configurações](https://uploaddeimagens.com.br/images/002/068/593/original/confCurrency.png)

Output:

```swift
"1.200,00"
"76.454.500,00"
```
- `Is Required`: The configuration that determines whether the fields will be mandatory or not for use in the validation functionality of all fields, as explained below in the "Validating all fields" option.

## Validating all fields

GPSMaskTextField has a validation class that if instantiated, using reflection, takes care of all the validations configured for the field and notifies its controller if all the fields are valid or not as explained in the section "Delegates of field validation".

To use the automatic validation features, simply invoke the instance of the "ValidationFields ()" class, calling its function "validationAllFields ()", informing which class has the GPSMaskTextField objects to validate in the first parameter and in the second who will implement the delegate with the answers "GPSValidationFieldsDelegate", according to example below:

The automatic validation only resets the fields that have "Is Required" enabled "On". Fields that have this option "Off" will have their masks applied normally but are not contemplated by this extra validation.

```swift
import UIKit
import GPSMaskTextField

class ViewController: UIViewController {
    
    @IBOutlet weak var textField1: GPSMaskTextField!
    @IBOutlet weak var textField2: GPSMaskTextField!
    @IBOutlet weak var textField3: GPSMaskTextField!

    private let validationField = ValidationFields()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validationField.validationAllFields(for: self, delegate: self)
    }
}
extension ViewController : GPSValidationFieldsDelegate {
    func allFieldsValid() {
        // All fields are valid
    }
    
    func notValidAllFields(fildesNotValid: [FieldsValidation]) {
        // Reports all fields that have not yet met your validation
    }  
}
```
The function parameter "notValidAllFields (fildesNotValid: [FieldsValidation])" is an array of a struct returning information and the object itself GPSMaskTextField:

```swift
public struct FieldsValidation {
    var validIsRequired = false // If the field is required
    var name = "" // Friendly name configured in Interface Builder or if nothing is filled, it defaults to the declared @IBOutlet name for textField
    var errorValidation: ErrorValidateMask = .none // Enum with type of error in validation
    var textField = GPSMaskTextField() // TextField field object
}
```

At any time, you can easily make a non-required field "isRequired = false" as required by simply changing the attribute value to "isRequired = true".

When you make this change automatically the ValidationFields class adds the field to your list of fields to validate and redoes all validations again to ensure that after this change the validation proceeds correctly.

```swift
    @IBAction func click(_ sender: Any) {
        self.emailTextField.isRequired = true
        self.nameTextField.isRequired = false
    }

```





## Field Validation Delegates

To use the automatic validation feature provided by the "ValidationFields" class, your Controller must implement the "GPSValidationFieldsDelegate" and optionally you can implement the "GPSKeyboardDelegate" to specifically capture the keyboard display and hiding:

```swift
// Required to capture validation events
 public protocol GPSValidationFieldsDelegate: NSObjectProtocol {
    func allFieldsValid()
    func notValidAllFields(fildesNotValid: [FieldsValidation])
}

// Optional for capturing keyboard display or hiding
@objc public protocol GPSKeyboardDelegate: NSObjectProtocol {
    @objc optional func showKeyboard(notification: Notification)
    @objc optional func hideKeyboard(notification: Notification)
    
}
```

## Updating a Mask

To change a mask already defined in the builder interface dynamically just, for the specific field implement the delegate "GPSMaskTextFieldDelegate", with its function "updateMask", as example below:

```swift
public protocol GPSMaskTextFieldDelegate: NSObjectProtocol {
    func updateMask(textField: UITextField, textUpdate: String) -> String?
}
```

Example:

```swift
import UIKit
import GPSMaskTextField

class ViewController: UIViewController {
    
    @IBOutlet weak var textField1: GPSMaskTextField!
    @IBOutlet weak var textField2: GPSMaskTextField!
    @IBOutlet weak var textField3: GPSMaskTextField!
    ...

    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        self.textField1.gpsDelegate = self
    }
}
//MARK: - DELEGATE GPSMASKTEXTFIELDDELEGATE -
extension ViewController: GPSMaskTextFieldDelegate {
    func updateMask(textField: UITextField, textUpdate: String) -> String? {
        guard self.textField1 == textField else { return nil } // Treatment performed if there is more than one delegate implementation
        if textUpdate.count > 21 {
            return "+ ## (##) ##### - ####"
        }
        return "+ ## (##) #### - ####"
    }
}
```
Implementing this delegate, each character typed updateMask function is called.

## Thanks

First of all, thank God, my family for the support and especially the understanding and for my friends who helped me and supported me from the beginning, especially my friends Tomaz Correa, Vitor Maura, Millfford Bradshaw. Thank you all.

## Credits

GPSMaskTextField was developed by Gilson Santos (gilsonsantosti@gmail.com)
