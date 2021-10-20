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
                if sesion != nil{
                    completion(.success(sesion!))
                }
                else{
                    completion(.failure(CustomError.notFound))
                }
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
                if sesion != nil{
                    completion(.success(sesion!))
                }
                else{
                    completion(.failure(CustomError.notFound))
                }
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
    //Indicadores
    
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
    
    func fetchTopFiveIntervenciones(completion: @escaping (Result<[(key:String, value:Int)], Error>) -> Void){
        var topFive : [String:Int] = [:]
        db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    let motivoExist = topFive[s.tipo_intervencion] != nil
                    if motivoExist{
                        topFive[s.tipo_intervencion]! += 1
                    }
                    else{
                        topFive[s.tipo_intervencion] = 1
                    }
                }
                let retDic = topFive.sorted{ $0.value > $1.value }
                completion(.success(retDic))
            }
        }
    }
    
    func fetchIndicadoresServicios(completion: @escaping (Result<[(key:String, value:Int)], Error>) -> Void){
        var servicios : [String:Int] = ["Servicios Holísticos":0, "Servicios de Acompañamiento":0, "Herramientas Alternativas":0]
        db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    servicios[s.tipo_servicio]! += 1
                }
                let retDic = servicios.sorted{ $0.value > $1.value }
                completion(.success(retDic))
            }
        }
    }
    
    func getCuotaRecuperacionByMonth(completion: @escaping (Result<[(key:String, value:Float)], Error>) -> Void){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        var dictionary:[String:Float] = ["01":0,"02":0,"03":0,"04":0,"05":0,"06":0,"07":0,"08":0,"09":0,"10":0,"11":0,"12":0]
        db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    let date = s.fecha.dateValue()
                    let month = formatter.string(from: date)
                        dictionary[month]! += s.cuota_recuperacion
                }
                let retDic = dictionary.sorted{ $0.key < $1.key }
                completion(.success(retDic))
            }
        }
    }
    
    func getCuotaRecuperacionByLastWeek(completion: @escaping (Result<[(key:String, value:Float)], Error>) -> Void){
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "dd"
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd"
        let day1 = Calendar.current.date(byAdding: .day, value: -7,to: Date())
        let day2 = Calendar.current.date(byAdding: .day, value: -6,to: Date())
        let day3 = Calendar.current.date(byAdding: .day, value: -5,to: Date())
        let day4 = Calendar.current.date(byAdding: .day, value: -4,to: Date())
        let day5 = Calendar.current.date(byAdding: .day, value: -3,to: Date())
        let day6 = Calendar.current.date(byAdding: .day, value: -2,to: Date())
        let day7 = Calendar.current.date(byAdding: .day, value: -1,to: Date())
        let day8 = Date()
        var dictionary:[String:Float] = [formatterDay.string(from: day1!):0,formatterDay.string(from: day2!):0,formatterDay.string(from: day3!):0,formatterDay.string(from: day4!):0,formatterDay.string(from: day5!):0,formatterDay.string(from: day6!):0,formatterDay.string(from: day7!):0,formatterDay.string(from: day8):0]
        db.collection("sesiones").order(by: "fecha", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let s = Sesion(aDoc: document)
                    let date = s.fecha.dateValue()
                    if formatterDate.string(from: date) == formatterDate.string(from: day1!) || formatterDate.string(from: date) == formatterDate.string(from: day2!) || formatterDate.string(from: date) == formatterDate.string(from: day3!) || formatterDate.string(from: date) == formatterDate.string(from: day4!) || formatterDate.string(from: date) == formatterDate.string(from: day5!) || formatterDate.string(from: date) == formatterDate.string(from: day6!) || formatterDate.string(from: date) == formatterDate.string(from: day7!) || formatterDate.string(from: date) == formatterDate.string(from: day8){
                        dictionary[formatterDay.string(from: date)]! += s.cuota_recuperacion
                    }
                }
                let retDic = dictionary.sorted{ $0.key < $1.key }
                completion(.success(retDic))
            }
        }
    }
    
    //End Indicadores
}

