#include <chrono>
#include <ctime>
#include <iostream>
#include <thread>

#include "defer.hpp"
#include "utils.cpp"

napi_ref ctor_ref;

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
  status = napi_get_cb_info(env, info, &arg_count, args, &es_this, nullptr);
  int milliseconds;
  status = napi_get_value_int32(env, args[0], &milliseconds);
  log_status(env, status);

  Defer *defer = nullptr;
  status = napi_unwrap(env, es_this, reinterpret_cast<void **>(&defer));

  napi_deferred deferred;
  napi_value promise;
  status = napi_create_promise(env, &deferred, &promise);

  napi_value async_resource_name;
  napi_create_string_utf8(env, "ate test callback", NAPI_AUTO_LENGTH,
                          &async_resource_name);
  napi_threadsafe_function thread_complete;
  status = napi_create_threadsafe_function(
      env, nullptr, nullptr, async_resource_name, 0, 1, nullptr, nullptr,
      deferred, Defer::thread_resolve_run_promise, &thread_complete);

  std::function<void(char *)> complete = [=](char *str) {
    napi_call_threadsafe_function(thread_complete, str, napi_tsfn_blocking);
  };
  defer->run(milliseconds, complete);
  return promise;
}

void Defer::thread_resolve_run_promise(napi_env env, napi_value js_cb,
                                       void *context, void *data)
{
  napi_deferred deferred = reinterpret_cast<napi_deferred>(context);
  char *str = reinterpret_cast<char *>(data);
  napi_value js_str;
  napi_create_string_utf8(env, str, NAPI_AUTO_LENGTH, &js_str);
  napi_resolve_deferred(env, deferred, js_str);
  deferred = nullptr;
};

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
  status = napi_wrap(env, es_this, reinterpret_cast<void *>(instance),
                     Defer::Destructor, nullptr, &instance->_ref);
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
  napi_create_reference(env, es_ctor, 1, &ctor_ref);
  return es_ctor;
}
