
import XCTest
@testable import AppMetricaApphudObjCWrapper

final class ApphudStartupConfigurationTests: XCTestCase {
    
    var mockStorage: StringKeyValueStorageMock!
    var configuration: ApphudStartupConfiguration!
    
    private let apiKey = "test_api_key"
    
    override func setUp() {
        super.setUp()
        mockStorage = StringKeyValueStorageMock()
        configuration = ApphudStartupConfiguration(storage: mockStorage)
    }
    
    override func tearDown() {
        mockStorage = nil
        configuration = nil
        super.tearDown()
    }
    
    func testApphudAPIKeySettingValue() {
        configuration.apphudAPIKey = apiKey
        var retrievedApiKey = try? mockStorage.string(forKey: ApphudStartupConfiguration.apphudStorageKey)
        
        XCTAssertEqual(retrievedApiKey, apiKey, "API key should be correctly saved in the storage.")
        
        configuration.apphudAPIKey = nil
        retrievedApiKey = try? mockStorage.string(forKey: ApphudStartupConfiguration.apphudStorageKey)
        XCTAssertNil(retrievedApiKey, "API key should be nil in the storage after setting it to nil.")
    }
    
    func testApphudAPIKeyGettingValue() {
        try? mockStorage.save(apiKey, forKey: ApphudStartupConfiguration.apphudStorageKey)
        
        let retrievedApiKey = configuration.apphudAPIKey
        
        XCTAssertEqual(retrievedApiKey, apiKey, "API key should be correctly retrieved from the storage.")
    }
    
    func testApphudEnabledSettingValue() {
        configuration.apphudEnabled = NSNumber(booleanLiteral: true)
        var retrievedEnabled = try? mockStorage.boolNumber(forKey: ApphudStartupConfiguration.apphudEnabledKey).boolValue
        
        XCTAssertTrue(retrievedEnabled!, "Feature should be correctly saved in the storage.")
        
        configuration.apphudEnabled = nil
        retrievedEnabled = try? mockStorage.boolNumber(forKey: ApphudStartupConfiguration.apphudEnabledKey).boolValue
        XCTAssertNil(retrievedEnabled, "Feature should be nil in the storage after setting it to nil.")
    }
    
    func testApphudEnabledKeyGettingValue() {
        try? mockStorage.saveBoolNumber(NSNumber(booleanLiteral: true), forKey: ApphudStartupConfiguration.apphudEnabledKey)
        
        let retrievedEnabled = configuration.apphudEnabled?.boolValue
        
        XCTAssertTrue(retrievedEnabled!, "Feature should be correctly retrieved from the storage.")
    }
    
    func testReturnsCorrectKeys() {
        XCTAssertEqual(ApphudStartupConfiguration.allKeys,
                       [ApphudStartupConfiguration.apphudStorageKey, ApphudStartupConfiguration.apphudEnabledKey],
                       "All keys should return the correct storage keys.")
    }
}
