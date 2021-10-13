//
//  ValidateSignUpTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class ValidateSignUpTest: XCTestCase {

    let controlador = cetacUserController()
    var usuario: cetacUser?
    var expec = XCTestExpectation()
    override func setUpWithError() throws {
        self.usuario = cetacUser(nombre: "Rodrigo", apellidos: "Calles", rol: "Administrador", email: "rodrigo@test.com", password: "Hello$88")
        self.expec = expectation(description: "Test")
    }

    // En este caso se busca insertar un usuario en la base de datos, este caso se inserta exitosamente el usuario
    func testExample1() throws {
        self.controlador.createUser(user: self.usuario!){ (result) in
            switch result{
            case .success(let retorno) : XCTAssertEqual("Éxito", retorno)
            case .failure(let error) : XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }

    
    // En este caso se busca insertar el mismo usuario, pero en este caso la prueba fallara porque el email de este usuario ya ha sido registrado registrado
    func testExample2() throws {
        self.controlador.createUser(user: self.usuario!){ (result) in
            switch result{
            case .success(let retorno) : XCTAssertEqual("Éxito", retorno)
            case .failure(let error) : XCTAssertNotNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
}
