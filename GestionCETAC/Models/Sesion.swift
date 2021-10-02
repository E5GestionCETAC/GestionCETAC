//
//  Sesion.swift
//  GestionCETAC
//
//  Created by user195142 on 10/1/21.
//

import Foundation
import Firebase

struct Sesion {
    let numero_expediente, numero_sesion, cuota_recuperacion : Int
    let usuario, tanatologo, motivo, tipo_servicio, herramienta, evaluacion_sesion : String
    let fecha : Timestamp
    
    init (numero_expediente:Int, numero_sesion:Int, cuota_recuperacion:Int, usuario:String, tanatologo:String, motivo:String, tipo_servicio:String, herramienta:String, evaluacion_sesion:String, fecha:Timestamp){
        
        self.numero_expediente = numero_expediente
        self.numero_sesion = numero_sesion
        self.cuota_recuperacion = cuota_recuperacion
        self.usuario = usuario
        self.tanatologo = tanatologo
        self.motivo = motivo
        self.tipo_servicio = tipo_servicio
        self.herramienta = herramienta
        self.evaluacion_sesion = evaluacion_sesion
        self.fecha = fecha
        
    }
    init(aDoc : DocumentSnapshot) {
        self.numero_expediente = aDoc.get("numero_expediente") as? Int ?? 0
        self.numero_sesion = aDoc.get("numero_sesion") as? Int ?? 0
        self.cuota_recuperacion = aDoc.get("cuota_recuperacion") as? Int ?? 0
        self.usuario = aDoc.get("usuario") as? String ?? ""
        self.tanatologo = aDoc.get("tanatologo") as? String ?? ""
        self.motivo = aDoc.get("motivo") as? String ?? ""
        self.tipo_servicio = aDoc.get("tipo_servicio") as? String ?? ""
        self.herramienta = aDoc.get("herramienta") as? String ?? ""
        self.evaluacion_sesion = aDoc.get("evaluacion sesion") as? String ?? ""
        self.fecha = aDoc.get("fecha") as? Timestamp ?? Timestamp()
        
    }
    
}
typealias Sesiones = [Sesion]


