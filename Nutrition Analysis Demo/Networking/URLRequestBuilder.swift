//
//  URLRequestBuilder.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 25/03/2021.
//

import Foundation
import Alamofire
import RxSwift

protocol URLRequestBuilder: URLRequestConvertible {
    
    var baseURL: String { get }
    
    var mainURL: URL { get }
    
    var requestURL: URL { get }
    
    var path: String { get }
    
    var header: HTTPHeaders { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
    
    func Request<T: BaseModel>(model: T.Type) -> Observable<T>
    
    func handelError<T: BaseModel>(apiError: ApiError?, data: Any?, observer: AnyObserver<T>)
    
}


extension URLRequestBuilder {
    
    var mainURL: URL {
        return URL(string: baseURL)!
    }
    
    var requestURL: URL {
        let urlStr = mainURL.absoluteString + path
        return URL(string: urlStr)!
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        header.forEach{ request.addValue($0.value, forHTTPHeaderField: $0.name)}
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    func Request<T: BaseModel>(model: T.Type) -> Observable<T> {
        MHProgress.sharedMHP.show()
        return Observable<T>.create { (observer) -> Disposable in
            AF.request(self).responseJSON { (response) in
                response.interceptResuest("\(self.requestURL)", self.parameters)
                let resEnum = ResponseHandler.instance.handleResponse(response, model: model)
                MHProgress.sharedMHP.hide()
                switch resEnum {
                case .success(let value):
                    if let model = value as? T {
                        observer.onNext(model)
                    }
                case .failure(let apiError, let data):
                    handelError(apiError: apiError, data: data, observer: observer)
                }
            }
            return Disposables.create()
        }
    }
    
    func handelError<T: BaseModel>(apiError: ApiError?, data: Any?, observer: AnyObserver<T>) {
        if let apiError = apiError {
            observer.onError(ErrorModel(message: apiError.message, error: apiError.title, code: apiError.rawValue))
        } else if let err = data as? ErrorModel{
            observer.onError(err)
        } else if let errorArr = data as? [ErrorModel]{
            observer.onError(errorArr.first ?? ErrorModel(message: apiError?.message ?? "", error: apiError?.title ?? "", code: apiError?.rawValue ?? 0 ))
        }
    }
}
