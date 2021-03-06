require 'shellwords'

module Nanoc::Filters
  class EmacsOrg < ::Nanoc::Filter
    TRY_EMACS = %w(/Applications/Emacs.app/Contents/MacOS/Emacs ~/bin/emacs /usr/local/bin/emacs /usr/bin/emacs)
    DEFAULT_OPTIONS = {
      :emacs => TRY_EMACS.find { |e| File.executable?(e) } || 'emacs',
      :load_path => [],
      :format => 'html'
    }

    def run(content, params={})
      options = DEFAULT_OPTIONS.merge(params)
      Export.new(options).org_export_as_string(content)
    end

    Export = Struct.new(:options) do
      def org_export_as_string(str)
        result = ""

        with_tmpfile do |infile|
          infile.write(str)
          infile.flush

          with_tmpfile do |outfile|
            org_export_to_file(infile.path, outfile.path)
            result = outfile.read
          end
        end

        result
      end

      private
      ELISP = <<-LISP
        (progn
          (defun org-html-fontify-code (code lang)
            (when code (org-html-encode-plain-text code)))
          (defadvice org-html-format-latex (after encode-html activate)
            (setq ad-return-value (org-html-encode-plain-text ad-return-value)))
          (org-export-to-file '%s %s nil nil t '(:with-toc nil :section-numbers nil)))
      LISP
      def org_export_to_file(infile, outfile)
        emacs_batch(
          "-l", "ox-publish", "-l", "ox-html",
          "--file", infile,
          "--eval", sprintf(ELISP, options[:format], outfile.inspect).each_line.collect(&:strip).join(' ')
        )
      end

      def emacs_batch(*args)
        command = Shellwords.join([emacs_bin, '-batch', '-q', '-no-site-file', *load_path, *args])
        system(command)
      end

      def load_path
        options[:load_path].collect { |p| ["-L", p] }.flatten
      end

      def emacs_bin
        options[:emacs]
      end

      def with_tmpfile
        file = Tempfile.new('org-export')
        begin
          yield file
        ensure
          file.close
          file.unlink
        end
      end
    end
  end
end
