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
    
    var currentUser:cetacUser?
    
    func getUserInfo(completion: @escaping (Result<cetacUser, Error>) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection("cetacUsers").whereField("uid", isEqualTo: user.uid).getDocuments { (querySnapshot, error) in
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
}
