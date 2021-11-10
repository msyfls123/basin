{
  "targets": [
    {
      "target_name": "basin",
      "sources": ["src/addon.cc"],
      "include_dirs": [
        "<!(node -e \"require('nan')\")"
      ]
    },
  ],
  "conditions": [
      ['OS=="mac"', {
        "targets": [
          {
            "target_name": "mac",
            "sources": ["src/mac/native.m"]
          },
          {
            "target_name": "gui",
            "sources": ["src/mac/gui.mm"],
            "dependencies": ["<(module_root_dir)/conan_build/conanbuildinfo.gyp:nlohmann_json"],
            "xcode_settings": {
              "GCC_ENABLE_CPP_EXCEPTIONS": "YES"
            },
            'libraries': [
              '-framework Foundation',
              '-framework AppKit',
              "-Wl,-rpath,@loader_path/"
            ]
          }
        ]
      }]
    ]
}
