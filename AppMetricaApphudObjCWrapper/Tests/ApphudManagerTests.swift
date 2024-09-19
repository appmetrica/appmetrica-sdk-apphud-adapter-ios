
import XCTest
import ApphudSDK
@testable import AppMetricaApphudObjCWrapper

final class ApphudManagerTests: XCTestCase {

    var delegateMock: ApphudStartupObservingDelegateMock!
    var startupController: ApphudStartupController!
    var initializerMock: ApphudInitializerMock!
    var startupStorageProviderMock: StartupStorageProviderMock!
    var stringKeyValueStorageMock: StringKeyValueStorageMock!
    var manager: ApphudManager!
    
    private let apiKey = "test_api_key"

    override func setUp() {
        super.setUp()
        startupController = ApphudStartupController()
        stringKeyValueStorageMock = StringKeyValueStorageMock()
        startupStorageProviderMock = StartupStorageProviderMock(storage: stringKeyValueStorageMock)
        
        delegateMock = ApphudStartupObservingDelegateMock()
        startupController.delegate = delegateMock
        initializerMock = ApphudInitializerMock()
        manager = ApphudManager(startupController: startupController, apphudInitializer: initializerMock)
    }

    override func tearDown() {
        startupController = nil
        initializerMock = nil
        delegateMock = nil
        stringKeyValueStorageMock = nil
        startupStorageProviderMock = nil
        super.tearDown()
    }

    func testStartWithApiKey() {
        //Arrange
        let initializeExpectation = XCTestExpectation(description: "Should start Apphud")
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        //Act
        manager.startIfNeeded()
        
        //Assert
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
    }
    
    func testNotStartingWithDisabledFeature() {
        //Arrange
        let initializeExpectation = XCTestExpectation(description: "Should start Apphud")
        initializerMock.expectation = initializeExpectation
        initializeExpectation.isInverted = true
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        try? stringKeyValueStorageMock.saveBoolNumber(0, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        //Act
        manager.startIfNeeded()
        
        //Assert
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
    }
    
    func testNotStartingWithEmptyApiKey() {
        //Arrange
        let initializeExpectation = XCTestExpectation(description: "Should not start Apphud")
        initializeExpectation.isInverted = true
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        try? stringKeyValueStorageMock.save("", forKey: ApphudStartupConfiguration.apphudStorageKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        //Act
        manager.startIfNeeded()
        
        //Assert
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
    }
    
    func testNotStartingWithouthApiKey() {
        //Arrange
        let initializeExpectation = XCTestExpectation(description: "Should not start Apphud")
        initializeExpectation.isInverted = true
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        //Act
        manager.startIfNeeded()
        
        //Assert
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
    }
    
    func testStartAndWaitStartupUpdate() {
        //MARK: Wait for startup update
        var initializeExpectation = XCTestExpectation(description: "Should not start Apphud")
        initializeExpectation.isInverted = true
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        manager.startIfNeeded()
        
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
        
        //MARK: Start after startup update with disabled feature
        initializeExpectation = XCTestExpectation(description: "Should wait and start Apphud after startup update")
        initializeExpectation.isInverted = true
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(0, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        
        manager.startupUpdated()
        
        wait(for: [initializeExpectation], timeout: 1.0)
        
        //MARK: Start after startup update with enabled feature
        initializeExpectation = XCTestExpectation(description: "Should wait and start Apphud after startup update")
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        
        manager.startupUpdated()
        
        wait(for: [initializeExpectation], timeout: 1.0)
    }
    
    func testStartupUpdateWithoutStarting() {
        let initializeExpectation = XCTestExpectation(description: "Should wait for AppMetrica activation before start Apphud")
        initializeExpectation.isInverted = true
        initializerMock.expectation = initializeExpectation
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        manager.startupUpdated()
        
        wait(for: [initializeExpectation], timeout: 1.0)
        XCTAssertNotNil(startupController.startupConfiguration, "Should create startup configuration.")
        XCTAssertTrue(startupController.delegate === manager, "Should correctly set delegate.")
    }
    
    func testServiceConfiguration() {
        let startupController = ApphudStartupController()
        let manager = ApphudManager(startupController: startupController)
        let configuration = manager.serviceConfiguration
        
        XCTAssertTrue(startupController === configuration.startupObserver, "Should send a valid startup controller")
        XCTAssertTrue(startupController === configuration.reporterStorageController, "Should send a valid reporter storage controller")
    }
    
    func testSetApphudImpl() {
        let apiKey = "apphud_impl_api_key"
        let secondaryInitializerMock = ApphudInitializerMock()
        
        let startExpectation = XCTestExpectation(description: "Should set Apphud impl")
        secondaryInitializerMock.expectation = startExpectation
        
        manager.setApphudInitializerImpl(apphudInitializer: secondaryInitializerMock)
        
        try? stringKeyValueStorageMock.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        try? stringKeyValueStorageMock.saveBoolNumber(1, forKey: ApphudStartupConfiguration.apphudEnabledKey)
        startupController.setupStartupProvider(startupStorageProviderMock,
                                               cachingStorageProvider: startupStorageProviderMock)
        
        manager.startIfNeeded()
        
        wait(for: [startExpectation], timeout: 1.0)
        XCTAssertEqual(apiKey, secondaryInitializerMock.apiKey, "Should activate with valid api key")
    }
}
