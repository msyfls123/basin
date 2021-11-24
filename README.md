# basin
Node.js addons

## Building Steps

### Setup

You should install [`Conan`](https://docs.conan.io/en/latest/installation.html#install) first, which manage our third-party C++ dependencies.

### Install Conan dependencies

Install Conan GYP generator.
```sh
git clone https://github.com/czoido/conan-gyp-generator
cd conan-gyp-generator
conan config install gyp-generator.py -tf generators
```

Generate build info.
```sh
mkdir conan_build && cd conan_build
conan install .. && cd ..
```

### Install node modules, configure and build

```sh
npm i
npm run configure
npm run build:dev
```

### Run

Run Electron App with addons: `npm run ele`

## Thanks

- Friend Link: https://iweiyun.github.io/2019/01/04/node-cpp-addon/
- Create App: https://stackoverflow.com/a/15958586
- Framework Setting: https://github.com/nodejs/node-gyp/issues/682
- Cast NSView: https://github.com/yue/yue/blob/0c4999b5675febe1accbedbaace9d881639c4453/node_yue/chrome_view_mac.mm
- Add Subview: https://stackoverflow.com/questions/12363564/how-to-add-an-nsview-to-nswindow-in-a-cocoa-app
- NSButton setAction with Block: https://gist.github.com/alexdrone/2634534
- Call JS From Obj-C++ thread - https://github.com/kewlbear/NodeBridge
- Call JS From C++ thread - https://github.com/huarunlin/node-ate-tbox
- Conan gyp generator - https://czoido.github.io/posts/node-native-module-conan/
- Configure rpath - https://github.com/nodejs/node-gyp/issues/1397#issuecomment-375960087
- Use C++17, target macOS 10.15 - https://github.com/nodejs/node-gyp/issues/1662#issuecomment-720021022
