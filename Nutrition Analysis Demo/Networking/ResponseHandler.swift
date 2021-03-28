//
//  ResponseHandler.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 25/03/2021.
//

import Foundation
import Alamofire

enum ResponseEnum {
    case failure(_ error: ApiError?, _ data: Any?)
    case success(_ value: Any?)
}

enum ApiError: Int {
    case BadRequest = 400
    case ServerError = 500
    case ClientSideError = 0
    case lawQuailty = 555
    case unprocessableEntity = 422
    
    var message: String{
        switch self {
        case .BadRequest:
            return "Bad request"
        case .ServerError:
            return "Internal Server Error"
        case .ClientSideError:
            return "ClientSide Error"
        case .lawQuailty:
            return "Recipe with insufficient quality to process correctly"
        case .unprocessableEntity:
            return "Couldn’t parse the recipe or extract the nutritional info"
        }
    }
    
    var title: String{
        switch self {
        case .BadRequest:
            return "Bad request"
        case .ServerError:
            return "Internal Server Error"
        case .ClientSideError:
            return "ClientSide Error"
        case .lawQuailty:
            return "law quailty"
        case .unprocessableEntity:
            return "unprocessable entity"
        }
    }
}

class ResponseHandler {
    
    static let instance = ResponseHandler()
    
    private init() {}
    
    func handleResponse<T: BaseModel>(_ response: AFDataResponse<Any>, model: T.Type) -> ResponseEnum {
        guard let code = response.response?.statusCode else {
            return .failure(ApiError.ClientSideError, nil)
        }
        if code < 400, let res = response.value as? Parameters {
            return handleResponseData(response: .success(res), model: model)
        } else {
            return errorHandling(response.value, code: code)
        }
    }
    
    private func errorHandling(_ res: Any?, code: Int) -> ResponseEnum {
        let error = ApiError(rawValue: code)
        if let res = res {
            let errorModel = ErrorModel.decodeJSON(res, To: ErrorModel.self, format: .useDefaultKeys)
            return .failure(error, errorModel)
        }
        return .failure(error, nil)
    }
    
    private func handleResponseData<T: BaseModel>( response: ResponseEnum, model: T.Type) -> ResponseEnum {
        switch response {
        case .success(let value):
            guard let value = value else {
                return .failure(ApiError.ClientSideError, nil)
            }
            let responseData = model.decodeJSON(value, To: model, format: .useDefaultKeys)
            return .success(responseData)
        case .failure(let error, let data):
            return .failure(error, data)
        }
    }
}
