{
  "targets": [
    {
      "target_name": "basin",
      "sources": ["src/main.cc"],
      "include_dirs": [
        "<!(node -e \"require('nan')\")"
      ]
    }
  ],
}
