# frozen_string_literal: true

module Coffeebrew
  module Jekyll
    module Paginate
      class Validator
        ROOT_KEY = "coffeebrew_jekyll_paginate"
        COLLECTIONS_KEY = "collections"
        DEFAULTS_KEY = "defaults"

        ALLOWED_ROOT_KEYS = [
          COLLECTIONS_KEY,
          DEFAULTS_KEY
        ].freeze

        ALLOWED_CONFIG_KEYS = {
          "frontmatter_defaults_key" => [],
          "individual_page_pagination" => [true, false],
          "first_page_as_root" => {
            "enabled" => [true, false],
            "permalink" => [],
            "index_page" => []
          },
          "permalink" => [],
          "index_page" => [],
          "per_page" => [],
          "sort_field" => [],
          "sort_reverse" => [true, false],
          "page_num_label" => []
        }.freeze

        def initialize(site, config)
          @site = site
          @config = config
          @errors = []
        end

        def validate!
          parse_root
          parse_defaults
          parse_collection_keys
          parse_collections_config

          return if @errors.empty?

          ::Jekyll.logger.error "'coffeebrew_jekyll_paginate' config is set incorrectly."
          ::Jekyll.logger.error "Errors:", @errors

          raise ::Jekyll::Errors::InvalidConfigurationError, "'coffeebrew_jekyll_paginate' config is set incorrectly."
        end

        private

        def parse_root
          not_allowed_keys = @config.keys.reject do |key|
            ALLOWED_ROOT_KEYS.include?(key)
          end
          return if not_allowed_keys.empty?

          @errors << { key: ROOT_KEY, expected: ALLOWED_ROOT_KEYS, got: not_allowed_keys }
        end

        def defaults_config
          @defaults_config ||= @config[DEFAULTS_KEY].to_h
        end

        def parse_defaults
          parse(defaults_config, ALLOWED_CONFIG_KEYS, ["#{ROOT_KEY}.#{DEFAULTS_KEY}"])
        end

        def configured_collections
          @configured_collections ||= collections_config.keys.sort
        end

        def allowed_collections
          @allowed_collections ||= @site.collections.keys
        end

        def parse_collection_keys
          not_allowed_collections = configured_collections.reject do |configured_collection|
            allowed_collections.include?(configured_collection)
          end
          return if not_allowed_collections.empty?

          @errors << {
            key: "#{ROOT_KEY}.collections",
            expected: allowed_collections,
            got: not_allowed_collections
          }
        end

        def collections_config
          @collections_config ||= @config[COLLECTIONS_KEY].to_h.transform_values(&:to_h)
        end

        def parse_collections_config
          collections_config.each do |collection_type, options|
            parse(options, ALLOWED_CONFIG_KEYS, ["#{ROOT_KEY}.#{COLLECTIONS_KEY}.#{collection_type}"])
          end
        end

        def parse(hash, allowed_keys, parent_key)
          hash.each do |key, configured_value|
            allowed_values = allowed_keys[key]
            new_parent_key = parent_key + [key]

            next if configured_in_allowed_values?(allowed_values, configured_value)

            if same_hash_type?(allowed_values, configured_value)
              next parse(configured_value, allowed_values, new_parent_key)
            end

            add_error(new_parent_key, allowed_values, configured_value)
          end
        end

        def same_hash_type?(allowed_values, configured_value)
          allowed_values.is_a?(Hash) && configured_value.is_a?(Hash)
        end

        def primitive?(value)
          value.nil? || value.is_a?(String) || value.is_a?(Numeric) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
        end

        def configured_in_allowed_values?(allowed_values, configured_value)
          allowed_values.is_a?(Array) && primitive?(configured_value) &&
            (allowed_values.empty? || allowed_values.include?(configured_value))
        end

        def add_error(parent_key, allowed_values, configured_value)
          @errors << { key: parent_key.join("."), expected: allowed_values, got: configured_value }
        end
      end
    end
  end
end
