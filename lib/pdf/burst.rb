module PDF
  class Burst
    def initialize(pdf_path, options={})
      @pdf_path = pdf_path
      @output_path = options[:output_path] || "."
      @page_name = options[:output_filename] || "page_%d"
    end
    
    def run!
      page_count.times do |i|
        page_number = i + 1
        system burst_command(page_number)
      end
    end
    
    def page_count
      `#{page_count_command}`.to_i
    end
    
    private
    
    def page_count_command
      "pdfinfo '#{@pdf_path}' | grep 'Pages:' | grep -oP '\\d+'"
    end
    
    def burst_command(page_number)
      "gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=#{page_number} -dAutoFilterColorImages=false -dAutoFilterGrayImage=false -dColorImageFilter=/FlateEncode -dLastPage=#{page_number} -sOutputFile='#{output_file_path(page_number)}' '#{@pdf_path}'"
    end
    
    def page_filename(page_number)
      @page_name % page_number + ".pdf"
    end
    
    def output_file_path(page_number)
      File.expand_path("#{@output_path}/#{page_filename(page_number)}")
    end
  end
end
