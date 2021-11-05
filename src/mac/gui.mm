#import "gui.h"
#import "helper/block_invocation.mm"

static void CallJs(napi_env env, napi_value js_cb, void* context, void* data) {
    napi_status status;
    napi_value item;

    // should be the same type after `safe_cb`
    NSString* value = reinterpret_cast<NSString*>(data);

    const char *cString2 = [value cStringUsingEncoding:NSUTF8StringEncoding];
    status = napi_create_string_utf8(env, cString2, NAPI_AUTO_LENGTH, &item);

    if (status != napi_ok) {                                      
        const napi_extended_error_info* error_info = NULL;          
        napi_get_last_error_info((env), &error_info);               
        bool is_pending;                                            
        napi_is_exception_pending((env), &is_pending);              
        if (!is_pending) {                                          
            const char* message = (error_info->error_message == NULL) 
                ? "empty error message"                               
                : error_info->error_message;                          
            NSLog([NSString stringWithUTF8String:message]);                                              \
        }                                                           
    }

    napi_value args[1] = { item };
    napi_value undefined;
    status = napi_get_undefined(env, &undefined);
    
    status = napi_call_function(env, undefined, js_cb, 1, args, NULL);
}


/* ========= create native app start ========== */

static napi_value MyGUIMethod(napi_env env, napi_callback_info info) 
{

        // get electron view

        size_t nArgs = 32;
        napi_value inputArgs[32];
        napi_value thisObj;
        
        napi_get_cb_info(env, info, &nArgs, inputArgs, &thisObj, NULL);

        napi_value cb = inputArgs[1];

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


        napi_value async_resource_name;
        napi_create_string_utf8(env, "ate test callback", NAPI_AUTO_LENGTH, &async_resource_name);
        napi_threadsafe_function safe_cb;
        status = napi_create_threadsafe_function(
            env,
            cb,
            NULL,
            async_resource_name,
            0,
            1,
            NULL,
            NULL,
            NULL,
            CallJs,
            &safe_cb
        );

        BlockInvocation *invocation = [[BlockInvocation alloc] initWithBlock:^(id sender) {
            NSString *btn_title = [(NSButton *)sender title];
            NSLog(@"Button with title %@ was clicked", btn_title);
            napi_call_threadsafe_function(safe_cb, btn_title, napi_tsfn_blocking);
        }];

        [button setTarget:invocation];
        [button setAction:@selector(performWithObject:)];

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
