//
//  BaseViewController.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, Instantiator {

    let tap = UITapGestureRecognizer()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(tapAction(_:)))
        navigationController?.navigationBar.tintColor = .white
        configureData()
        configureUI()       
    }
    
    func configureData(){}
    
    func configureUI(){}

    @objc func tapAction(_ senedr: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func alert(title: String, message: String, completion: (()->Void)?){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        
        alert.addAction(action)
        navigationController?.present(alert, animated: true, completion: nil)
    }
}
