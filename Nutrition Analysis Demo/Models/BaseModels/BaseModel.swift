//
//  BaseModel.swift
//  Nutrition Analysis Demo
//
//  Created by mohamed hussein on 25/03/2021.
//

import Foundation

protocol BaseModel: Decoderable, Codable {
    func toJSON() -> [String: Any]?
}


extension BaseModel {
    
    func toJSON() -> [String: Any]? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            } else {
                debugPrint("[toJSON-JSONSerialization] fails to convert data to json.")
                return nil
            }
        } catch let error {
            debugPrint("[toJSON-func]\(error)")
            return nil
        }
    }
}
