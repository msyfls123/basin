#include <node_api.h>
#include <iostream>
#include "common/defer.cpp"

napi_value Init(napi_env env, napi_value exports){
  std::string str = "test";
  Defer *d = new Defer(str);

  std::function<void(const std::string &)> complete = [](const std::string &str) {
    std::cout << str << std::endl;
  };

  d->run(3000, complete);
  d->run(7000, complete);
  return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init)
