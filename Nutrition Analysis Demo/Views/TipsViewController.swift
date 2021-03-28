//
//  TipsViewController.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import UIKit

class TipsViewController: BaseViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        closeBtn.rx.tap.bind { (_) in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)
    }
    
    override func tapAction(_ senedr: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}


extension TipsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self.view)
        if containerView.frame.contains(touchLocation) {
            return false
        }
        return true
    }
}
