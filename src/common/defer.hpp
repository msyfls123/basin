#include <string>

class Defer {
  public:
    Defer(const std::string &str);
    void run(int milliseconds, std::function<void(std::string str)> complete);
  private:
    const std::string &_str;
};
