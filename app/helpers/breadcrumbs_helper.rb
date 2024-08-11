module BreadcrumbsHelper
  def add_breadcrumb(name, path = '')
    @breadcrumbs ||= []
    @breadcrumbs << { name: name, path: path }
  end

  def render_breadcrumbs
    return "" unless @breadcrumbs
    content_tag(:nav, aria: { label: "breadcrumb" }) do
      content_tag(:ol, class: "breadcrumb") do
        @breadcrumbs.each_with_index.map do |breadcrumb, index|
          if index == @breadcrumbs.length - 1
            content_tag(:li, breadcrumb[:name], class: "breadcrumb-item active", aria: { current: "page" })
          else
            content_tag(:li, class: "breadcrumb-item") do
              link_to(breadcrumb[:name], breadcrumb[:path])
            end
          end
        end.join.html_safe
      end
    end
  end
end
