require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = "&hellip;"

    def to_html
      list_items = pagination.map do |item|
        case item
        when Integer
          page_number(item)
        else
          send(item)
        end
      end.join(@options[:link_separator])
      tag(:nav, tag("ul", list_items, class: ul_class))
    end

    def container_attributes
      super.except(*[:link_options])
    end

    protected

    def page_number(page)
      link_options = @options[:link_options] || {}

      if page == current_page
        tag("li", tag("span", page, class: 'page-link'), class: "page-item active")
      else
        tag("li", link(page, page, link_options.merge(rel: rel_value(page), class: 'page-link')), class: 'page-item')
      end
    end

    def previous_or_next_page(page, text, classname)
      link_options = @options[:link_options] || {}

      if page
        tag("li", link(text, page, link_options.merge(class: 'page-link')), class: classname)
      else
        tag("li", tag("span", text, class: 'page-link'), class: "#{classname} disabled")
      end
    end

    def gap
      tag("li", tag("span", ELLIPSIS, class: 'page-link'), class: "page-item disabled")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], "page-item prev")
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], "page-item next")
    end

    def ul_class
      ["pagination", @options[:class]].compact.join(" ")
    end
  end
end
