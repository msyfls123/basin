#include <string>
#include <node_api.h>

class Defer {
  public:
    Defer(const std::string &str);
    void run(int milliseconds, std::function<void(std::string str)> complete);
    static napi_value define_es_class(napi_env env);
    napi_ref _ref;
  private:
    const std::string &_str;
};
