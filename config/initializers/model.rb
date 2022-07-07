AttributeNormalizer.configure do |config|
  config.normalizers[:subnets] = lambda do |value, options|
    value.join(",")
  end
end
