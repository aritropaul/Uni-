//
//  OTPViewController.swift
//  VIT
//
//  Created by Aritro Paul on 26/07/20.
//

import UIKit
import OTPFieldView
import FirebaseAuth
import SPAlert

class OTPViewController: UIViewController {

    @IBOutlet weak var otpField: OTPFieldView!
    var verificationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupOtpView()
    }
    
    func setupOtpView(){
        self.otpField.fieldsCount = 6
        self.otpField.fieldBorderWidth = 0
        self.otpField.cursorColor = .clear
        self.otpField.defaultBackgroundColor = .tertiarySystemFill
        self.otpField.filledBackgroundColor = .tertiarySystemFill
        self.otpField.displayType = .roundedCorner
        self.otpField.fieldSize = 40
        self.otpField.separatorSpace = 8
        self.otpField.shouldAllowIntermediateEditing = false
        self.otpField.delegate = self
        self.otpField.initializeUI()
    }

}

extension OTPViewController : OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        let alert = self.showLoadingAlert(title: "Verifying OTP")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: otp)
        Auth.auth().signIn(with: credential) { (result, error) in
            alert.dismiss(animated: true) {
                if error != nil {
                    SPAlert.present(message: error!.localizedDescription, haptic: .error)
                }
                else {
                    VIT.loggedIn = true
                    VIT.shared.saveLoginState()
                    self.performSegue(withIdentifier: "main", sender: Any?.self)
                }
            }
        }
        
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return false
    }
    
    
}
