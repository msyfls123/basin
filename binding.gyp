{
  "variables": {
    "gui": 0,
  },
  "targets": [
    # {
    #   "target_name": "legacy",
    #   "sources": ["src/legacy.cpp"],
    #   "include_dirs": [
    #     "<!(node -e \"require('nan')\")"
    #   ]
    # },
    {
      "target_name": "basin",
      "sources": ["src/lib.cpp"],
      "cflags": [ "-fno-exceptions" ],
      "cflags_cc": [ "-fno-exceptions", "-std=c++17" ],
      "conditions": [
        ['OS=="win"', {
          "msvs_settings": {
            "VCCLCompilerTool": {
              "AdditionalOptions": [ "-std:c++17" ],
            },
          },
        }]
      ],
    },
  ],
  "conditions": [
      ['OS == "mac" and gui == 1', {
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
              "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
              # "CLANG_CXX_LIBRARY": "libc++",
              # "CLANG_CXX_LANGUAGE_STANDARD":"c++17",
              'MACOSX_DEPLOYMENT_TARGET': '10.15',
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
