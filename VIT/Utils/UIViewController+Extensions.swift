//
//  UIViewController+Extensions.swift
//  VIT
//
//  Created by Aritro Paul on 26/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoadingAlert(title: String) -> UIAlertController{
        let alert = UIAlertController(title: "\n\n\n\(title)", message: "", preferredStyle: .alert)
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = .label
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(activity)
        let views = ["pending" : alert.view, "indicator" : activity]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[indicator]-(60)-|", options: [], metrics: nil, views: views as [String : Any])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: [], metrics: nil, views: views as [String : Any])
        alert.view.addConstraints(constraints)
        activity.startAnimating()
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
    func showToast(with message: String) {
        let toast = Toast.instantiate(autolayout: false)
        toast.messageLabel.text = message
        
        let keyWindow: UIView = (UIApplication.shared.keyWindow ?? UIWindow())
        toast.frame = CGRect(x: keyWindow.frame.midX/2 , y: -50, width: 200, height: 50)
        keyWindow.addSubview(toast)
        keyWindow.bringSubviewToFront(toast)
        
        UIView.animate(withDuration: 0.2) {
            toast.frame.origin.y = 50
        } completion: { (status) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.2) {
                    toast.frame.origin.y = -50
                } completion: { (status) in
                    toast.removeFromSuperview()
                }
            }
        }

    }
}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


extension String {
    func abbr() -> String {
        let components = self.components(separatedBy: " ")
        var abbr = ""
        let notWords = ["and", "of", "for", "(", "to"]
        for word in components {
            if !notWords.contains(word)  {
                abbr += String(word.first!)
            }
        }
        return abbr
    }
}


extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIView {

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        // generic helper function
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
}
