module PDF
  class Burst
    def initialize(pdf_path, options={})
      @pdf_path = pdf_path
      @output_path = options[:output] || "."
      @page_name = options[:filename] || "page_%d"
      @thumbnail_size = options[:thumbnail]
    end
    
    def run!
      page_count.times do |i|
        page_number = i + 1
        system burst_command(page_number)
        system thumbnail_command(page_number) if generate_thumbnail?
      end
    end
    
    def page_count
      `#{page_count_command}`.to_i
    end
    
    def generate_thumbnail?
      !!@thumbnail_size
    end
    
    private
    
    def page_count_command
      "pdfinfo '#{@pdf_path}' | grep 'Pages:' | grep -oP '\\d+'"
    end
    
    def burst_command(page_number)
      "gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=#{page_number} -dAutoFilterColorImages=false -dAutoFilterGrayImage=false -dColorImageFilter=/FlateEncode -dLastPage=#{page_number} -sOutputFile='#{output_file_path(page_number)}' '#{@pdf_path}'"
    end
    
    def thumbnail_command(page_number)
      "convert -resize #{@thumbnail_size} #{output_file_path(page_number)} #{output_file_path(page_number, 'png')}"
    end
    
    def page_filename(page_number, extension="pdf")
      @page_name % page_number + ".#{extension}"
    end
    
    def output_file_path(page_number, extension="pdf")
      File.expand_path("#{@output_path}/#{page_filename(page_number, extension)}")
    end
  end
end
