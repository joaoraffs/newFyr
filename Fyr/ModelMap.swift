//
//  ModelMap.swift
//  NasaApp
//
//  Created by Maykon Meneghel on 19/10/19.
//  Copyright © 2019 Maykon Meneghel. All rights reserved.
//

import Foundation
import Firebase

class ModelMap{
    static let shared: ModelMap = ModelMap()
    private init() {}
    
    var dataList: [DataFire] = []
    
    static func loadMap(completion: ((Bool) -> Void)? = nil){
        let db = Firestore.firestore()
        
        db.collection("Data").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                ModelMap.shared.dataList.removeAll()
                
                for document in querySnapshot!.documents {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data())
                        let dataFire = try JSONDecoder().decode(DataFire.self, from: data)
                        ModelMap.shared.dataList.append(dataFire)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if let completion = completion {
                    completion(true)
                }
            }
        }
    }
}
