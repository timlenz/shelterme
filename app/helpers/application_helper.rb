module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Shelter Me"
    if page_title.empty?
      base_title
    else
      "#{page_title} @ #{base_title}"
    end
  end
  
  def canonical_link_tag
    tag(:link, rel: :canonical, href: @canonical_url) if @canonical_url
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "#{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {class: css_class}
  end

end