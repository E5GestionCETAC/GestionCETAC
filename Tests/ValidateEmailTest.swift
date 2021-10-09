//
//  ValidateEmailTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class ValidateEmailTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus abreu")
        XCTAssertFalse(result)
    }
    
    func testExample2() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreu")
        XCTAssertFalse(result)
    }
    
    func testExample3() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreumx")
        XCTAssertFalse(result)
    }
    
    func testExample4() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus abreu.com")
        XCTAssertFalse(result)
    }
    
    func testExample5() throws {
        let VC = LoginiViewController()
        let result = VC.isValidEmail("agus@abreu.com")
        XCTAssertTrue(result)
    }
}
