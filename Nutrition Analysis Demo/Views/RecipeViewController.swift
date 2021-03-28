//
//  ViewController.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 25/03/2021.
//

import UIKit
import RxCocoa

class RecipeViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var recipeTxtView: UITextView!
    @IBOutlet weak var analyseBtn: UIButton!
    @IBOutlet weak var tipsBtn: UIButton!
    
    let viewModel = RecipeViewModel()
    let recipeTextViewPlaceholder = "For example:\n1 cup orange juice\n3 tablespoons olive oil\n2 carrots"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupUI()
    }

    override func configureData() {
        viewModel.failure.subscribe { (errorEvent) in
            let error = errorEvent.element
            self.alert(title: error?.error ?? "Error", message: error?.message ?? "", completion: nil)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.output.recipeAnalysis.subscribe { (event) in
            guard let recipeAnalysis = event.element else {
                debugPrint("[recipeAnalysis-Home] response is not in the right way")
                self.alert(title: "Error", message: "Somthing went wrong", completion: nil)
                return
            }
            self.recipeAnalysisResponse(recipeAnalysis: recipeAnalysis)
        }.disposed(by: viewModel.disposeBag)
    }

    override func configureUI() {
        analyseBtn.rx.tap.bind { (_) in
            guard let recipe = self.getRecipeIngredients() else {
                return
            }
            self.viewModel.postRecipeToAnalyes(recipe: recipe)
        }.disposed(by: viewModel.disposeBag)
        
        tipsBtn.rx.tap.bind { (_) in
            guard let vc = TipsViewController.InstantiateFormStoryBoard(storyboardName: "Main") else { return }
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: viewModel.disposeBag)
        
        titleTxt.rx.controlEvent(.editingDidBegin).bind { (_) in
            self.titleView.borderColor = .lightGray
            self.titleTxt.placeholder = "Name of the recipe"
        }.disposed(by: viewModel.disposeBag)
        
        recipeTextViewActions(placeholder: recipeTextViewPlaceholder)
    }
    
    func setupUI(){
        scrollView.contentSize = containerView.frame.size
        recipeTxtView.sizeToFit()
        recipeTxtView.isScrollEnabled = false
        recipeTxtView.addDoneButtonOnKeyboard()
        titleTxt.addDoneButtonOnKeyboard()
        disapleAnalyseBtn()
        setPlaceholderTorecipeTextView(placeholder: recipeTextViewPlaceholder)
    }
    
    private func disapleAnalyseBtn() {
        analyseBtn.isEnabled = false
        analyseBtn.backgroundColor = .lightGray
    }
    
    private func enableAnalyesBtn(){
        analyseBtn.isEnabled = true
        analyseBtn.backgroundColor = .nutritionGreen
    }
    
    private func recipeTextViewActions(placeholder: String){
        recipeTxtView.rx.didBeginEditing.bind { (_) in
            if self.recipeTxtView.textColor == UIColor.lightGray {
                self.recipeTxtView.text = ""
                self.recipeTxtView.textColor = UIColor.black
            }
        }.disposed(by: viewModel.disposeBag)
        
        recipeTxtView.rx.didEndEditing.bind { (_) in
            self.setPlaceholderTorecipeTextView(placeholder: placeholder)
            if self.recipeTxtView.textColor == .black {
                self.enableAnalyesBtn()
            } else {
                self.disapleAnalyseBtn()
            }
        }.disposed(by: viewModel.disposeBag)
        
        recipeTxtView.rx.didChange.bind { (_) in
            
        }.disposed(by: viewModel.disposeBag)
    }
    
    private func setPlaceholderTorecipeTextView(placeholder: String){
        if self.recipeTxtView.text.isEmpty {
            self.recipeTxtView.text = placeholder
            self.recipeTxtView.textColor = UIColor.lightGray
        }
    }
    
    func getRecipeIngredients() -> Recipe? {
        guard let title = titleTxt.text, !title.isEmpty else {
            titleView.borderColor = .red
            titleTxt.placeholder = "Name of the recipe is required"
            return nil
        }
        guard let recpieStr = recipeTxtView.text else {
            return nil
        }
        let ingredients = recpieStr.split(separator: "\n").compactMap({String($0)})
        let recipe = Recipe(ingr: ingredients, title: title)
        return recipe
    }
    
    func recipeAnalysisResponse(recipeAnalysis: RecipeAnalysis) {
        debugPrint(recipeAnalysis)
    }
}
