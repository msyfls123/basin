#import "log_status.h"

void log_status(napi_status status, napi_env env)
{
  if (status != napi_ok) {
    const napi_extended_error_info *error_info = NULL;
    napi_get_last_error_info((env), &error_info);
    bool is_pending;
    napi_is_exception_pending((env), &is_pending);
    if (!is_pending) {
      const char *message = (error_info->error_message == NULL)
                                ? "empty error message"
                                : error_info->error_message;
      NSLog(@"LOG_STATUS: %@", [NSString stringWithUTF8String:message]);
    }
  }
}
