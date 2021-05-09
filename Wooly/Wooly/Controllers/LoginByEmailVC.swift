//
//  ViewController.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/02.
//

import UIKit

class LoginByEmailVC: UIViewController {
    //MARK: - Custom Properties
    
    let maxPasswordCount: Int = 9
    
    let textFieldPadding: CGFloat = 12
    
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
    @IBOutlet weak var passwordShowButton: UIButton!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Custom Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func setStyle(){
        titleLabel.font = UIFont.notoSans(size: 20, family: .Bold)
        let titleAttributedString = NSMutableAttributedString(string: titleLabel.text ?? "")
        titleAttributedString.addAttribute(.foregroundColor, value: UIColor.mainColor, range: (titleLabel.text as! NSString).range(of: "로그인"))
        titleLabel.attributedText = titleAttributedString
        emailLabel.font = UIFont.notoSans(size: 16, family: .Regular)
        
        emailTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .lightBackground
        emailTextField.setBorder(borderColor: .lineGray, borderWidth: 1)
        emailTextField.makeRounded(cornerRadius: 3)
        emailTextField.addLeftPadding(left: textFieldPadding)
        
        passwordLabel.font = UIFont.notoSans(size: 16, family: .Regular)
        
        passwordTextField.font = UIFont.notoSans(size: 16, family: .Regular)
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .lightBackground
        passwordTextField.setBorder(borderColor: .lineGray, borderWidth: 1)
        passwordTextField.makeRounded(cornerRadius: 3)
        passwordTextField.addLeftPadding(left: textFieldPadding)
        
        passwordCountLabel.font = UIFont.notoSans(size: 12, family: .Regular)
        passwordCountLabel.textColor = .gray4
        
        passwordShowButton.setImage(UIImage(named:"btn_login_coverpassword"), for: .normal)
        passwordShowButton.setImage(UIImage(named:"btn_login_showpassword"), for: .selected)
        
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
    
    //MARK: - IBActions
    
    @IBAction func passwordShowButtonDidTap(_ sender: Any) {
        passwordShowButton.isSelected = !passwordShowButton.isSelected
        if passwordShowButton.isSelected == true{
            passwordTextField.isSecureTextEntry = false
        }
        else{
            passwordTextField.isSecureTextEntry = true
            passwordTextField.clearsOnBeginEditing = false
        }
    }
    @IBAction func passwordTextFieldEditChanged(_ sender: UITextField) {
        sender.limitTextCount(maxCount: maxPasswordCount)
        
        passwordCountLabel.text = "(\((sender.text ?? "").count)/\(maxPasswordCount))"
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LoginByEmailVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBorder(borderColor: .mainColor, borderWidth: 1)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBorder(borderColor: .lineGray, borderWidth: 1)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        if textField == passwordTextField{
            // 중간에 추가되는 텍스트 막기
            if text.count >= maxPasswordCount && range.length == 0 && range.location < maxPasswordCount {
                return false
            }
        }
            
        return true
    }
}

