//
//  instantiator.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import UIKit


protocol Instantiator {
    static func InstantiateFormStoryBoard(storyboardName name: String) -> Self?
    static func instantiateFromNib() -> Self?
}

extension Instantiator where Self: UIViewController{
    static func InstantiateFormStoryBoard(storyboardName name: String) -> Self? {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else{
            return nil
        }
        return viewController
    }
    
    static func instantiateFromNib() -> Self? {
        let id = String(describing: self)
        let Nib = UINib(nibName: id, bundle: nil)
        return Nib.instantiate(withOwner: nil, options: nil)[0] as? Self
    }
}
