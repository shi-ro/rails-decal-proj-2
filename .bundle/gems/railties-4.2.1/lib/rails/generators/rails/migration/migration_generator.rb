module Rails
  module Generators
    class MigrationGenerator < NamedBase # :nodoc:
      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
      hook_for :orm, required: true
    end
  end
end
