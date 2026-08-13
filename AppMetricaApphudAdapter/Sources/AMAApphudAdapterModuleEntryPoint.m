
#import "AMAApphudAdapterModuleEntryPoint.h"
#import <AppMetricaCoreExtension/AppMetricaCoreExtension.h>
@import AppMetricaApphudObjCWrapper;

@implementation AMAApphudAdapterModuleEntryPoint

- (void)registerComponentsWithRegistrar:(id<AMAModuleRegistrar>)registrar
{
    [registrar registerServiceConfiguration:[AMAApphudManager shared].serviceConfiguration];
    [registrar registerActivationDelegate:[AMAApphudManager class]];
}

- (NSString *)moduleName
{
    return @"AppMetricaApphudAdapter";
}

@end
