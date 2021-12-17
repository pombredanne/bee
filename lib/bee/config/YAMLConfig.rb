require 'yaml'

module Bee
  class YAMLConfig
    def initialize(cfgfile)
      @cfgobj = YAML.load_file(cfgfile)
    end

    def get(id)
      return @cfgobj[id.to_s]
    end

    def set(id,val)
      @cfgobj[id.to_s]=val
    end
  end
end
