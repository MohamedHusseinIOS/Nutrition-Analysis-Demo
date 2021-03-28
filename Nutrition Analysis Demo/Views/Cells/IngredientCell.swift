//
//  IngredientCell.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 27/03/2021.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var quintityLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var foodLbl: UILabel!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    
    static let id = "IngredientCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(ingr: IngredientAnalysis, ingrStr: String){
        let ingrAtrr = ingrStr.split(separator: " ").compactMap({String($0)})
        if ingrAtrr.count > 2 {
            quintityLbl.text = ingrAtrr[0]
            unitLbl.text = ingrAtrr[1]
            foodLbl.text =  ingrAtrr[2]
        } else if ingrAtrr.count == 2 {
            quintityLbl.text = "-"
            unitLbl.text = ingrAtrr[0]
            foodLbl.text =  ingrAtrr[1]
        } else if ingrAtrr.count < 2 {
            quintityLbl.text = "-"
            unitLbl.text = "-"
            foodLbl.text =  ingrAtrr[0]
        }
        caloriesLbl.text = "\(ingr.calories ?? 0)"
        weightLbl.text = "\(ingr.totalWeight ?? 0)"
    }
}
