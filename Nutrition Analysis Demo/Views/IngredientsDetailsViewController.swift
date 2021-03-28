//
//  IngredientsDetailsViewController.swift
//  Nutrition Analysis Demo
//
//  Created by Admin on 28/03/2021.
//

import UIKit
import RxCocoa

class IngredientsDetailsViewController: BaseViewController {

    @IBOutlet weak var ingrsTableView: UITableView!
    
    let viewModel = IngredientsViewModel()
    var ingrsStrArr: [String]?
    var ingrs: [IngredientAnalysis]?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if let ingrsStrArr = ingrsStrArr {
            viewModel.getIngredientsAnalysis(ingrs: ingrsStrArr)
        }
    }
    
    override func configureData(){
        viewModel.failure.subscribe { (errorEvent) in
            let error = errorEvent.element
            self.alert(title: error?.error ?? "Error", message: error?.message ?? "", completion: nil)
        }.disposed(by: viewModel.disposeBag)
    }
    
    override func configureUI(){
        setupTableView()
        registerCell()
    }
    
    func registerCell(){
        let nib =  UINib(nibName: IngredientCell.id, bundle: .main)
        ingrsTableView.register(nib, forCellReuseIdentifier: IngredientCell.id)
    }
    
    func setupTableView(){
        ingrsTableView.delegate = nil
        ingrsTableView.dataSource = nil
        viewModel.output.ingredientAnalysis.bind(to: ingrsTableView.rx.items){ (tableView, row, element) -> UITableViewCell in
            let indexPath = IndexPath(row: row, section: 0)
            return self.cellFotRow(tableView: tableView, indexPath: indexPath, element: element)
        }.disposed(by: bag)
    }
    
    func cellFotRow(tableView: UITableView, indexPath: IndexPath, element: IngredientAnalysis) -> IngredientCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.id, for: indexPath) as? IngredientCell else { return IngredientCell() }
        guard let ingr = self.ingrsStrArr?[indexPath.row] else { return IngredientCell() }
        cell.bindData(ingr: element, ingrStr: ingr)
        return cell
    }

}
