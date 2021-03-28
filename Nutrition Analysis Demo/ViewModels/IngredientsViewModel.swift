//
//  IngredientsViewController.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 27/03/2021.
//

import Foundation
import RxSwift
import RxRelay

class IngredientsViewModel: BaseViewModel, ViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {}
    
    struct Output {
        let ingredientAnalysis: Observable<[IngredientAnalysis]>
    }
    
    private let ingredientAnalysis = PublishRelay<[IngredientAnalysis]>()
    
    override init() {
        input = Input()
        output = Output(ingredientAnalysis: ingredientAnalysis.asObservable())
        super.init()
    }
    
    func getIngredientsAnalysis(ingrs: [String]) {
        var array = Array<Observable<IngredientAnalysis>>()
        for ingr in ingrs {
            let request = AnalysisRouter.nutrationData(ingr).Request(model: IngredientAnalysis.self)
            array.append(request)
        }
        Observable<IngredientAnalysis>.zip(array).subscribe { (event) in
            if  let ingrs = event.element {
                self.ingredientAnalysis.accept(ingrs)
            } else if let err = event.error as? ErrorModel{
                self.failure.onNext(err)
            } else {
                self.failure.onNext(ErrorModel(message: "somthing went wrong", error: "Error", code: 0))
            }
        }.disposed(by: disposeBag)
    }
}
