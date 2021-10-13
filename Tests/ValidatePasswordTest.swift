//
//  ValidatePasswordTest.swift
//  Tests
//
//  Created by Agustín Abreu on 09/10/21.
//

import XCTest
@testable import GestionCETAC
class ValidatePasswordTest: XCTestCase {
    
    //Invalid password because there are no lowercase, uppercase and special character
    func testExample1() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("12345")
        XCTAssertFalse(result)
    }
    
    //Invalid password because there are no uppercase, special character and number
    func testExample2() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("password")
        XCTAssertFalse(result)
    }

    //Invalid password because there are no special character and number
    func testExampl3() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("HolaMundo")
        XCTAssertFalse(result)
    }
    
    //Valid password
    func testExample4() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("$PIDEr08")
        XCTAssertTrue(result)
    }
    
    //Valid password
    func testExample5() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("Hello$88")
        XCTAssertTrue(result)
    }
    
    //Valid password
    func testExample6() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("QQQQHello$88QQQQ")
        XCTAssertTrue(result)
    }
    
    //Invalid password because the length is more than 16 characters
    func testExample7() throws {
        let VC = SignupViewController()
        let result = VC.isValidPassword("OQQQQHello$88QQQQO")
        XCTAssertFalse(result)
    }
}
