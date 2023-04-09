# frozen_string_literal: true

CONTEXT_INVALID_CONFIG_KEYS = "when using invalid_config_keys"

RSpec.shared_context CONTEXT_INVALID_CONFIG_KEYS do
  let(:scenario) { "invalid_config_keys" }
  let(:generated_files) { [] }
  let(:expected_files) { [] }
  let(:overrides) do
    {
      "coffeebrew_jekyll_paginate" => {
        "invalid" => {},
        "defaults" => {
          "invalid" => {},
          "first_page_as_root" => {
            "invalid" => {}
          }
        },
        "collections" => {
          "invalid" => {},
          "posts" => {
            "first_page_as_root" => {
              "invalid" => {}
            },
            "invalid" => {}
          }
        }
      }
    }
  end

  let(:expected_errors) do
    [
      { key: "coffeebrew_jekyll_paginate", expected: ["collections", "defaults"], got: ["invalid"] },
      { key: "coffeebrew_jekyll_paginate.defaults.invalid", expected: nil, got: {} },
      { key: "coffeebrew_jekyll_paginate.defaults.first_page_as_root.invalid", expected: nil, got: {} },
      { key: "coffeebrew_jekyll_paginate.collections", expected: ["posts", "books"], got: ["invalid"] },
      { key: "coffeebrew_jekyll_paginate.collections.posts.invalid", expected: nil, got: {} },
      { key: "coffeebrew_jekyll_paginate.collections.posts.first_page_as_root.invalid", expected: nil, got: {} }
    ]
  end
end
