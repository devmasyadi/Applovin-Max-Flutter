#import "ApplovinMaxPlugin.h"
#if __has_include(<applovin_max/applovin_max-Swift.h>)
#import <applovin_max/applovin_max-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "applovin_max-Swift.h"
#endif

@implementation ApplovinMaxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApplovinMaxPlugin registerWithRegistrar:registrar];
}
@end
