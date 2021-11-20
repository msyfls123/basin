#include <node_api.h>

static char* get_string(napi_env env, napi_value value) {
  napi_status status;
  size_t length;
  char *result;
  status = napi_get_value_string_utf8(env, value, NULL, 0, &length);
  if (status != napi_ok) {
    napi_throw_error(env, nullptr,
                     "It's not a string");
    return NULL;
  }
  result = new char[length + 1];
  napi_get_value_string_utf8(env, value, result, length + 1, &length);
  return result;
}
