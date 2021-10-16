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
        db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
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
    
    func fetchTopFiveMotivos(completion: @escaping (Result<[(key:String, value:Int)], Error>) -> Void){
            var topFive : [String:Int] = [:]
            db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
                if let error = error{
                    completion(.failure(error))
                }else{
                    for document in querySnapshot!.documents{
                        let s = Sesion(aDoc: document)
                        let motivoExist = topFive[s.motivo] != nil
                        if motivoExist{
                            topFive[s.motivo]! += 1
                        }
                        else{
                            topFive[s.motivo] = 1
                        }
                    }
                    let retDic = topFive.sorted{ $0.value > $1.value }
                    completion(.success(retDic))
                }
            }
        }
    
    // Obtiene todas las sesiones de un miembro de Cetac
    func fetchSesionesFromCetacUser(completion: @escaping (Result<Sesiones, Error>) -> Void){
        var sesiones = [Sesion]()
        db.collection("sesiones").whereField("tanatologoUID", isEqualTo: currentUserUID).order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
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
        db.collection("sesiones").whereField("usuarioID", isEqualTo: userID).order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
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
    func getLastSesion(userID:Int, completion: @escaping (Result<Sesion, Error>) -> Void){
        var sesion:Sesion?
        db.collection("sesiones").whereField("usuarioID", isEqualTo: userID).order(by: "numero_sesion", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    sesion = Sesion(aDoc: document)
                }
                completion(.success(sesion!))
            }
        }
    }

    //Busca una sesion con un numero de sesion particular y un usuario
    func getSesionNumber(userID:Int, sesionNumber:Int, completion: @escaping (Result<Sesion, Error>) -> Void){
        var sesion:Sesion?
        db.collection("sesiones").whereField("usuarioID", isEqualTo: userID).whereField("numero_sesion", isEqualTo: sesionNumber).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    sesion = Sesion(aDoc: document)
                }
                completion(.success(sesion!))
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
            "tipo_intervencion" : nuevaSesion.tipo_intervencion,
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
    
    func updateSesion(updateSesion:Sesion, completion: @escaping (Result<String, Error>) -> Void){
        db.collection("sesiones").document(updateSesion.sesionID).updateData(["usuarioID" : updateSesion.usuarioID ,
            "numero_sesion" : updateSesion.numero_sesion,
            "cuota_recuperacion" : updateSesion.cuota_recuperacion,
            "tanatologoUID" : updateSesion.tanatologoUID,
            "motivo" : updateSesion.motivo,
            "tipo_servicio" : updateSesion.tipo_servicio,
            "tipo_intervencion" : updateSesion.tipo_intervencion,
            "herramienta" : updateSesion.herramienta,
            "evaluacion_sesion" : updateSesion.evaluacion_sesion,
            "fecha" : updateSesion.fecha
        ]){ err in
            if let err = err{
                completion(.failure(err))
            }else{
                completion(.success("Datos actualizados correctamente"))
            }
        }
    }
}

