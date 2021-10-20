//
//  GetSesionInfoTest.swift
//  Tests
//
//  Created by Agustín Abreu on 20/10/21.
//

import XCTest
@testable import GestionCETAC
class GetSesionInfoTest: XCTestCase {

    var expec = XCTestExpectation()
    let controlador = sesionController()
    
    override func setUpWithError() throws {
        self.expec = expectation(description: "Test")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // Se espera que se recupere el mismo usuario de la base de datos
    func testExample1() throws {
        let sesionUID = "s6anT6AgfhtsgN0Zp7hY"
        controlador.getSesionNumber(userID: 7, sesionNumber: 3){ (result) in
            switch result{
            case .success(let sesion):XCTAssertEqual(sesion.sesionID, sesionUID)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    
    func testExample2() throws {
        let sesionUID = "s6anT6AgfhtsgN0Zp7hY"
        controlador.getSesionNumber(userID: 7, sesionNumber: 2){ (result) in
            switch result{
            case .success(let sesion):XCTAssertNotEqual(sesion.sesionID, sesionUID)
            case .failure(let error):XCTAssertNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
    
    
    func testExample3() throws {
        let sesionUID = ""
        controlador.getSesionNumber(userID: 7, sesionNumber: 4){ (result) in
            switch result{
            case .success(let sesion):XCTAssertNotEqual(sesion.sesionID,sesionUID)
            case .failure(let error):XCTAssertNotNil(error)
            }
            self.expec.fulfill()
        }
        self.waitForExpectations(timeout: 10.0)
    }
}
