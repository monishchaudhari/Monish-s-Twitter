//
//  LoginViewController.swift
//  Twitter
//
//  Created by Monish Chaudhari on 24/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //MARK:- Local variables
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
        loginButton.layer.cornerRadius = 5.0
        
        #if DEBUG
        usernameTextField.text = "ChaudharyMonish"
        #endif
    }
    
    deinit {
        print("LoginViewController Deinit")
    }
    
    //MARK:- Other Functions
    func getFollowersFor(userID:String, completionHandler: @escaping (_ status: Bool) -> Void) {
        
        _ = APIManager.shared.makeAPICall(
            endPoint: userID + APIManager.shared.getFollowers,
            method: .GET,
            requestBody: nil)
        { (data, error, response) in
            if let httpResponse = response as? HTTPURLResponse, let responseData = data {
                switch httpResponse.statusCode {
                case 200:
                    //success
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedValue = try decoder.decode(Follow.self, from: responseData)
                        LoggedInUser.shared.followers = decodedValue
                        DispatchQueue.main.async{
                            completionHandler(true)
                        }
                    }
                    catch {
                        DispatchQueue.main.async{
                            completionHandler(false)
                        }
                    }
                    break
                default:
                    DispatchQueue.main.async{
                        completionHandler(false)
                    }
                    break
                }
            }
        }
    }
    
    func getFollowingsFor(userID:String, completionHandler: @escaping (_ status: Bool) -> Void) {
        _ = APIManager.shared.makeAPICall(
            endPoint: userID + APIManager.shared.getFollowings,
            method: .GET,
            requestBody: nil)
        { (data, error, response) in
            if let httpResponse = response as? HTTPURLResponse, let responseData = data {
                switch httpResponse.statusCode {
                case 200:
                    //success
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedValue = try decoder.decode(Follow.self, from: responseData)
                        LoggedInUser.shared.followings = decodedValue
                        DispatchQueue.main.async{
                            completionHandler(true)
                        }
                    }
                    catch {
                        DispatchQueue.main.async{
                            completionHandler(false)
                        }
                    }
                    break
                default:
                    DispatchQueue.main.async{
                        completionHandler(false)
                    }
                    break
                }
            }
        }
    }
    
    func mapDictionaryWithUser(dict:NSDictionary) -> User {
        let user = User()
        if let userID = dict.value(forKey: "id") as? String {
            user.id = userID
        }
        if let fullName = dict.value(forKey: "name") as? String {
            user.name = fullName
        }
        if let userName = dict.value(forKey: "username") as? String {
            user.username = userName
        }
        return user
    }
    
    //MARK:- IBActions
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            usernameTextField.text = ""
            showOkAlert(title: "", message: "Please Enter Username")
            return
        }
        
        let loaderView:Loader = Bundle.main.loadNibNamed("Loader", owner: self, options: nil)![0] as! Loader
        loaderView.frame = self.view.bounds
        self.view.addSubview(loaderView)
        
        _ = APIManager.shared.makeAPICall(
            endPoint: APIManager.shared.getUserInfo + usernameTextField.text!,
            method: .GET,
            requestBody: nil)
        { [unowned vc = self](data, error, response) in
            //
            if let httpResponse = response as? HTTPURLResponse, let responseData = data {
                
                switch httpResponse.statusCode {
                case 200:
                    //success
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if let resultDataDictionary = jsonResult as? NSDictionary {
                            if let dataDictionary = resultDataDictionary.value(forKey: "data") as? NSDictionary {
                                LoggedInUser.shared.user = vc.mapDictionaryWithUser(dict: dataDictionary)
                                
                                let group = DispatchGroup()
                                
                                if let userID = LoggedInUser.shared.user?.id {
                                    group.enter()
                                    vc.getFollowersFor(userID: userID) { (status) in
                                        group.leave()
                                    }
                                    
                                    group.enter()
                                    vc.getFollowingsFor(userID: userID) { (status) in
                                        group.leave()
                                    }
                                }
                                
                                group.notify(queue: .main) {
                                    DispatchQueue.main.async {
                                        loaderView.removeLoader()
                                        vc.navigationController?.navigationBar.isHidden = true
                                        let ProfileVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "MyProfileViewController") as! MyProfileViewController
                                        vc.navigationController?.pushViewController(ProfileVC, animated: true)
                                    }
                                }
                            }
                        }
                    }
                    catch let error1 as NSError {
                        loaderView.removeLoader()
                        vc.showOkAlert(title: "Invalid JSON", message: error1.localizedDescription)
                    }
                    break
                case 400:
                    loaderView.removeLoader()
                    vc.showOkAlert(title: "Invalid Username", message: "The user you are looking for is not found.")
                    break
                case 429:
                    //API call limit exceeded
                    loaderView.removeLoader()
                    vc.showOkAlert(title: "limit exceeded", message: "You have exceeded the API call limit, Please try7 again after some time.")
                    break
                default:
                    break
                }
            } else {
                loaderView.removeLoader()
                vc.showOkAlert(title: "", message: error?.localizedDescription ?? "An unexpected error occurred while fetching the user information.")
            }
        }
    }
    
    
    //MARK:- Delegates
}
