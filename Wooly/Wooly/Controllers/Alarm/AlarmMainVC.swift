//
//  AlarmMainVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/05/09.
//

import UIKit

class AlarmMainVC: UIViewController {
    
    //MARK: - Custom Properties
    let screenBounds = UIScreen.main.bounds
    let defaultViewWidth: CGFloat = 375
    let messageViewHeight: CGFloat = 198
    var alarmList = ["10:30","12:58","10:30","12:58","10:30","12:58","10:30","12:58","10:30","12:58"]
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dongdongBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var purpleBackgroundView: UIView!
    @IBOutlet weak var nextAlarmMessageView: UIView!
    @IBOutlet weak var nextAlarmDashedView: UIView!
    @IBOutlet weak var alarmCardCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        alarmCardCollectionView.delegate = self
        alarmCardCollectionView.dataSource = self
        setStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("appear")
        print(alarmCardCollectionView.frame.size)
        alarmCardCollectionView.bringSubviewToFront(alarmCardCollectionView.visibleCells[0].contentView)
//        alarmCardCollectionView.reloadData()
//        setStyle()
        
    }
    func setStyle(){
        purpleBackgroundView.backgroundColor = .mainPur
        purpleBackgroundView.clipsToBounds = true
        purpleBackgroundView.layer.cornerRadius = purpleBackgroundView.frame.height/231*50
        purpleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        nextAlarmMessageView.layer.cornerRadius = 30
        nextAlarmMessageView.backgroundColor = .lightPeriwinkle
        nextAlarmDashedView.backgroundColor = .none
        nextAlarmDashedView.layer.cornerRadius = 25
        nextAlarmDashedView.setRoundedDashedBorder(strokeColor: UIColor.paleLilac.cgColor, fillColor: nil, cornerRadius: 25, lineDashPattern: [5,10], lineWidth: 2, lineCap: .round)

    }
    

}

extension AlarmMainVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: screenBounds.width/defaultViewWidth*messageViewHeight, left: 0, bottom: 0, right: 0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y >= 0{
            dongdongBottomConstraint.constant = y
        }
        else{
            dongdongBottomConstraint.constant = 0
        }
        
    }
    
}

extension AlarmMainVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarmList.count
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlarmCardCVC", for: indexPath) as? AlarmCardCVC else{ return UICollectionViewCell()}
        return cell
    }
    
}
