//
//  Sesion.swift
//  GestionCETAC
//
//  Created by user195142 on 10/1/21.
//

import Foundation
import Firebase

struct Sesion {
    let usuarioID, numero_sesion : Int
    let tanatologoUID, motivo, tipo_servicio, herramienta, evaluacion_sesion : String
    let fecha : Timestamp
    let cuota_recuperacion:Float
    
    init (usuarioID:Int, numero_sesion:Int, cuota_recuperacion:Float, tanatologoUID:String, motivo:String, tipo_servicio:String, herramienta:String, evaluacion_sesion:String, fecha:Timestamp){
        
        self.usuarioID = usuarioID
        self.numero_sesion = numero_sesion
        self.cuota_recuperacion = cuota_recuperacion
        self.tanatologoUID = tanatologoUID
        self.motivo = motivo
        self.tipo_servicio = tipo_servicio
        self.herramienta = herramienta
        self.evaluacion_sesion = evaluacion_sesion
        self.fecha = fecha
        
    }
    init(aDoc : DocumentSnapshot) {
        self.usuarioID = aDoc.get("usuarioID") as? Int ?? 0
        self.numero_sesion = aDoc.get("numero_sesion") as? Int ?? 0
        self.cuota_recuperacion = aDoc.get("cuota_recuperacion") as? Float ?? 0
        self.tanatologoUID = aDoc.get("tanatologoUID") as? String ?? ""
        self.motivo = aDoc.get("motivo") as? String ?? ""
        self.tipo_servicio = aDoc.get("tipo_servicio") as? String ?? ""
        self.herramienta = aDoc.get("herramienta") as? String ?? ""
        self.evaluacion_sesion = aDoc.get("evaluacion sesion") as? String ?? ""
        self.fecha = aDoc.get("fecha") as? Timestamp ?? Timestamp()
    }
}
typealias Sesiones = [Sesion]


