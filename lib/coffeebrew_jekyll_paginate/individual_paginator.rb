# frozen_string_literal: true

require_relative "./page_drop"

module Coffeebrew
  module Jekyll
    module Paginate
      class IndividualPaginator
        attr_reader :collection_type,
                    :current_page, :current_page_path,
                    :previous_page, :previous_page_path,
                    :next_page, :next_page_path

        def initialize(collection_type, previous_page, current_page, next_page)
          @collection_type = collection_type
          @current_page = current_page
          @current_page_path = full_url(@current_page)
          @previous_page = previous_page
          @previous_page_path = full_url(@previous_page)
          @next_page = next_page
          @next_page_path = full_url(@next_page)
        end

        def data
          @data ||= {
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

        def full_url(page)
          return "" if page.nil?

          page.url
        end
      end
    end
  end
end
