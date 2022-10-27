[
  import_deps: [:ecto, :phoenix],
  inputs: [
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "./dev/**/*.{ex,exs}"
  ],
  subdirectories: ["priv/*/migrations"]
]