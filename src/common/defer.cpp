#include <chrono>
#include <ctime>
#include <iostream>
#include <thread>

#include "defer.hpp"
#include "utils.cpp"

static void thread_run(int milliseconds, char *str,
                       std::function<void(char *)> complete)
{
  std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
  complete(str);
}

/** instance constructor and property **/
Defer::Defer(char *str) : _str(str) {}

void Defer::run(int milliseconds, std::function<void(char *)> complete)
{
  std::thread runner(thread_run, milliseconds, _str, complete);
  runner.detach();
}

void Defer::Destructor(napi_env env, void *instance_ptr,
                       void * /*finalize_hint*/)
{
  reinterpret_cast<Defer *>(instance_ptr)->~Defer();
}

/** static property **/
napi_value Defer::es_run(napi_env env, napi_callback_info info)
{
  napi_status status;
  size_t arg_count = 1;
  napi_value args[1];
  napi_value es_this;
  napi_get_cb_info(env, info, &arg_count, args, &es_this, nullptr);
  int milliseconds;
  napi_get_value_int32(env, args[0], &milliseconds);

  Defer *defer = nullptr;
  status = napi_unwrap(env, es_this, reinterpret_cast<void **>(&defer));
  std::function<void(char *)> complete =
      [](char *str) {
        // TODO: implementation of Promise.
        std::cout << str << std::endl;
      };
  defer->run(milliseconds, complete);
  return args[0];
}

napi_value Defer::es_constructor(napi_env env, napi_callback_info info)
{
  napi_status status;
  size_t arg_count = 1;
  napi_value args[1];
  napi_value es_this;
  status = napi_get_cb_info(env, info, &arg_count, args, &es_this, nullptr);

  char *name = get_string(env, args[0]);

  Defer *instance = new Defer(name);

  napi_value property_value;
  napi_create_string_utf8(env, "property_value", NAPI_AUTO_LENGTH,
                          &property_value);
  napi_property_descriptor strDesc = {
      "property_key", 0, 0, 0, 0, property_value, napi_enumerable, 0};
  napi_define_properties(env, es_this, 1,
                         (napi_property_descriptor[]){strDesc});
  status = napi_wrap(env, es_this, reinterpret_cast<void*>(instance), Defer::Destructor, nullptr,
            &instance->_ref);
  return es_this;
}

napi_value Defer::define_es_class(napi_env env)
{
  napi_status status;
  napi_value static_value;
  napi_create_string_utf8(env, "static_value", NAPI_AUTO_LENGTH, &static_value);
  napi_property_descriptor desc = {"static_key", 0,           0, 0, 0,
                                   static_value, napi_static, 0};
  napi_property_descriptor runDesc = {"run", 0, Defer::es_run,           0,
                                      0,     0, napi_default_jsproperty, 0};
  napi_value es_ctor;
  napi_define_class(env, "Deferrered", NAPI_AUTO_LENGTH, es_constructor,
                    nullptr, 2, (napi_property_descriptor[]){desc, runDesc},
                    &es_ctor);
  return es_ctor;
}
