//
//  BaseViewModel.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import Foundation
import RxSwift


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
       
    var input: Input { get }
    var output: Output { get }
}

class BaseViewModel {
    let disposeBag = DisposeBag()
    let failure = PublishSubject<ErrorModel>()
}
