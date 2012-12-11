module Nanoc::DataSources
  class IgnoreableFilesystemUnified < FilesystemUnified
    def all_split_files_in(dir_name, kind, klass)
      grouped_filenames = super
      if regexp = @config["ignore_#{kind}".to_sym]
        grouped_filenames.delete_if { |k, v| k =~ regexp }
      end

      grouped_filenames
    end
  end
end
