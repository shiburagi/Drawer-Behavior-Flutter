#import "DrawerbehaviorPlugin.h"
#import <drawerbehavior/drawerbehavior-Swift.h>

@implementation DrawerbehaviorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDrawerbehaviorPlugin registerWithRegistrar:registrar];
}
@end
