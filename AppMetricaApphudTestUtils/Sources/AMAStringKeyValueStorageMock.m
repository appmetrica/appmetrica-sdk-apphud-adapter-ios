#import "AMAStringKeyValueStorageMock.h"

static NSString *const kAMAStorageErrorDomain = @"AMAStringKeyValueStorageMockErrorDomain";
static NSInteger const kAMAStorageErrorCodeValueNotFound = 1;

@interface AMAStringKeyValueStorageMock ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *storage;

@end

@implementation AMAStringKeyValueStorageMock

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _storage = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Private

- (NSError *)valueNotFoundErrorForKey:(NSString *)key
{
    NSString *errorMsg = [NSString stringWithFormat:@"Value not found for key: %@", key];
    return [NSError errorWithDomain:kAMAStorageErrorDomain
                               code:kAMAStorageErrorCodeValueNotFound
                           userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
}

#pragma mark - AMAKeyValueStoring

- (NSString *)stringForKey:(NSString *)key error:(NSError **)error
{
    id value = [self.storage objectForKey:key];
    if (value != nil && [value isKindOfClass:NSString.class]) {
        return value;
    }
    else {
        if (error != NULL) {
            *error = [self valueNotFoundErrorForKey:key];
        }
        return nil;
    }
}

- (BOOL)saveString:(NSString *)string forKey:(NSString *)key error:(NSError **)error
{
    if (string == nil) {
        [self.storage removeObjectForKey:key];
    }
    else {
        [self.storage setObject:string forKey:key];
    }
    return YES;
}

- (NSNumber *)boolNumberForKey:(NSString *)key error:(NSError **)error
{
    id value = [self.storage objectForKey:key];
    if (value != nil && [value isKindOfClass:NSNumber.class]) {
        return value;
    }
    else {
        if (error != NULL) {
            *error = [self valueNotFoundErrorForKey:key];
        }
        return nil;
    }
}

- (BOOL)saveBoolNumber:(NSNumber *)value forKey:(NSString *)key error:(NSError **)error
{
    if (value == nil) {
        [self.storage removeObjectForKey:key];
    }
    else {
        [self.storage setObject:value forKey:key];
    }
    return YES;
}

- (NSNumber *)longLongNumberForKey:(NSString *)key error:(NSError **)error
{
    return [[NSNumber alloc] init];
}

- (BOOL)saveLongLongNumber:(NSNumber *)value forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSNumber *)unsignedLongLongNumberForKey:(NSString *)key error:(NSError **)error
{
    return [[NSNumber alloc] init];
}

- (BOOL)saveUnsignedLongLongNumber:(NSNumber *)value forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSNumber *)doubleNumberForKey:(NSString *)key error:(NSError **)error
{
    return [[NSNumber alloc] init];
}

- (BOOL)saveDoubleNumber:(NSNumber *)value forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSDictionary *)jsonDictionaryForKey:(NSString *)key error:(NSError **)error
{
    return @{};
}

- (BOOL)saveJSONDictionary:(NSDictionary *)value forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSArray *)jsonArrayForKey:(NSString *)key error:(NSError **)error
{
    return @[];
}

- (BOOL)saveJSONArray:(NSArray *)value forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSData *)dataForKey:(NSString *)key error:(NSError **)error
{
    return [[NSData alloc] init];
}

- (BOOL)saveData:(NSData *)data forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (NSDate *)dateForKey:(NSString *)key error:(NSError **)error
{
    return [[NSDate alloc] init];
}

- (BOOL)saveDate:(NSDate *)date forKey:(NSString *)key error:(NSError **)error
{
    return YES;
}

- (BOOL)removeValueForKey:(nonnull NSString *)key error:(NSError *__autoreleasing  _Nullable * _Nullable)error { 
    [self.storage removeObjectForKey:key];
    return YES;
}


@end
