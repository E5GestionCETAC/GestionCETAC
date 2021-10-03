//
//  cetacUserController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 28/09/21.
//

import Foundation
import Firebase

class cetacUserController {
    let db = Firestore.firestore()
    
    let currentUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    var currentUser:cetacUser?
    
    func getUserInfo(completion: @escaping (Result<cetacUser, Error>) -> Void) {
        db.collection("cetacUsers").whereField("uid", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    self.currentUser = cetacUser(aDoc: document)
                    completion(.success(self.currentUser!))
                }
            }
        }
    }
}
