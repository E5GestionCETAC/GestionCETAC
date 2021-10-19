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
        db.collection("usuarios").whereField("activo", isEqualTo: true).getDocuments { (querySnapshot, error) in
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
        db.collection("usuarios").whereField("cetacUserID", isEqualTo: currentUserUID).whereField("activo", isEqualTo: true).getDocuments { (querySnapshot, error) in
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
    
    func getUser(userID:Int, completion: @escaping (Result<Usuario, Error>) -> Void){
        var usuario:Usuario?
        db.collection("usuarios").whereField("id", isEqualTo: userID).limit(to: 1).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    usuario = Usuario(aDoc: document)
                }
                completion(.success(usuario!))
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
    
    func getMale(completion: @escaping (Result<Int, Error>) -> Void){
        var usuarios = [Usuario]()
        db.collection("usuarios").whereField("sexo", isEqualTo: "Masculino").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = Usuario(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios.count))
            }
        }
    }
    
    func getFemale(completion: @escaping (Result<Int, Error>) -> Void){
        var usuarios = [Usuario]()
        db.collection("usuarios").whereField("sexo", isEqualTo: "Femenino").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = Usuario(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios.count))
            }
        }
    }
    
    func getOtro(completion: @escaping (Result<Int, Error>) -> Void){
        var usuarios = [Usuario]()
        db.collection("usuarios").whereField("sexo", isEqualTo: "Otro").getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    let u = Usuario(aDoc: document)
                    usuarios.append(u)
                }
                completion(.success(usuarios.count))
            }
        }
    }
    
    func getSexo(completion: @escaping (Result<[Int], Error>) -> Void){
        var usuarios = [Usuario]()
        var sexos:[Int] = [0,0,0]
        
        db.collection("usuarios").whereField("activo", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error{
                completion(.failure(error))
            }else{
                for document in querySnapshot!.documents{
                    var u = Usuario(aDoc: document)
                    if u.sexo == "Masculino"{
                        sexos[0] += 1
                    }
                    else if u.sexo == "Femenino"{
                        sexos[1] += 1
                    }
                    else{
                        sexos[2] += 1
                    }
                    
                }
                completion(.success(sexos))
            }
        }
    }
    
    func insertUsuario(nuevoUsuario:Usuario, completion: @escaping (Result<String, Error>) -> Void){
        var ref: DocumentReference? = nil
        ref = db.collection("usuarios").addDocument(data: [
            "id" : nuevoUsuario.id,
            "edad" : nuevoUsuario.edad,
            "fecha_nacimiento" : nuevoUsuario.fecha_nacimiento,
            "activo" : nuevoUsuario.activo,
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
            "cetacUserID" : nuevoUsuario.cetacUserID,
            "numeroHijos" : nuevoUsuario.numeroHijos,
            "detalleHijos" : nuevoUsuario.detalleHijos
        ]){ err in
            if let err = err{
                print("Error loading document: \(err)")
                completion(.failure(err))
            }else{
                completion(.success(ref!.documentID))
            }
        }
    }
    
    func updateUsuario(updateUsuario:Usuario, completion: @escaping (Result<String, Error>) -> Void){
        db.collection("usuarios").document(updateUsuario.usuarioID).updateData([
            "id" : updateUsuario.id,
            "edad" : updateUsuario.edad,
            "fecha_nacimiento" : updateUsuario.fecha_nacimiento,
            "activo" : updateUsuario.activo,
            "nombre" : updateUsuario.nombre,
            "apellido_paterno" : updateUsuario.apellido_paterno,
            "apellido_materno" : updateUsuario.apellido_materno,
            "ocupacion" : updateUsuario.ocupacion,
            "religion" : updateUsuario.religion,
            "tel_casa" : updateUsuario.tel_casa,
            "celular" : updateUsuario.celular,
            "estado_civil" : updateUsuario.estado_civil,
            "problema" : updateUsuario.problema,
            "sexo" : updateUsuario.sexo,
            "ekr" : updateUsuario.ekr,
            "indicador_actitudinal" : updateUsuario.indicador_actitudinal,
            "domicilio" : updateUsuario.domicilio,
            "procedencia" : updateUsuario.procedencia,
            "referido_por" : updateUsuario.referido_por,
            "cetacUserID" : updateUsuario.cetacUserID,
            "numeroHijos" : updateUsuario.numeroHijos,
            "detalleHijos" : updateUsuario.detalleHijos
        ]){ err in
            if let err = err{
                print("Error loading document: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Datos del usuario actualizados correctamente"))
            }
        }
    }
    
    func deleteUsuario(deleteUsuario:Usuario, completion: @escaping (Result<String, Error>) -> Void){
        db.collection("usuarios").document(deleteUsuario.usuarioID).delete(){ err in
            if let err = err{
                print("Error loading document: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Usuario eliminado correctamente"))
            }
        }
    }
}
