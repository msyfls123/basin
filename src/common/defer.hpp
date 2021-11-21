#include <string>
#include <node_api.h>

class Defer {
  public:
    Defer(char *str);
    void run(int milliseconds, std::function<void(char *str)> complete);
    static void Destructor(napi_env env, void* instance_ptr, void* /*finalize_hint*/);
    static napi_value define_es_class(napi_env env);
    static napi_value es_constructor(napi_env env, napi_callback_info info);
    static napi_value es_run(napi_env env, napi_callback_info info);
    static void thread_resolve_run_promise(napi_env env, napi_value js_cb, void* context, void* data);
    napi_ref _ref;
  private:
    char *_str;
};
