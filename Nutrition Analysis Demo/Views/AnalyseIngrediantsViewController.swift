//
//  AnalyseIngrediantsViewController.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 26/03/2021.
//

import UIKit

class AnalyseIngredientsViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipeView: UIView!
    @IBOutlet weak var recipeTxtView: UITextView!
    @IBOutlet weak var analyseBtn: UIButton!
    @IBOutlet weak var tipsBtn: UIButton!
    
    let viewModel = IngredientsViewModel()
    let recipeTextViewPlaceholder = "For example:\n1 cup orange juice\n3 tablespoons olive oil\n2 carrots"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupUI()
    }
    
    override func configureUI() {
        analyseBtn.rx.tap.bind { (_) in
            guard let ingredients = self.getRecipeIngredients() else {
                return
            }
            guard let vc = IngredientsDetailsViewController.InstantiateFormStoryBoard(storyboardName: Storyboards.Main.rawValue) else { return }
            vc.ingrsStrArr = ingredients
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: viewModel.disposeBag)

        tipsBtn.rx.tap.bind { (_) in
            guard let vc = TipsViewController.InstantiateFormStoryBoard(storyboardName: Storyboards.Main.rawValue) else { return }
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: viewModel.disposeBag)
        
        recipeTextViewActions(placeholder: recipeTextViewPlaceholder)
    }
    
    func setupUI(){
        scrollView.contentSize = containerView.frame.size
        recipeTxtView.sizeToFit()
        recipeTxtView.isScrollEnabled = false
        recipeTxtView.addDoneButtonOnKeyboard()
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
    }
    
    private func setPlaceholderTorecipeTextView(placeholder: String){
        if self.recipeTxtView.text.isEmpty {
            self.recipeTxtView.text = placeholder
            self.recipeTxtView.textColor = UIColor.lightGray
        }
    }
    
    func getRecipeIngredients() -> [String]? {
        guard let recpieStr = recipeTxtView.text else {
            return nil
        }
        let ingredients = recpieStr.split(separator: "\n").compactMap({String($0)})
        return ingredients
    }

}
