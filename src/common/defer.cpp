#include <thread>
#include <chrono>
#include <ctime> 

#include "defer.hpp"

static void thread_run(int milliseconds, std::string str, std::function<void(std::string)> complete) {
  std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
  complete(str);
}

Defer::Defer(const std::string &str): _str(str) {
}

void Defer::run(int milliseconds, std::function<void(std::string)> complete) {
  std::thread runner(thread_run, milliseconds, _str, complete);
  runner.detach();
}
