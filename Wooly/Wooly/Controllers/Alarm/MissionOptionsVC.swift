//
//  MissionOptionsVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/10/03.
//

import UIKit

class MissionOptionsVC: UIViewController {
    var mission: MissionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectMission()
        
    }
    func selectMission(){
        if mission != nil {
            
        }
    }

}
