//
//  sesionController.swift
//  GestionCETAC
//
//  Created by user195142 on 10/1/21.
//

import Foundation
import Firebase

class sesionController{
    let db = Firestore.firestore()
    
    func fetchSesiones(completion: @escaping (Result<Sesiones, Error>) -> Void){
        var sesiones = [Sesion]()
        db.collection("sesiones").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    sesiones.append(s)
                }
                completion(.success(sesiones))
            }
        }
    }
    //duda sobre id
    func fetchSesionesFromCetacUser(cetacUID:String, completion: @escaping (Result<Sesiones, Error>) -> Void){
        var sesiones = [Sesion]()
        db.collection("sesiones").whereField("cetacUserID", isEqualTo: cetacUID).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    sesiones.append(s)
                }
                completion(.success(sesiones))
            }
        }
    }
    
    func getLastID(completion: @escaping (Result<Int, Error>) -> Void){
        var sesion:Sesion?
        db.collection("sesiones").order(by: "numero_sesion", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    sesion = Sesion(aDoc: document)
                }
                completion(.success(sesion!.id))
            }
        }
    }
    
    func insertSesion(nuevaSesion:Sesion, completion: @escaping (Result<String, Error>) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("sesiones").addDocument(data: [
            
            "numero_expediente" = nuevaSesion.numero_expediente
            "numero_sesion" = nuevaSesion.numero_sesion
            "cuota_recuperacion" = nuevaSesion.cuota_recuperacion
            "usuario" = nuevaSesion.usuario
            "tanatologo" = nuevaSesion.tanatologo
            "motivo" = nuevaSesion.motivo
            "tipo_servicio" = nuevaSesion.tipo_servicio
            "herramienta" = nuevaSesion.herramienta
            "evaluacion_sesion" = nuevaSesion.evaluacion_sesion
            "fecha" = nuevaSesion.fecha

        ]){ err in
            if let err = err{
                print("Error loading document: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Documento agregado ID: \(ref!.documentID)"))
            }
            
        }
    }
}

