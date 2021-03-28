//
//  HomeViewModel.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import Foundation
import RxSwift
import RxRelay

class RecipeViewModel: BaseViewModel, ViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {}
    
    struct Output {
        let recipeAnalysis: Observable<RecipeAnalysis>
    }
    
    private let recipeAnalysis = PublishRelay<RecipeAnalysis>()
    
    override init() {
        input = Input()
        output = Output(recipeAnalysis: recipeAnalysis.asObservable())
        super.init()
    }
    
    func postRecipeToAnalyes(recipe: Recipe) {
        AnalysisRouter.nutritionDetails(recipe).Request(model: RecipeAnalysis.self).subscribe { (recipeAnalysis) in
            self.recipeAnalysis.accept(recipeAnalysis)
        } onError: { (error) in
            let error = error as? ErrorModel ?? ErrorModel(message: error.localizedDescription, error: "", code: 0 )
            self.failure.onNext(error)
        } onCompleted: {
            print("[recipeAnalysis-HomeViewModel]onCompeted")
        } onDisposed: {
            print("[recipeAnalysis-HomeViewModel]onDisposed")
        }.disposed(by: disposeBag)
    }
    
    
}
