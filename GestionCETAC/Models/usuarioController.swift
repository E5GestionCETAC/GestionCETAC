//
//  usuarioController.swift
//  GestionCETAC
//
//  Created by Agustín Abreu on 29/09/21.
//

import Foundation
import Firebase

class usuarioController{
    let db = Firestore.firestore()
    let currentUserUID:String = UserDefaults.standard.string(forKey: "currentCetacUserUID")!
    
    func fetchUsuarios(completion: @escaping (Result<Usuarios, Error>) -> Void){
        var usuarios = [Usuario]()
        db.collection("usuarios").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = Usuario(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios))
            }
        }
    }
    func fetchUsuariosFromCetacUser(completion: @escaping (Result<Usuarios, Error>) -> Void){
        var usuarios = [Usuario]()
        db.collection("usuarios").whereField("cetacUserID", isEqualTo: currentUserUID).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = Usuario(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios))
            }
        }
    }
    
    func getLastID(completion: @escaping (Result<Int, Error>) -> Void){
        var usuario:Usuario?
        db.collection("usuarios").order(by: "id", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    usuario = Usuario(aDoc: document)
                }
                completion(.success(usuario!.id))
            }
        }
    }
    
    func insertUsuario(nuevoUsuario:Usuario, completion: @escaping (Result<String, Error>) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("usuarios").addDocument(data: [
            "id" : nuevoUsuario.id,
            "edad" : nuevoUsuario.edad,
            "fecha_nacimiento" : nuevoUsuario.fecha_nacimiento,
            "nombre" : nuevoUsuario.nombre,
            "apellido_paterno" : nuevoUsuario.apellido_paterno,
            "apellido_materno" : nuevoUsuario.apellido_materno,
            "ocupacion" : nuevoUsuario.ocupacion,
            "religion" : nuevoUsuario.religion,
            "tel_casa" : nuevoUsuario.tel_casa,
            "celular" : nuevoUsuario.celular,
            "estado_civil" : nuevoUsuario.estado_civil,
            "problema" : nuevoUsuario.problema,
            "sexo" : nuevoUsuario.sexo,
            "ekr" : nuevoUsuario.ekr,
            "indicador_actitudinal" : nuevoUsuario.indicador_actitudinal,
            "domicilio" : nuevoUsuario.domicilio,
            "procedencia" : nuevoUsuario.procedencia,
            "referido_por" : nuevoUsuario.referido_por,
            "cetacUserID" : nuevoUsuario.cetacUserID
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
