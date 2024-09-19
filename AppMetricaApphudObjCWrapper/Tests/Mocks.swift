
import XCTest
import AppMetricaStorageUtils
import AppMetricaCoreExtension
@testable import AppMetricaApphudObjCWrapper

final class StringKeyValueStorageMock: NSObject, KeyValueStoring {
    
    enum StorageError: Error {
        case valueNotFound
    }

    private var storage: [String: Any] = [:]
    
    func string(forKey key: String) throws -> String {
        if let value = storage[key] as? String {
            return value
        } else {
            throw StorageError.valueNotFound
        }
    }
    
    func save(_ string: String?, forKey key: String) throws {
        storage[key] = string
    }
    
    func saveBoolNumber(_ value: NSNumber!, forKey key: String!) throws {
        storage[key] = value
    }
    
    func boolNumber(forKey key: String!) throws -> NSNumber {
        if let value = storage[key] as? NSNumber {
            return value
        } else {
            throw StorageError.valueNotFound
        }
    }
    
    func saveLongLong(_ value: NSNumber!, forKey key: String!) throws {}
    func saveUnsignedLongLong(_ value: NSNumber!, forKey key: String!) throws {}
    func saveDouble(_ value: NSNumber!, forKey key: String!) throws {}
    func saveJSONDictionary(_ value: [AnyHashable : Any]!, forKey key: String!) throws {}
    func saveJSONArray(_ value: [Any]!, forKey key: String!) throws {}
    func save(_ data: Data!, forKey key: String!) throws {}
    func save(_ date: Date!, forKey key: String!) throws {}
    func data(forKey key: String!) throws -> Data { return Data() }
    func date(forKey key: String!) throws -> Date { return Date() }
    func longLongNumber(forKey key: String!) throws -> NSNumber { return NSNumber() }
    func unsignedLongLongNumber(forKey key: String!) throws -> NSNumber { return NSNumber() }
    func doubleNumber(forKey key: String!) throws -> NSNumber { return NSNumber() }
    func jsonDictionary(forKey key: String!) throws -> [AnyHashable : Any] { return [:] }
    func jsonArray(forKey key: String!) throws -> [Any] { return [] }
}

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
