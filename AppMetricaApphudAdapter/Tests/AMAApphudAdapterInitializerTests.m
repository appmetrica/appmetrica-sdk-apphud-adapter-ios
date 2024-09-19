
#import <Kiwi/Kiwi.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import "AMAApphudAdapterInitializer.h"
@import AppMetricaApphudObjCWrapper;

SPEC_BEGIN(AMAApphudAdapterInitializerTests)

describe(@"AMAApphudAdapterInitializer", ^{
    
    AMAApphudAdapterInitializer *__block initializer = nil;
    
    beforeEach(^{
        initializer = [[AMAApphudAdapterInitializer alloc] init];
    });
    
    context(@"AMAApphudAdapterInitializer", ^{
        it(@"Should add activation delegate on load", ^{
            [[AMAAppMetrica should] receive:@selector(addActivationDelegate:) withArguments:[AMAApphudManager class]];
            
            [AMAApphudAdapterInitializer load];
        });
        
        it(@"Should register external service configuration on load", ^{
            AMAServiceConfiguration *configurationMock = [AMAServiceConfiguration nullMock];
            [[AMAApphudManager shared] stub:@selector(serviceConfiguration) andReturn:configurationMock];
            [[AMAAppMetrica should] receive:@selector(registerExternalService:) withArguments:configurationMock];
            
            [AMAApphudAdapterInitializer load];
        });
    });
});

SPEC_END
