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
  
  def my_photoless # current user's pets without a photo
    pets = current_user.pets.select{|p| p.pet_photos.count == 0}.count
  end
  
  def managed_photoless # current user's pets without a photo
    pets = current_user.shelter.pets.select{|p| p.pet_photos.count == 0}.count
  end
  
  def all_photoless # current user's pets without a photo
    pets = Pet.select{|p| p.pet_photos.count == 0}.count
  end
  
  def pet_list
    if cookies[:history]
      pets = cookies[:history].split(" ").map{|s| s.to_i }.reverse.uniq
      pets = pets.map{|p| Pet.select{|x| x.id == p}}.flatten
    else
      pets = []
    end
  end
  
  def recent_adoptions
    pets = Pet.all.select{|p| p.pet_state.status == "adopted"}.sort_by{|d| d.updated_at}.reverse.first(4)
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "#{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {class: css_class}
  end

end