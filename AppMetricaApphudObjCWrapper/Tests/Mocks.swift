
import XCTest
import AppMetricaStorageUtils
import AppMetricaCoreExtension
@testable import AppMetricaApphudObjCWrapper

final class ApphudStartupObservingDelegateMock: ApphudStartupObservingDelegate {
    var expectation: XCTestExpectation?
    
    func startupUpdated() {
        expectation?.fulfill()
    }
}

final class StartupStorageProviderMock: NSObject, StartupStorageProviding, CachingStorageProviding {
    var storage: KeyValueStoring
    var saveExpectation: XCTestExpectation?
    
    init(storage: KeyValueStoring) {
        self.storage = storage
    }
    
    func startupStorage(forKeys keys: [String]) -> KeyValueStoring {
        return storage
    }
    
    func saveStorage(_ storage: KeyValueStoring) {
        self.storage = storage
        saveExpectation?.fulfill()
    }
    
    func cachingStorage() -> any KeyValueStoring { return storage }
}

final class ApphudInitializerMock: ApphudInitializing {
    var expectation: XCTestExpectation?
    var apiKey: String = ""
    var userID: String?
    var deviceID: String?
    var observerMode: Bool = false
    
    func activateApphud(apiKey: String, userID: String?, deviceID: String?, observerMode: Bool) {
        expectation?.fulfill()
        self.apiKey = apiKey
        self.userID = userID
        self.deviceID = deviceID
        self.observerMode = observerMode
    }
}
