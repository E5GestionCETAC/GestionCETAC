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
    
    func fetchCetacUsuarios(completion: @escaping (Result<CetacUsuarios, Error>) -> Void){
        var usuarios = [cetacUser]()
        db.collection("cetacUsers").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = cetacUser(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios))
            }
        }
    }
    
    func fetchCetacUsuariosWithUID(cetacUserUID:String,completion: @escaping (Result<CetacUsuarios, Error>) -> Void){
        var usuarios = [cetacUser]()
        db.collection("cetacUsers").whereField("uid", isEqualTo: cetacUserUID).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = cetacUser(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios))
            }
        }
    }
    
    func fetchCetacUsuarioWithUID(cetacUserUID:String,completion: @escaping (Result<cetacUser, Error>) -> Void){
        var cetacuser:cetacUser?
        db.collection("cetacUsers").whereField("uid", isEqualTo: cetacUserUID).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    cetacuser = cetacUser(aDoc: document)
                }
                completion(.success(cetacuser!))
            }
        }
    }
    
    func getUserInfo(completion: @escaping (Result<cetacUser, Error>) -> Void) {
        db.collection("cetacUsers").whereField("uid", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    self.currentUser = cetacUser(aDoc: document)
                }
                completion(.success(self.currentUser!))
            }
        }
    }
}
