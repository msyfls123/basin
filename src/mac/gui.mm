// https://stackoverflow.com/a/15958586
#include <node_api.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

/* ========= create native app start ========== */

static napi_value MyGUIMethod(napi_env env, napi_callback_info info) 
{

        // get electron view

        size_t nArgs = 32;
        napi_value inputArgs[32];
        napi_value thisObj;
        
        napi_get_cb_info(env, info, &nArgs, inputArgs, &thisObj, NULL);

        void *pointer;
        size_t length;
        napi_status status = napi_get_buffer_info(env, inputArgs[0], &pointer, &length);

        NSView *handleView = *reinterpret_cast<NSView**>(pointer);

        // create native window

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
        NSUInteger windowStyle = NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask | NSResizableWindowMask;

        NSInteger windowLevel = NSMainMenuWindowLevel + 1;

        NSWindow* window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:windowStyle backing:NSBackingStoreBuffered defer:NO];
        [window setLevel:windowLevel];
        [window setHasShadow:YES];
        [window setPreferredBackingLocation:NSWindowBackingLocationVideoMemory];
        [window setHidesOnDeactivate:YES];
        [window setBackgroundColor:[NSColor greenColor]];

        // set content and show window
        NSRect viewRect = NSMakeRect(300,
                                     0,
                                     mainDisplayRect.size.width * 0.5 - 300,
                                     mainDisplayRect.size.height * 0.5);
        NSView *content = [[NSView alloc] initWithFrame:viewRect];
        // [content setOpaque: NO];
        [content setBackgroundColor:[NSColor greenColor]];

        NSString *btnText = @"戳我";
        NSRect rect = NSMakeRect(100, 100, 60, 30);
        NSButton *button = [[NSButton alloc] initWithFrame:rect];
        button.title = btnText;
        [button setButtonType:NSButtonTypePushOnPushOff];
        [content addSubview:button];

        handleView.autoresizingMask = 0;
        [handleView setWantsLayer:YES];
        [window setContentView:handleView];
        [handleView addSubview:content];

        [NSApp activateIgnoringOtherApps:YES];
        [window makeKeyAndOrderFront:nil];

        NSString *success = @"success";
        const char *cStringSuck = [success cStringUsingEncoding:NSASCIIStringEncoding];
        napi_value resultSuck;
        napi_create_string_utf8(env, cStringSuck, NAPI_AUTO_LENGTH, &resultSuck);
        return resultSuck;
}

/* ========= create native app end ========== */


static napi_value GetSize(napi_env env, napi_callback_info info) 
{
    @autoreleasepool
    {
        size_t nArgs = 32;
        napi_value inputArgs[32];
        napi_value thisObj;
        
        napi_get_cb_info(env, info, &nArgs, inputArgs, &thisObj, NULL);

        void *pointer;
        size_t length;
        napi_status status = napi_get_buffer_info(env, inputArgs[0], &pointer, &length);

        // if (status != napi_ok) {
        //     NSString *failed = @"failed";
        //     const char *cStringFailed = [failed cStringUsingEncoding:NSASCIIStringEncoding];
        //     napi_value resultFailed;
        //     napi_create_string_utf8(env, cStringFailed, NAPI_AUTO_LENGTH, &result2);
        //     return resultFailed;
        // }

        void **handle = reinterpret_cast<void **>(pointer);
        NSView *handleView = (__bridge NSView *)(*handle);
        NSString *size = NSStringFromSize(handleView.frame.size);

        const char *cString = [size cStringUsingEncoding:NSASCIIStringEncoding];
        napi_value result;
        napi_create_string_utf8(env, cString, NAPI_AUTO_LENGTH, &result);
        return result;
    }
}

napi_value Init(napi_env env, napi_value exports) 
{
    napi_property_descriptor guiDesc = { "getSize", 0, GetSize, 0, 0, 0, napi_default, 0 };
    napi_property_descriptor createNativeDesc = { "createNative", 0, MyGUIMethod, 0, 0, 0, napi_default, 0 };
    napi_define_properties(env, exports, 2, (napi_property_descriptor[]){guiDesc, createNativeDesc});
    
    return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
