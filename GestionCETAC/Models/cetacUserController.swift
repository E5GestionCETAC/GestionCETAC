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
    
    func getUserInfo(currentUserUID:String, completion: @escaping (Result<cetacUser, Error>) -> Void) {
        var currentUser:cetacUser?
        db.collection("cetacUsers").whereField("uid", isEqualTo: currentUserUID).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    currentUser = cetacUser(aDoc: document)
                }
                if currentUser != nil{
                    completion(.success(currentUser!))
                }else{
                    completion(.failure(CustomError.notFound))
                }
            }
        }
    }
    
    func createUser(user:cetacUser, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password){ (result,error) in
            if let error = error{
                completion(.failure(error))
            }else{
                self.db.collection("cetacUsers").addDocument(data: ["nombre":user.nombre, "apellidos" : user.apellidos, "rol": user.rol, "uid": result!.user.uid, "email" : user.email]) { (error) in
                    if let error = error{
                        completion(.failure(error))
                    }else{
                        UserDefaults.standard.set(result!.user.uid, forKey: "currentCetacUserUID")
                        UserDefaults.standard.set(user.rol, forKey: "currentCetacUserRol")
                        completion(.success("Éxito"))
                    }
                }
            }
        }
    }
}
