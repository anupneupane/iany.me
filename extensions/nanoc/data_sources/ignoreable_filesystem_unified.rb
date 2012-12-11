module Nanoc::DataSources
  class IgnoreableFilesystemUnified < FilesystemUnified
    def up
      @ignore_regexp = @config[:ignore] && Regexp.new(@config[:ignore])
    end

    def all_split_files_in(dir_name)
      grouped_filenames = super(dir_name)
      if @ignore_regexp
        grouped_filenames.delete_if { |k, v| k =~ @ignore_regexp }
      end

      grouped_filenames
    end
  end
end
