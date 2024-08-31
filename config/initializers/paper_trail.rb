require 'bigdecimal'
require 'bigdecimal/util'

PaperTrail.config.enabled = true

PaperTrail.config do |config|
  config.serializer = PaperTrail::Serializers::YAML
end

PaperTrail::Serializers::YAML.class_eval do
  def load(string)
    YAML.safe_load(string, permitted_classes: [BigDecimal, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, Time], aliases: true)
  end

  def dump(object)
    YAML.dump(object)
  end
end