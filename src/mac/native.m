#include <node_api.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#import <Foundation/Foundation.h>

#define var     __auto_type

extern int ASMSub(int a, int b);

static napi_value MyStringMethod(napi_env env, napi_callback_info info) 
{
    napi_value world;
    var str = @"Hello, world!".UTF8String;
    var str_len = strlen(str);
    printf("The length is: %zu\n", str_len);

    napi_create_string_utf8(env, str, str_len, &world);
    
    return world;
}

static napi_value MyIntMethod(napi_env env, napi_callback_info info) 
{
    @autoreleasepool {
        size_t nArgs = 32;
        napi_value inputArgs[32];
        napi_value thisObj;
        
        napi_get_cb_info(env, info, &nArgs, inputArgs, &thisObj, NULL);

        napi_value result;
        
        int32_t argValue = 0;
        napi_get_value_int32(env, inputArgs[0], &argValue);
        
        var array = @[@"abc", @"def", @"xyz"];
        
        napi_create_int32(env, argValue + array.count, &result);
      
        return result;
    }
}

static napi_value CallbackMethod(napi_env env, napi_callback_info info)
{
    @autoreleasepool {
        size_t nArgs = 32;
        napi_value inputArgs[32];
        napi_value thisObj;

        // 拿到 callback 函数 
        napi_get_cb_info(env, info, &nArgs, inputArgs, &thisObj, NULL);
        napi_value cb = inputArgs[0];

        napi_status status;
        napi_value item;

        const char *cString = [@"hello" cStringUsingEncoding:NSASCIIStringEncoding];
        status = napi_create_string_utf8(env, cString, NAPI_AUTO_LENGTH, &item);
        // 创建回调参数的数组
        napi_value args[1] = { item };
        
        status = napi_call_function(env, thisObj, cb, 1, args, NULL);

        napi_value result;
        napi_create_int32(env, 0, &result);
        return result;
    }
}


napi_value Init(napi_env env, napi_value exports) 
{
    napi_property_descriptor stringDesc = { "stringMethod", 0, MyStringMethod, 0, 0, 0, napi_default, 0 };
    napi_property_descriptor intDesc = { "intMethod", 0, MyIntMethod, 0, 0, 0, napi_default, 0 };
    napi_property_descriptor callbackDesc = { "callback", 0, CallbackMethod, 0, 0, 0, napi_default, 0 };
    napi_define_properties(env, exports, 3, (napi_property_descriptor[]){stringDesc, intDesc, callbackDesc});
    
    return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
