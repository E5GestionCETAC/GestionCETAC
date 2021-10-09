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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.usuario = cetacUser(nombre: "Juan", apellidos: "Calles", rol: "Administrador", email: "juan@test.com", password: "Hello$88")
        self.expec = expectation(description: "Test")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
