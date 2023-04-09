# frozen_string_literal: true

require_relative "./page"
require_relative "./individual_paginator"
require_relative "./paginator"
require_relative "./validator"

module Coffeebrew
  module Jekyll
    module Paginate
      class Generator < ::Jekyll::Generator
        safe true
        priority :lowest

        def generate(site)
          @site = site

          validate!

          user_collections_config.each do |collection_type, options|
            collection_options = add_collections_defaults(options)
            process_collection(collection_type.to_sym, collection_options)
          end
        end

        private

        def validate!
          validator = Coffeebrew::Jekyll::Paginate::Validator.new(@site, user_config)
          validator.validate!
        end

        def process_collection(collection_type, options)
          sort_field = options["sort_field"].to_sym
          sort_reverse = options["sort_reverse"]
          records = @site.collections[collection_type.to_s].docs
          records.sort_by!(&sort_field)
          records.reverse! if sort_reverse

          individual_pagination = options["individual_page_pagination"]
          generate_individual_page_paginator(collection_type, records) if individual_pagination

          pages = generate_pages(collection_type, records, options)
          return if pages.empty?

          generate_paginators(collection_type, pages)
        end

        def generate_individual_page_paginator(collection_type, records)
          records.each_with_index do |record, index|
            prev_record = index.positive? ? records[index - 1] : nil
            next_record = index < records.length ? records[index + 1] : nil
            paginator = Paginate::IndividualPaginator.new(collection_type, prev_record, record, next_record)
            record.data["paginator"] = paginator
          end
        end

        def generate_pages(collection_type, records, options)
          per_page = options["per_page"].to_i
          first_page_as_root = options["first_page_as_root"]

          records.each_slice(per_page).with_index.map do |page_records, page_num|
            page_options = options.clone
            if first_page_as_root["enabled"] && page_num.zero?
              page_options["permalink"] = first_page_as_root["permalink"]
              page_options["index_page"] = first_page_as_root["index_page"]
            end
            Paginate::Page.new(@site, page_options, collection_type, page_records, page_num)
          end
        end

        def generate_paginators(collection_type, pages)
          pages.each do |page|
            paginator = Paginate::Paginator.new(pages, collection_type, page.page_num_zero_index)
            page.paginator = paginator
            @site.pages << page
          end
        end

        def add_collections_defaults(user_options)
          ::Jekyll::Utils.deep_merge_hashes(
            default_defaults_config,
            ::Jekyll::Utils.deep_merge_hashes(user_defaults_config, user_options)
          )
        end

        def user_collections_config
          @user_collections_config ||= user_config["collections"].to_h.transform_values(&:to_h)
        end

        def user_defaults_config
          @user_defaults_config ||= user_config["defaults"].to_h
        end

        def user_config
          @user_config ||= @site.config["coffeebrew_jekyll_paginate"].to_h
        end

        def default_defaults_config
          @default_defaults_config ||= default_config.dig("coffeebrew_jekyll_paginate", "defaults").to_h
        end

        def default_config
          @default_config ||= YAML.safe_load(File.read(default_config_path))
        end

        def default_config_path
          @default_config_path ||= File.expand_path("config.yml", __dir__)
        end
      end
    end
  end
end
