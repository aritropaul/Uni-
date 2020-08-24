//
//  ProfileViewController.swift
//  VIT
//
//  Created by Aritro Paul on 21/07/20.
//

import UIKit
import SPAlert

class ProfileViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var regLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var profile = Profile()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButton.primaryAction = nil
        settingsButton.menu = makeMenu()
        isLoading = true
        getProfile()
    }
    
    func getProfile() {
        VIT.shared.getProfile { (result) in
            switch result {
            case .success(let profile) :
                self.profile = profile
                DispatchQueue.main.async {
                    self.setupView()
                }
                
            case .failure(let error):
                SPAlert.present(message: error.localizedDescription, haptic: .error)
            }
        }
    }
    
    func makeMenu() -> UIMenu {
        let action = UIAction(title: "Log out", image: UIImage(systemName: "xmark"), attributes: .destructive) { (action) in
            VIT.loggedIn = false
            regNum = ""
            VIT.shared.saveLoginState()
            SPAlert.present(title: "Logged out", preset: .done)
            self.parent?.parent?.performSegue(withIdentifier: "unwindToLogin", sender: Any?.self)
        }
        let crash = UIAction(title: "Crash Test", image: UIImage(systemName: "exclamationmark.triangle.fill"), attributes: .destructive) { (action) in
            fatalError()
        }
        let menu = UIMenu(title: "Profile", children: [action])
        return menu
    }
    
    func setupView() {
        profileImage.image = UIImage(data: Data(base64Encoded: profile.img ?? "")!)
        profileImage.contentMode = .scaleAspectFill
        nameLabel.text = profile.studentName?.capitalized
        regLabel.text = profile.regNo
        genderLabel.text = profile.gender?.capitalized
        schoolLabel.text = profile.school
        programLabel.text = profile.program
        courseLabel.text = profile.description
        mailLabel.text = profile.email
        phoneLabel.text = profile.mobileNo
    }
}
