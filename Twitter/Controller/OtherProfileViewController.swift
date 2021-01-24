//
//  OtherProfileViewController.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit

class OtherProfileViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileBGImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    //MARK:- Local variables
    var user:User?
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIlements()
    }
    
    //MARK:- Other Functions
    func updateUIlements() {
        profileImage.layer.cornerRadius = 50.0
        
        if user != nil {
            usernameLabel.text = "@\(user!.username ?? "")"
            fullNameLabel.text = user!.name
        }
    }
    
    
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Delegates
}
