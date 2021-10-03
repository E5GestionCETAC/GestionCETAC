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
    let currentUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!

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
    
    // Obtiene todas las sesiones de un miembro de Cetac
    func fetchSesionesFromCetacUser(completion: @escaping (Result<Sesiones, Error>) -> Void){
        var sesiones = [Sesion]()
        db.collection("sesiones").whereField("cetacUserID", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
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
    
    // Obtiene todas las sesiones de un usuario
    func fetchSesionesFromUser(userID:Int, completion: @escaping (Result<Sesiones, Error>) -> Void){
        var sesiones = [Sesion]()
        db.collection("sesiones").whereField("usuarioID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
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
    
    //Obtiene el ultimo numero de sesion de un usuario
    func getLastSesion(userID:Int, completion: @escaping (Result<Int, Error>) -> Void){
        var sesion:Sesion?
        db.collection("sesiones").whereField("usuarioID", isEqualTo: userID).order(by: "numero_sesion", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    sesion = Sesion(aDoc: document)
                }
                completion(.success(sesion!.numero_sesion))
            }
        }
    }
    
    func insertSesion(nuevaSesion:Sesion, completion: @escaping (Result<String, Error>) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("sesiones").addDocument(data: [
            "usuarioID" : nuevaSesion.usuarioID ,
            "numero_sesion" : nuevaSesion.numero_sesion,
            "cuota_recuperacion" : nuevaSesion.cuota_recuperacion,
            "tanatologoUID" : nuevaSesion.tanatologoUID,
            "motivo" : nuevaSesion.motivo,
            "tipo_servicio" : nuevaSesion.tipo_servicio,
            "herramienta" : nuevaSesion.herramienta,
            "evaluacion_sesion" : nuevaSesion.evaluacion_sesion,
            "fecha" : nuevaSesion.fecha

        ]){ err in
            if let err = err{
                completion(.failure(err))
            }else{
                completion(.success("Documento ID: \(ref!.documentID)"))
            }
        }
    }
}

