//
//  ServerPaths.swift
//  MenuApp
//
//  Created by Mohamed Hussien on 16/10/2019.
//  Copyright © 2019 HNF. All rights reserved.
//

import Foundation

/// api.edamam.com/api/nutrition-details?app_id=${YOUR_APP_ID}&app_key=${YOUR_APP_KEY}

enum ServerPaths: String {
    case BaseURL            = "https://api.edamam.com/api/"
    case NutritionDetails   = "nutrition-details"
    case NutritionData      = "nutrition-data"
    
    func fullUrl(appID: String, appKey: String) -> String {
        return self.rawValue + "?" + "app_id=\(appID)" + "&app_key=\(appKey)"
    }
}
