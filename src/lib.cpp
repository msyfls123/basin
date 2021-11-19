#include <node_api.h>
#include <iostream>
#include "common/defer.cpp"

napi_ref ctor_ref;

napi_value Init(napi_env env, napi_value exports){
  std::string str = "test";
  Defer *d = new Defer(str);

  std::function<void(const std::string &)> complete = [](const std::string &str) {
    std::cout << str << std::endl;
  };

  d->run(3000, complete);
  d->run(7000, complete);

  napi_value name;
  napi_create_string_utf8(env, "Defer", NAPI_AUTO_LENGTH, &name);
  napi_value es_ctor = Defer::define_es_class(env);
  napi_create_reference(env, es_ctor, 1, &ctor_ref);
  napi_set_property(env, exports, name, es_ctor);
  return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
