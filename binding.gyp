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
          }
        ]
      }]
    ]
}
