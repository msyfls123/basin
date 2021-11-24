#include <node.h>
namespace demo {

using v8::Isolate;
using v8::Object;
using v8::Context;
using v8::Local;
using v8::String;
using v8::NewStringType;
using v8::Value;
using v8::HandleScope;
using v8::FunctionCallbackInfo;
using v8::FunctionTemplate;
using v8::Function;

// https://github.com/qt/qtwebengine-chromium/blob/b45f07bfbe74c333f1017810c2409e1aa6077a1b/chromium/third_party/WebKit/Source/bindings/v8/V8Binding.h#L615-L619
inline Local<String> v8AtomicString(Isolate* isolate, const char* str)
  {
      NewStringType type = NewStringType::kInternalized;
      return String::NewFromUtf8(isolate, str, type, strlen(str)).ToLocalChecked();
  }

void Method(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  args.GetReturnValue().Set(String::NewFromUtf8(isolate, "this is").ToLocalChecked());
}

void Init(Local<Object> exports) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Context> context = isolate->GetCurrentContext();
  Local<FunctionTemplate> t = FunctionTemplate::New(isolate, Method);
  NODE_SET_PROTOTYPE_METHOD(t, "hhh", Method);
  Local<Function> fn = t->GetFunction(context).ToLocalChecked();
  Local<String> name = String::NewFromUtf8(isolate, "func").ToLocalChecked();
  fn->SetName(name);
  fn->DefineOwnProperty(context, v8AtomicString(isolate, "test"), String::NewFromUtf8(isolate, "abc").ToLocalChecked()).Check();
  fn->CreateDataProperty(context, 0, String::NewFromUtf8(isolate, "func").ToLocalChecked()).Check();
  exports->Set(context, name, fn).Check();
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Init)

}  // namespace demo
