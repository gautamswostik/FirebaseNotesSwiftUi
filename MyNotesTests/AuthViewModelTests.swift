import XCTest
@testable import MyNotes

class AuthViewModelTests: XCTestCase {
    
    var viewModel: AuthViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoginWithValidCredentials() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        
        // When
        viewModel.login(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.loginLoading)
        // Check the authentication result here (mock Firebase response)
        // XCTAssert(viewModel.loginSuccess)
    }
    
    func testLoginWithEmptyCredentials() {
        // Given
        let email = ""
        let password = ""
        
        // When
        viewModel.login(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.error, "Please fill both fields")
    }
    
    func testLoginWithInvalidCredentials() {
        // Given
        let email = "invalidemail"
        let password = "short"
        
        // When
        viewModel.login(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.error, "Provided details are invalid")
    }
    
    func testRegistrationWithValidCredentials() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        
        // When
        viewModel.register(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.registrationLoading)
        // Check the registration result here (mock Firebase response)
        // XCTAssert(viewModel.registrationSuccess)
    }
    
    func testRegistrationWithEmptyCredentials() {
        // Given
        let email = ""
        let password = ""
        
        // When
        viewModel.register(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.error, "Please fill both fields")
    }
    
    func testRegistrationWithInvalidCredentials() {
        // Given
        let email = "invalidemail"
        let password = "short"
        
        // When
        viewModel.register(email: email, password: password)
        
        // Then
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.error, "Provided details are invalid")
    }
    
    func testLogout() {
        // When
        viewModel.logout()
        
        // Then
        XCTAssertTrue(viewModel.logOutSuccess)
    }
}
