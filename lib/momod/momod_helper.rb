module Momod
  module MomodHelper

    def self.parse_to_class var, kelas
      kelas.class.attributes.each do |attrib|
        eval("kelas.#{attrib} = ( var[:#{attrib}] ? var[:#{attrib}] : var['#{attrib}'] ? var['#{attrib}'] : kelas.#{attrib} )")
      end
      return kelas
    end

    def self.fetch_field object
      hash = eval("{ #{object.class.name.downcase.singularize}: {} }")
      object.class.attr_accessible.each do |attrib|
        eval("hash[:#{object.class.name.downcase.singularize}][:#{attrib}] = object.#{attrib}")
      end
      hash
    end

  end
end
