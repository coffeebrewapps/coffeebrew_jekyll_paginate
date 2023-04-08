# frozen_string_literal: true

module Coffeebrew
  module Jekyll
    module Paginate
      class Page < ::Jekyll::Page
        attr_reader :paginator, :collection_type, :collection,
                    :page_num_zero_index, :page_num_one_index

        def initialize(site, config, collection_type, collection, page_num_zero_index) # rubocop:disable Lint/MissingSuper
          @site = site
          @config = config
          @collection_type = collection_type
          @collection = collection
          @page_num_zero_index = page_num_zero_index
          @page_num_one_index = page_num_zero_index.to_i + 1

          @base = site.source
          @ext = ".html"

          build_data
        end

        def paginator=(paginator)
          @paginator = paginator
          @data["paginator"] = paginator

          data.default_proc = proc do |_, key|
            site.frontmatter_defaults.find(relative_path, frontmatter_defaults_key, key)
          end
        end

        def frontmatter_defaults_key
          @frontmatter_defaults_key ||= format(@config["frontmatter_defaults_key"], collection_type: collection_type)
        end

        def basename
          @basename ||= ::Jekyll::URL.new(template: nil,
                                          placeholders: basename_placeholders,
                                          permalink: @config["index_page"])
                                     .to_s
        end

        def name
          @name ||= "#{basename}#{ext}"
        end

        def dir
          @dir ||= ::Jekyll::URL.new(template: nil,
                                     placeholders: page_dir_placeholders,
                                     permalink: @config["permalink"])
                                .to_s
        end

        def page_dir_placeholders
          @page_dir_placeholders ||= {
            collection_type: collection_type.to_s,
            page_num_zero_index: page_num_zero_index.to_s,
            page_num_one_index: page_num_one_index.to_s,
            basename: basename,
            output_ext: output_ext
          }
        end

        def basename_placeholders
          @basename_placeholders ||= {
            collection_type: collection_type.to_s,
            page_num_zero_index: page_num_zero_index.to_s,
            page_num_one_index: page_num_one_index.to_s
          }
        end

        def url_placeholders
          {
            path: dir,
            basename: basename,
            output_ext: output_ext
          }
        end

        def page_num_label
          @page_num_label ||= format(@config["page_num_label"],
                                     page_num_zero_index: page_num_zero_index, page_num_one_index: page_num_one_index)
        end

        def title
          @title ||= collection_type.capitalize
        end

        def full_url
          @full_url ||= [dir, name].join("/").squeeze("/")
        end

        private

        def build_data
          @data = {
            "title" => title,
            "collection" => collection,
            "collection_type" => collection_type,
            "page_num_zero_index" => page_num_zero_index,
            "page_num_one_index" => page_num_one_index,
            "page_num_label" => page_num_label,
            "full_url" => full_url
          }
        end
      end
    end
  end
end
