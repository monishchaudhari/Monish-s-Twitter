//
//  OtherLaunchScreenView.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit

class OtherLaunchScreenView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func removeLaunchView() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
