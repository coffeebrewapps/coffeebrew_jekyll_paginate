# frozen_string_literal: true

CONTEXT_INVALID_CONFIG_VALUES = "when using invalid_config_values"

RSpec.shared_context CONTEXT_INVALID_CONFIG_VALUES do
  let(:scenario) { "invalid_config_values" }
  let(:generated_files) { [] }
  let(:expected_files) { [] }
  let(:overrides) do
    {
      "coffeebrew_jekyll_paginate" => {
        "defaults" => {
          "first_page_as_root" => {
            "enabled" => "invalid",
            "permalink" => {
              "invalid" => "nested_key"
            },
            "index_page" => {
              "invalid" => "nested_key"
            }
          },
          "permalink" => {
            "invalid" => "nested_key"
          },
          "index_page" => {
            "invalid" => "nested_key"
          },
          "per_page" => {
            "invalid" => "nested_key"
          },
          "sort_field" => {
            "invalid" => "nested_key"
          },
          "sort_reverse" => "invalid",
          "page_num_label" => {
            "invalid" => "nested_key"
          }
        },
        "collections" => {
          "posts" => {
            "first_page_as_root" => {
              "enabled" => "invalid",
              "permalink" => {
                "invalid" => "nested_key"
              },
              "index_page" => {
                "invalid" => "nested_key"
              }
            },
            "permalink" => {
              "invalid" => "nested_key"
            },
            "index_page" => {
              "invalid" => "nested_key"
            },
            "per_page" => {
              "invalid" => "nested_key"
            },
            "sort_field" => {
              "invalid" => "nested_key"
            },
            "sort_reverse" => "invalid",
            "page_num_label" => {
              "invalid" => "nested_key"
            }
          }
        }
      }
    }
  end

  let(:expected_errors) do
    [
      { key: "coffeebrew_jekyll_paginate.defaults.first_page_as_root.enabled", expected: [true, false], got: "invalid" },
      { key: "coffeebrew_jekyll_paginate.defaults.first_page_as_root.permalink", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.first_page_as_root.index_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.permalink", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.index_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.per_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.sort_field", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.defaults.sort_reverse", expected: [true, false], got: "invalid" },
      { key: "coffeebrew_jekyll_paginate.defaults.page_num_label", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.first_page_as_root.enabled", expected: [true, false], got: "invalid" },
      { key: "coffeebrew_jekyll_paginate.collections.posts.first_page_as_root.permalink", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.first_page_as_root.index_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.permalink", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.index_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.per_page", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.sort_field", expected: [], got: { "invalid" => "nested_key" } },
      { key: "coffeebrew_jekyll_paginate.collections.posts.sort_reverse", expected: [true, false], got: "invalid" },
      { key: "coffeebrew_jekyll_paginate.collections.posts.page_num_label", expected: [], got: { "invalid" => "nested_key" } }
    ]
  end
end
