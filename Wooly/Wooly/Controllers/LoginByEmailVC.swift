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
    @IBOutlet weak var passwordCountLabel: UILabel!
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
        
        emailTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .lightBackground
        emailTextField.setBorder(borderColor: .lineGray, borderWidth: 1)
        emailTextField.makeRounded(cornerRadius: 3)
        emailTextField.addLeftPadding(left: 10)
        
        passwordLabel.font = UIFont.notoSans(size: 16, family: .Regular)
        
        passwordTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .lightBackground
        passwordTextField.setBorder(borderColor: .lineGray, borderWidth: 1)
        passwordTextField.makeRounded(cornerRadius: 3)
        passwordTextField.addLeftPadding(left: 10)
        
        passwordCountLabel.font = UIFont.notoSans(size: 12, family: .Regular)
        passwordCountLabel.textColor = .gray4
        
        dividerView.backgroundColor = .lineGray
        
        loginButton.titleLabel?.font = UIFont.notoSans(size: 16, family: .Bold)
        loginButton.backgroundColor = .mainColor
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.makeRounded(cornerRadius: 22)
        
        findPasswordButton.titleLabel?.font = UIFont.notoSans(size: 12, family: .Regular)
        findPasswordButton.setTitleColor(.gray1, for: .normal)
        
        signUpLabel.font = UIFont.notoSans(size: 10, family: .Regular)
        signUpLabel.textColor = .gray3
        
        signUpButton.titleLabel?.font = UIFont.notoSans(size: 16, family: .Bold)
        signUpButton.setTitleColor(.mainColor, for: .normal)
        signUpButton.setBorder(borderColor: .mainColor, borderWidth: 1)
        signUpButton.makeRounded(cornerRadius: 22)
    }
    
}
