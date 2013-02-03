# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

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
  process :fix_exif_rotation
  process :strip

  # Create different versions of your uploaded files:
  
  #process :resize_to_limit => [500, 500]
  
  #version :thumb do
    #process :crop
    process :resize_to_fill => [150, 150]
  #end

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
  
  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end
  
  def strip
    manipulate! do |img|
      img.strip
      img = yield(img) if block_given?
      img
    end
  end

end
