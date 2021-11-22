#include <iostream>
#include <node_api.h>

static char *get_string(napi_env env, napi_value value)
{
  napi_status status;
  size_t length;
  char *result;
  status = napi_get_value_string_utf8(env, value, NULL, 0, &length);
  if (status != napi_ok) {
    napi_throw_error(env, nullptr, "get_string failed, it's not a string.");
    return NULL;
  }
  result = new char[length + 1];
  napi_get_value_string_utf8(env, value, result, length + 1, &length);
  return result;
}

static void log_status(napi_env env, napi_status status)
{
  if (status != napi_ok) {
    const napi_extended_error_info *error_info = NULL;
    napi_get_last_error_info(env, &error_info);
    bool is_pending;
    napi_is_exception_pending(env, &is_pending);
    if (!is_pending) {
      const char *message = (error_info->error_message == NULL)
                                ? "empty error message"
                                : error_info->error_message;
      napi_value error;
      napi_create_string_utf8(env, message, NAPI_AUTO_LENGTH, &error);
      napi_fatal_exception(env, error);
    }
  }
}
