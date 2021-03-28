//
//  MHProgress.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import UIKit

class MHProgress: UIView {
    
    private let indecator = UIActivityIndicatorView()
    private let containerView = UIVisualEffectView()
    private let title = UILabel()
    
    static let sharedMHP = MHProgress()
    
    private init() {
        let size = UIScreen.main.bounds.size
        let origin = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: origin, size: size)
        super.init(frame: rect)
        configureContainer()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureContainer() {
        self.backgroundColor = UIColor.clear
        containerView.cornerRadius = 10
        containerView.clipToBounds = true
        containerView.backgroundColor = .lightGray
        containerView.layer.opacity = 1
        containerView.effect = UIBlurEffect(style: .light)
        containerView.frame.size = CGSize(width: 110, height: 110)
        containerView.frame.origin = CGPoint(x: (UIScreen.main.bounds.width/2 - containerView.frame.width/2),
                                             y: (UIScreen.main.bounds.height/2 - containerView.frame.height/2))
        
        //indecator.frame.size = CGSize(width: 100, height: 100)
        indecator.frame.origin = CGPoint(x: (containerView.frame.width/2) - (indecator.frame.width/2) ,
                                         y: (containerView.frame.height/2) - (indecator.frame.height/2))
        if #available(iOS 13.0, *) {
            indecator.style = .large
        } else {
            indecator.style = .gray
        }
        indecator.tintColor = #colorLiteral(red: 0, green: 0.2307513952, blue: 0.2930913568, alpha: 1)
        indecator.color = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        title.frame.size = CGSize(width: containerView.frame.width - 10, height: 40)
        title.frame.origin = CGPoint(x: ((containerView.frame.width) / 2) - (title.frame.width / 2) ,
                                         y: ((containerView.frame.height) - 45 ))
        title.textColor = #colorLiteral(red: 0, green: 0.2716432937, blue: 0.3464305065, alpha: 1)
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.font = UIFont.systemFont(ofSize: 15)
        title.numberOfLines = 0
        
        containerView.contentView.addSubview(indecator)
        containerView.contentView.addSubview(title)
        containerView.bringSubviewToFront(title)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
    }
    
    func show(with title: String = "") {
        DispatchQueue.main.async {
            self.title.text = title
            self.indecator.startAnimating()
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.indecator.stopAnimating()
            self.title.text = ""
            self.removeFromSuperview()
        }
    }
}
