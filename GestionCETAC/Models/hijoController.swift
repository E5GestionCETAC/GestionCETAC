//
//  hijoController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 07/10/21.
//

import Foundation
import Firebase

class hijoController{
    let db = Firestore.firestore()
    func insertHijo(usuarioDocumentID:String, nuevoHijo:Hijo, completion: @escaping (Result<String, Error>) -> Void){
        db.collection("usuarios").document(usuarioDocumentID).collection("hijos").addDocument(data: [
            "id" : nuevoHijo.id,
            "sexo" : nuevoHijo.sexo,
            "edad" : nuevoHijo.edad
        ]){ err in
            if let err = err{
                completion(.failure(err))
            }else{
                completion(.success("Se insertaron correctamente la información del hijo(s)"))
            }
        }
    }
    
    func fetchHijos(usuarioDocumentID:String, completion: @escaping (Result<Hijos, Error>) -> Void){
        var hijosArray = [Hijo]()
        db.collection("usuarios").document(usuarioDocumentID).collection("hijos").getDocuments{(querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let h = Hijo(aDoc: document)
                    hijosArray.append(h)
                }
                completion(.success(hijosArray))
            }
            
        }
    }
    
    func updateHijo(usuarioDocumentID:String, updateHijo:Hijo, completion: @escaping (Result<String, Error>) -> Void){
        db.collection("usuarios").document(usuarioDocumentID).collection("hijos").document(updateHijo.documentID).updateData([
            "id" : updateHijo.id,
            "sexo" : updateHijo.sexo,
            "edad" : updateHijo.edad
        ]){ err in
            if let err = err{
                completion(.failure(err))
            }else{
                completion(.success("Se insertaron correctamente la información del hijo(s)"))
            }
        }
    }
}
