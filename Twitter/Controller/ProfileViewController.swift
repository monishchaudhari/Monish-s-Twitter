//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var largeUsernameTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userProfilePicImage: UIImageView!
    @IBOutlet weak var followSegmentControl: UISegmentedControl!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var bottomStatusBarLabel: UILabel!
    
    //MARK:- Local variables
    let currentUser = LoggedInUser.shared
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        updateUIlements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Other Functions
    func updateUIlements() {
        largeUsernameTitle.text = currentUser.user?.username
        
        if (currentUser.user?.name?.split(separator: " ").count ?? 0) == 2 {
            userFullNameLabel.text = currentUser.user?.name?.replacingOccurrences(of: " ", with: "\n").capitalized
        } else {
            userFullNameLabel.text = currentUser.user?.name?.capitalized
        }
        
        if let followersCount = currentUser.followers?.data?.count {
            followSegmentControl.setTitle("\(followersCount) Followers", forSegmentAt: 0)
        }
        if let followingsCount = currentUser.followings?.data?.count {
            followSegmentControl.setTitle("\(followingsCount) Followings", forSegmentAt: 1)
        }
        
        updateTableViewWithOtherContent()
    }
    
    func updateTableViewWithOtherContent() {
        let count = followSegmentControl.selectedSegmentIndex == 0 ? (currentUser.followers?.data?.count ?? 0) : (currentUser.followings?.data?.count ?? 0)
        
        bottomStatusBarLabel.text = followSegmentControl.selectedSegmentIndex == 0 ? "Showing \(count) Followers" : "Showing \(count) Followings"
        
        tableView.reloadData()
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func showProfileOf(user:User) {
        DispatchQueue.main.async {
            let ProfileVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            
            self.present(ProfileVC, animated: true) {
                ProfileVC.largeUsernameTitle.text = user.username
                
                if (user.name?.split(separator: " ").count ?? 0) == 2 {
                    ProfileVC.userFullNameLabel.text = user.name?.replacingOccurrences(of: " ", with: "\n").capitalized
                } else {
                    ProfileVC.userFullNameLabel.text = user.name?.capitalized
                }
                
                ProfileVC.followSegmentControl.isHidden = true
                ProfileVC.tableView.isHidden = true
                ProfileVC.bottomStatusBarLabel.text = "Showing User Profile."
            }
        }
    }
    //MARK:- IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        if self.navigationController != nil {
            let alertVC = UIAlertController(title: "Logout?", message: "Are you sure you want to logout? This will erase all local data.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
                //
            }
            
            let LogoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
                self.currentUser.resetUser()
                self.navigationController?.popViewController(animated: true)
            }
            
            alertVC.addAction(cancelAction)
            alertVC.addAction(LogoutAction)
            
            self.present(alertVC, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didChangeSegmentControl(_ sender: UISegmentedControl) {
        updateTableViewWithOtherContent()
    }
    
    //MARK:- Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followSegmentControl.selectedSegmentIndex == 0 ? (currentUser.followers?.data?.count ?? 0) : (currentUser.followings?.data?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell")!
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        cell.textLabel?.textColor = .darkGray
        
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        cell.detailTextLabel?.textColor = .darkGray
        
        if followSegmentControl.selectedSegmentIndex == 0 {
            if let folloWData = currentUser.followers?.data?[indexPath.row] {
                cell.textLabel?.text = folloWData.name?.capitalized
                cell.detailTextLabel?.text = folloWData.username
            }
        } else {
            if let folloWData = currentUser.followings?.data?[indexPath.row] {
                cell.textLabel?.text = folloWData.name?.capitalized
                cell.detailTextLabel?.text = folloWData.username
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if followSegmentControl.selectedSegmentIndex == 0 {
            if let folloWData = currentUser.followers?.data?[indexPath.row] {
                showProfileOf(user: folloWData)
            }
        } else {
            if let folloWData = currentUser.followings?.data?[indexPath.row] {
               showProfileOf(user: folloWData)
            }
        }
        
    }
}
