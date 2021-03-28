//
//  RecipeAnalysisRouter.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 25/03/2021.
//

import Foundation
import Alamofire
import RxSwift

enum AnalysisRouter: URLRequestBuilder {
    
    case nutritionDetails(_ recipe: Recipe)
    case nutrationData(_ ingr: String)
    
    var baseURL: String {
        return ServerPaths.BaseURL.rawValue
    }
    
    var parameters: Parameters?{
        switch self {
        case .nutritionDetails(let recipe):
            return recipe.toJSON()
        case .nutrationData(let ingr):
            return ["ingr": ingr]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .nutritionDetails:
            return .post
        case .nutrationData:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .nutritionDetails:
            return ServerPaths.NutritionDetails.fullUrl(appID: APP_ID, appKey: APP_KEY)
        case .nutrationData:
            return ServerPaths.NutritionData.fullUrl(appID: APP_ID, appKey: APP_KEY)
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
}
