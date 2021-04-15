//
//  ViewController.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/02.
//

import UIKit

class LoginByEmailVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
    }
    
    func setStyle(){
        titleLabel.font = UIFont.notoSans(size: 20, family: .Bold)
        emailLabel.font = UIFont.notoSans(size: 16, family: .Regular)
        passwordLabel.font = UIFont.notoSans(size: 16, family: .Regular)
        emailTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .lightBackground
        emailTextField.setBor
        passwordTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        dividerView.backgroundColor = .lineGray
        loginButton.titleLabel?.font = UIFont.notoSans(size: 16, family: .Bold)
        findPasswordButton.titleLabel?.font = UIFont.notoSans(size: 12, family: .Regular)
        signUpLabel.font = UIFont.notoSans(size: 10, family: .Regular)
        signUpButton.titleLabel?.font = UIFont.notoSans(size: 16, family: .Bold)
    }

}

