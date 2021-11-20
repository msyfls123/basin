#ifndef NAPI_EXPERIMENTAL
// Haven't know how to set it properly.
#define NAPI_EXPERIMENTAL 9999
#endif

#include <node_api.h>
#include <iostream>
#include "common/defer.cpp"


napi_value Init(napi_env env, napi_value exports){
  napi_value name;
  napi_create_string_utf8(env, "Defer", NAPI_AUTO_LENGTH, &name);
  napi_value es_ctor = Defer::define_es_class(env);
  napi_set_property(env, exports, name, es_ctor);
  return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
