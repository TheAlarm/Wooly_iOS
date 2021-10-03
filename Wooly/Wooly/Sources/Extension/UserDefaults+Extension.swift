//
//  UserDefaults+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/08/28.
//

import Foundation

extension UserDefaults{
    func setObjectList<T: Codable>(_ objectList: Array<T>, forKey: String ){
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(objectList), forKey: forKey)
    }

    func getObjectList<T: Codable>(_ type: T.Type, forKey: String) -> Array<T>?{
        if let data = UserDefaults.standard.value(forKey: forKey) as? Data {
            if let objectList = try? PropertyListDecoder().decode(Array<T>.self, from: data){
                return objectList
            }
        }
        return nil
    }
}
