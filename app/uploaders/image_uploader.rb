class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  version :normal do
    process resize_to_fill: [360, 360]
  end

  version :thumb, from_version: :normal do
    process resize_to_fill: [50, 50]
  end
end
