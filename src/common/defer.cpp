#include <thread>
#include <chrono>
#include <ctime> 

#include "defer.hpp"

static void thread_run(int milliseconds, std::string str, std::function<void(std::string)> complete) {
  std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
  complete(str);
}

static napi_value es_constructor(napi_env env, napi_callback_info info) {

  Defer *instance = new Defer("test");
  napi_value result;
  napi_create_object(env, &result);

  napi_wrap(env, result, instance, nullptr, nullptr, &instance->_ref);

  napi_value property_value;
  napi_create_string_utf8(env, "property_value", NAPI_AUTO_LENGTH, &property_value);
  napi_property_descriptor desc = {
    "property_key",
    0,
    0,
    0,
    0,
    property_value,
    napi_enumerable,
    0
  };
  napi_define_properties(env, result, 1, (napi_property_descriptor[]){desc});
  return result;
}

Defer::Defer(const std::string &str): _str(str) {
}

void Defer::run(int milliseconds, std::function<void(std::string)> complete) {
  std::thread runner(thread_run, milliseconds, _str, complete);
  runner.detach();
}

napi_value Defer::define_es_class(napi_env env) {
  napi_status status;
  napi_value static_value;
  napi_create_string_utf8(env, "static_value", NAPI_AUTO_LENGTH, &static_value);
  napi_property_descriptor desc = {
    "static_key",
    0,
    0,
    0,
    0,
    static_value,
    napi_static,
    0
  };

  napi_value result;
  napi_define_class(
    env,
    "Deferrered",
    NAPI_AUTO_LENGTH,
    es_constructor,
    nullptr,
    1,
    (napi_property_descriptor[]){desc},
    &result
  );
  return result;
}
