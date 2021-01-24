//
//  Loader.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit

class Loader: UIView {

    @IBOutlet weak var backSquare: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updataUIElements()
    }
    
    func updataUIElements() {
        self.backSquare.layer.cornerRadius = 10.0
        self.activityIndicator.startAnimating()
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }

}
