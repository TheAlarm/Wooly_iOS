//
//  AddAlarmNC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/10/03.
//

import UIKit

class AddAlarmNC: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
 
    }


}
