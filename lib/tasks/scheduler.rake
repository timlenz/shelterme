task update_slugs: :environment do
  pets = Pet.all
  # pets.each{|p| p.update_attributes(:slug, p.generate_slug)}
  pets.each do |p|
    if p.name != ""
      p.slug = p.name.parameterize.gsub("-","").downcase.titleize
    else
      p.slug = p.name.parameterize.gsub("-","").downcase.titleize
    end
    # exclude self before checking if slug already exists; if so, append rand number; repeat
    while Pet.where(slug: p.slug).reject{|ps| ps == self}.size > 0 do
      p.slug = p.slug + Random.rand(1..9).to_s
    end
    p.save
  end
end