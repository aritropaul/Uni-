//
//  UIStoryboard+Extensions.swift
//  VIT
//
//  Created by Aritro Paul on 22/07/20.
//

import Foundation
import UIKit

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Identifiable {}

enum Storyboard: String {
    case main = "Main"
}

extension UIViewController {
    static func instantiate<T: UIViewController>(from storyboard: Storyboard) -> T {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: self.identifier) as? T else {
            fatalError("Storyboard ID is not same as \(self.identifier)")
        }
        return viewController
    }
}

extension UIColor {
    static let proBlue = UIColor(red: 10/255, green: 102/255, blue: 255/255, alpha: 1)
    static let proBlueHalf = UIColor(red: 10/255, green: 102/255, blue: 255/255, alpha: 0.5)
}
