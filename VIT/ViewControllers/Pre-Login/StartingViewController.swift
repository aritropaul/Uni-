//
//  StartingViewController.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import UIKit
import SPAlert
import FirebaseAuth

class StartingViewController: UIViewController {

    @IBOutlet weak var registrationField: UITextField!
    var verificationID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func loginTapped(_ sender: Any) {
        if registrationField.text != "" {
            regNum = registrationField.text!
            sendOTP()
        }
        else {
            SPAlert.present(message: "Enter a registration number", haptic: .error)
        }
    }
    
    func sendOTP() {
        let alert = self.showLoadingAlert(title: "Verifying Number")
        VIT.shared.getMobileNumber { (result) in
            switch result {
            case .success(let number):
                DispatchQueue.main.async {
                    alert.dismiss(animated: true) {
                        PhoneAuthProvider.provider().verifyPhoneNumber("+91"+number, uiDelegate: nil) { (id, error) in
                            if error != nil {
                                SPAlert.present(message: error!.localizedDescription, haptic: .error)
                            }
                            else {
                                self.verificationID = id!
                                self.performSegue(withIdentifier: "otp", sender: Any?.self)
                            }
                            
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    alert.dismiss(animated: true) {
                        SPAlert.present(message: "Failed to Verify number", haptic: .error)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let OTPVC = segue.destination as? OTPViewController {
            OTPVC.verificationID = verificationID
        }
    }
}

extension StartingViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if registrationField.text != "" {
            regNum = registrationField.text!
            sendOTP()
            return true
        }
        else {
            SPAlert.present(message: "Enter a registration number", haptic: .error)
            return false
        }
    }
}
