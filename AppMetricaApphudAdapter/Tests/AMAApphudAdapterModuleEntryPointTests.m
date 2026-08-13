
#import <Kiwi/Kiwi.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCoreExtension/AppMetricaCoreExtension.h>
#import "AMAApphudAdapterModuleEntryPoint.h"
@import AppMetricaApphudObjCWrapper;

@interface AMAApphudRegistrarMock : NSObject <AMAModuleRegistrar>

@property (nonatomic, strong) NSMutableArray<Class> *activationDelegates;
@property (nonatomic, strong) NSMutableArray<AMAServiceConfiguration *> *serviceConfigurations;

@end

@implementation AMAApphudRegistrarMock

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _activationDelegates = [NSMutableArray array];
        _serviceConfigurations = [NSMutableArray array];
    }
    return self;
}

- (void)registerPreActivationHandler:(id<AMAModulePreActivationHandler>)handler {}
- (void)registerEventPollingDelegate:(Class<AMAEventPollingDelegate>)delegate {}
- (void)registerEventFlushableDelegate:(Class<AMAEventFlushableDelegate>)delegate {}
- (void)registerAdProvider:(id<AMAAdProviding>)provider {}

- (void)registerActivationDelegate:(Class<AMAModuleActivationDelegate>)delegate
{
    [self.activationDelegates addObject:delegate];
}

- (void)registerServiceConfiguration:(AMAServiceConfiguration *)configuration
{
    [self.serviceConfigurations addObject:configuration];
}

@end

SPEC_BEGIN(AMAApphudAdapterModuleEntryPointTests)

describe(@"AMAApphudAdapterModuleEntryPoint", ^{

    AMAApphudAdapterModuleEntryPoint *__block entryPoint = nil;
    AMAApphudRegistrarMock *__block registrar = nil;

    beforeEach(^{
        entryPoint = [[AMAApphudAdapterModuleEntryPoint alloc] init];
        registrar = [[AMAApphudRegistrarMock alloc] init];
    });

    it(@"Should have module name", ^{
        [[entryPoint.moduleName should] equal:@"AppMetricaApphudAdapter"];
    });

    it(@"Should register activation delegate", ^{
        [entryPoint registerComponentsWithRegistrar:registrar];

        [[registrar.activationDelegates should] contain:[AMAApphudManager class]];
    });

    it(@"Should register service configuration", ^{
        AMAServiceConfiguration *configurationMock = [AMAServiceConfiguration nullMock];
        [[AMAApphudManager shared] stub:@selector(serviceConfiguration) andReturn:configurationMock];

        [entryPoint registerComponentsWithRegistrar:registrar];

        [[registrar.serviceConfigurations should] contain:configurationMock];
    });
});

SPEC_END
