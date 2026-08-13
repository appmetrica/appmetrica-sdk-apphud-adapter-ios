
#import <Foundation/Foundation.h>
#import <AppMetricaCoreExtension/AMAModuleEntryPoint.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMAApphudAdapterModuleEntryPoint : NSObject <AMAModuleEntryPoint>

@property (nonatomic, copy, readonly) NSString *moduleName;

@end

NS_ASSUME_NONNULL_END
