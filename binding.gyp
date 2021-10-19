{
  "targets": [
    {
      "target_name": "basin",
      "sources": ["src/addon.cc"],
      "include_dirs": [
        "<!(node -e \"require('nan')\")"
      ]
    }
  ],
}
