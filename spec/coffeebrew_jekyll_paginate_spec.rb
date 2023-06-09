# frozen_string_literal: true

require "spec_helper"

require_relative "./scenarios/default/context"
require_relative "./scenarios/first_page_as_root/context"
require_relative "./scenarios/filename_config/context"
require_relative "./scenarios/page_items_config/context"

require_relative "./scenarios/invalid_config_keys/context"
require_relative "./scenarios/invalid_config_values/context"

SUCCESS_EXAMPLE = "generate paginated pages correctly"
FAILURE_EXAMPLE = "raises Jekyll::Errors::InvalidConfigurationError"

RSpec.describe(Coffeebrew::Jekyll::Paginate) do
  let(:overrides) { {} }
  let(:config) do
    Jekyll.configuration(
      Jekyll::Utils.deep_merge_hashes(
        {
          "full_rebuild" => true,
          "source" => source_dir,
          "destination" => dest_dir,
          "show_drafts" => false,
          "url" => "https://coffeebrew-jekyll-paginate.com",
          "name" => "CoffeeBrewApps Jekyll Paginate",
          "author" => {
            "name" => "Coffee Brew Apps"
          },
          "collections" => {}
        },
        overrides
      )
    )
  end

  let(:site) { Jekyll::Site.new(config) }
  let(:generated_files) do
    Dir[
      dest_dir("books", "**", "*.html"),
      dest_dir("posts", "**", "*.html")
    ]
  end

  after do
    FileUtils.rm_r(dest_dir, force: true)
  end

  context "with success examples" do
    shared_examples_for SUCCESS_EXAMPLE do
      it do
        site.process
        expect(generated_files).to match_array(expected_files)
        generated_files.each do |generated_file|
          expected_file = generated_file.gsub(DEST_DIR, File.join(SCENARIO_DIR, scenario, "_site"))
          sanitized_generated = sanitize_html(File.read(generated_file))
          sanitized_expected = sanitize_html(File.read(expected_file))
          expect(sanitized_generated).to eq sanitized_expected
        end
      end
    end

    context CONTEXT_DEFAULT do
      include_context CONTEXT_DEFAULT do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end

    context CONTEXT_FIRST_PAGE_AS_ROOT do
      include_context CONTEXT_FIRST_PAGE_AS_ROOT do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end

    context CONTEXT_FILENAME_CONFIG do
      include_context CONTEXT_FILENAME_CONFIG do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end

    context CONTEXT_PAGE_ITEMS_CONFIG do
      include_context CONTEXT_PAGE_ITEMS_CONFIG do
        it_behaves_like SUCCESS_EXAMPLE
      end
    end
  end

  context "with failure examples" do
    before do
      allow(Jekyll.logger).to receive(:error)
    end

    shared_examples_for FAILURE_EXAMPLE do
      it do
        site.process
      rescue Jekyll::Errors::InvalidConfigurationError => e
        expect(e.message).to eq "'coffeebrew_jekyll_paginate' config is set incorrectly."
        expect(generated_files).to be_empty

        expect(Jekyll.logger)
          .to have_received(:error)
          .with("'coffeebrew_jekyll_paginate' config is set incorrectly.")
          .once

        expect(Jekyll.logger).to have_received(:error).with("Errors:", match_array(expected_errors)).once
      end
    end

    context CONTEXT_INVALID_CONFIG_KEYS do
      include_context CONTEXT_INVALID_CONFIG_KEYS do
        it_behaves_like FAILURE_EXAMPLE
      end
    end

    context CONTEXT_INVALID_CONFIG_VALUES do
      include_context CONTEXT_INVALID_CONFIG_VALUES do
        it_behaves_like FAILURE_EXAMPLE
      end
    end
  end
end
