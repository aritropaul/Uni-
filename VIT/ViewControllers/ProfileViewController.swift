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
                DispatchQueue.main.async {
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                }
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
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = NSString(string: "\(indexPath.row)")
        let config = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { (actions) -> UIMenu? in
            if indexPath.section == 0 && indexPath.row == 1 {
                let action = UIAction(title: "Copy Registration Number",image: UIImage(systemName: "person.crop.square.fill"), discoverabilityTitle: self.profile.regNo) { (action) in
                    UIPasteboard.general.string = self.profile.regNo
                }
                let menu = UIMenu(title: self.profile.studentName!.capitalized, children: [action])
                return menu
            }
            
            if indexPath.section == 2 && indexPath.row == 0 {
                let action = UIAction(title: "Copy Email", image: UIImage(systemName: "envelope.fill"), discoverabilityTitle: self.profile.email) { (action) in
                    UIPasteboard.general.string = self.profile.email
                }
                let menu = UIMenu(title: self.profile.studentName!.capitalized, children: [action])
                return menu
            }
            
            if indexPath.section == 2 && indexPath.row == 1 {
                let action = UIAction(title: "Copy Phone Number", image: UIImage(systemName: "phone.fill"), discoverabilityTitle: self.profile.mobileNo) { (action) in
                    UIPasteboard.general.string = self.profile.mobileNo
                }
                let menu = UIMenu(title: self.profile.studentName!.capitalized, children: [action])
                return menu
            }
            
            return nil
        }
        return config
    }
    
    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let index = Int(configuration.identifier as! String) ?? -1
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        let params = UIPreviewParameters()
        params.visiblePath = UIBezierPath(roundedRect: cell?.bounds ?? CGRect(), cornerRadius: 12)
        params.backgroundColor = .clear
        return UITargetedPreview(view: cell ?? DATableViewCell(), parameters: params)
    }
}
