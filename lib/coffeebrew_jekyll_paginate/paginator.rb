# frozen_string_literal: true

require_relative "./page_drop"

module Coffeebrew
  module Jekyll
    module Paginate
      class Paginator
        attr_reader :total_pages, :pages,
                    :page_num_zero_index, :page_num_one_index, :page_num_label,
                    :collection, :collection_type,
                    :current_page, :current_page_path,
                    :previous_page, :previous_page_path,
                    :next_page, :next_page_path

        def initialize(pages, collection_type, page_num_zero_index = 0)
          @total_pages = pages.size
          @pages = pages
          @page_num_zero_index = page_num_zero_index
          @collection_type = collection_type

          set_current_page
          set_prev_page
          set_next_page
        end

        def data # rubocop:disable Metrics/MethodLength
          @data ||= {
            "total_pages" => total_pages,
            "pages" => pages,
            "page_num_zero_index" => page_num_zero_index,
            "page_num_one_index" => page_num_one_index,
            "page_num_label" => page_num_label,
            "collection" => collection,
            "collection_type" => collection_type,
            "current_page" => current_page,
            "current_page_path" => current_page_path,
            "previous_page" => previous_page,
            "previous_page_path" => previous_page_path,
            "next_page" => next_page,
            "next_page_path" => next_page_path
          }
        end

        def to_liquid
          @to_liquid ||= Paginate::PageDrop.new(self)
        end

        private

        def set_current_page
          @current_page = pages[page_num_zero_index]
          @current_page_path = full_url(@current_page)

          @collection = current_page&.collection || []
          @page_num_one_index = @current_page&.page_num_one_index
          @page_num_label = @current_page&.page_num_label
        end

        def set_prev_page
          return if page_num_zero_index.zero?

          @previous_page = pages[page_num_zero_index - 1]
          @previous_page_path = full_url(@previous_page)
        end

        def set_next_page
          return unless page_num_zero_index < total_pages - 1

          @next_page = pages[page_num_zero_index + 1]
          @next_page_path = full_url(@next_page)
        end

        def full_url(page)
          return "" if page.nil?

          page.full_url
        end
      end
    end
  end
end
