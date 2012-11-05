# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end

  # Process files as they are uploaded:
  process :resize_to_limit => [870, 800]

  # Create different versions of your uploaded files:
  
  version :large do
    process :crop
    process :resize_to_fill => [592, 394]
  end
  
  version :thumb, from_version: :large do
    process :resize_to_fill => [300, 200]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  # alternate temporary location for Heroku
  def cache_dir
    "#{Rails.root.to_s}/tmp/uploads"
  end
  
  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x
        y = model.crop_y
        w = model.crop_w
        h = model.crop_h
        
        w << 'x' << h << '+' << x << '+' << y

        img.crop(w)
        img
      end
    end
  end

end
