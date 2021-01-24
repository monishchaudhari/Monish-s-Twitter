//
//  MyExtensions.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UIViewController
extension UIViewController {
    func showOkAlert(title:String, message:String, ButtonTitle:String = "OK") {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: ButtonTitle, style: .default) { (action) in
            //No other action needed
        }
        
        alertVC.addAction(okAction)
         DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
