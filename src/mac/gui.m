// https://stackoverflow.com/a/15958586
#include <node_api.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface MyAppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
}
@end

@implementation MyAppDelegate

-(id) init
{
    self = [super init];
    if (self)
    {
        // total *main* screen frame size //
        NSRect mainDisplayRect = [[NSScreen mainScreen] frame];

        // calculate the window rect to be half the display and be centered //
        NSRect windowRect = NSMakeRect(mainDisplayRect.origin.x + (mainDisplayRect.size.width) * 0.25,
                                     mainDisplayRect.origin.y + (mainDisplayRect.size.height) * 0.25,
                                     mainDisplayRect.size.width * 0.5,
                                     mainDisplayRect.size.height * 0.5);

        /*
         Pick your window style:
         NSBorderlessWindowMask
         NSTitledWindowMask
         NSClosableWindowMask
         NSMiniaturizableWindowMask
         NSResizableWindowMask
         */
        NSUInteger windowStyle = NSTitledWindowMask | NSMiniaturizableWindowMask;

        // set the window level to be on top of everything else //
        NSInteger windowLevel = NSMainMenuWindowLevel + 1;

        // initialize the window and its properties // just examples of properties that can be changed //
        window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:windowStyle backing:NSBackingStoreBuffered defer:NO];
        [window setLevel:windowLevel];
        [window setOpaque:YES];
        [window setHasShadow:YES];
        [window setPreferredBackingLocation:NSWindowBackingLocationVideoMemory];
        [window setHidesOnDeactivate:NO];
        [window setBackgroundColor:[NSColor greenColor]];
    }
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    // make the window visible when the app is about to finish launching //
    [window makeKeyAndOrderFront:self];
    /* do layout and cool stuff here */
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    /* initialize your code stuff here */
}

- (void)dealloc
{
    // release your window and other stuff //
    [window release];
    [super dealloc];
}

@end


static napi_value MyGUIMethod(napi_env env, napi_callback_info info) 
{

    @autoreleasepool
    {
        NSApplication *app = [NSApplication sharedApplication];
        [app setDelegate:[[[MyAppDelegate alloc] init] autorelease]];
        [app run];
    }
}

napi_value Init(napi_env env, napi_value exports) 
{
    napi_property_descriptor guiDesc = { "gui", 0, MyGUIMethod, 0, 0, 0, napi_default, 0 };
    napi_define_properties(env, exports, 1, (napi_property_descriptor[]){guiDesc});
    
    return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
