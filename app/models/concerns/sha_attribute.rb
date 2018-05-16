module ShaAttribute
  extend ActiveSupport::Concern

  module ClassMethods
    def sha_attribute(name)
      return if ENV['STATIC_VERIFICATION']
      return unless table_exists?

      column = columns.find { |c| c.name == name.to_s }

<<<<<<< HEAD
      # In case the table doesn't exist we won't be able to find the column,
      # thus we will only check the type if the column is present.
      if column && column.type != :binary
        raise ArgumentError,
          "sha_attribute #{name.inspect} is invalid since the column type is not :binary"
=======
      unless column
        warn "WARNING: sha_attribute #{name.inspect} is invalid since the column doesn't exist - you may need to run database migrations"
        return
>>>>>>> master
      end

      attribute(name, Gitlab::Database::ShaAttribute.new)
    end
  end
end
