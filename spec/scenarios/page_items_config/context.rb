# frozen_string_literal: true

CONTEXT_PAGE_ITEMS_CONFIG = "when different per_page, page_num_label, "\
                            "individual_page_pagination and sort options configured"

RSpec.shared_context CONTEXT_PAGE_ITEMS_CONFIG do
  let(:scenario) { "page_items_config" }
  let(:overrides) do
    {
      "coffeebrew_jekyll_paginate" => {
        "defaults" => {
          "per_page" => 3,
          "sort_field" => "title",
          "sort_reverse" => false,
          "page_num_label" => "Page %{page_num_one_index}"
        },
        "collections" => {
          "posts" => {
            "individual_page_pagination" => true
          }
        }
      }
    }
  end
  let(:expected_files) do
    [
      # Books pagination pages
      dest_dir("books", "1", "index.html"),
      dest_dir("books", "2", "index.html"),
      dest_dir("books", "3", "index.html"),

      # Books content pages
      dest_dir("books", "1997-06-26-harry-potter-1.html"),
      dest_dir("books", "1998-07-02-harry-potter-2.html"),
      dest_dir("books", "1999-07-08-harry-potter-3.html"),
      dest_dir("books", "2000-07-08-harry-potter-4.html"),
      dest_dir("books", "2003-06-21-harry-potter-5.html"),
      dest_dir("books", "2005-07-16-harry-potter-6.html"),
      dest_dir("books", "2007-07-21-harry-potter-7.html"),

      # Posts pagination pages
      dest_dir("posts", "1", "index.html"),
      dest_dir("posts", "2", "index.html"),
      dest_dir("posts", "3", "index.html"),

      # Posts content pages
      dest_dir("posts", "2021-03-12-test-post-1.html"),
      dest_dir("posts", "2021-03-28-test-post-2.html"),
      dest_dir("posts", "2021-05-03-test-post-3.html"),
      dest_dir("posts", "2021-05-03-test-post-4.html"),
      dest_dir("posts", "2022-01-27-test-post-5.html"),
      dest_dir("posts", "2022-03-12-test-post-6.html"),
      dest_dir("posts", "2022-11-23-test-post-7.html"),
      dest_dir("posts", "2023-02-21-test-post-8.html"),
    ]
  end
end
