require "spec_helper"

describe PDF::Burst do
   
  context "page count" do

    it "generates the command" do
      burst = PDF::Burst.new("my.pdf")
      burst.send(:page_count_command).should == "pdfinfo 'my.pdf' | grep 'Pages:' | grep -oP '\\d+'"
    end
    
    it "is the correct number" do
      burst = PDF::Burst.new("my.pdf")
      burst.should_receive(:page_count_command).and_return("echo '128'")
      burst.page_count.should == 128
    end

  end

  context "page filename" do
    
    it "has a default" do
      burst = PDF::Burst.new("my.pdf")
      burst.send(:page_filename, 11).should == "page_11.pdf"
    end

    it "is customizable" do
      burst = PDF::Burst.new("my.pdf", :filename => "my_pages.%04d")
      burst.send(:page_filename, 13).should == "my_pages.0013.pdf"
    end

  end
  
  context "output file" do

    it "has a default path" do
      burst = PDF::Burst.new("my.pdf")
      burst.send(:output_file_path, 2).should == "#{FileUtils.pwd}/page_2.pdf"
    end

    it "is customizable" do
      burst = PDF::Burst.new("magazine.pdf", :output => "/tmp/")
      burst.send(:output_file_path, 4).should == "/tmp/page_4.pdf"
    end

  end
  
  context "thumbnail generation" do
    
    it "is possible through the 'convert' command" do
      burst = PDF::Burst.new("my.pdf", :thumbnail => "128x128")
      burst.send(:thumbnail_command, 3).should == "convert -resize 128x128 #{FileUtils.pwd}/page_3.pdf #{FileUtils.pwd}/page_3.png"
    end
    
    it "respects the filename option" do
      burst = PDF::Burst.new("my.pdf", :thumbnail => "128x180", :filename => "%d")
      burst.send(:thumbnail_command, 5).should == "convert -resize 128x180 #{FileUtils.pwd}/5.pdf #{FileUtils.pwd}/5.png"
    end
    
    it "respects the output option" do
      burst = PDF::Burst.new("my.pdf", :thumbnail => "64x64", :output => "/tmp")
      burst.send(:thumbnail_command, 1).should == "convert -resize 64x64 /tmp/page_1.pdf /tmp/page_1.png"
    end
    
    it "respects both the filename and output options" do
      burst = PDF::Burst.new("my.pdf", :thumbnail => "48x48", :output => "/tmp/pages", :filename => "%d")
      burst.send(:thumbnail_command, 11).should == "convert -resize 48x48 /tmp/pages/11.pdf /tmp/pages/11.png"
    end
    
    it "will be done if the thumbnail option is passed" do
      burst_with_thumbnail = PDF::Burst.new("my.pdf", :thumbnail => "40x40")
      burst_without_thumbnail = PDF::Burst.new("my.pdf")
      burst_with_thumbnail.generate_thumbnail?.should be_true
      burst_without_thumbnail.generate_thumbnail?.should be_false
    end
    
  end

  it "runs the ghostscript burst command for each page" do
    burst = PDF::Burst.new("file.pdf")
    burst.stub!(:page_count).and_return(5)
    burst.should_receive(:system).exactly(5).times
    burst.should_receive(:burst_command).exactly(5).times
    burst.run!
  end
  
  it "runs the thumbnail generation command for each page when the thumbnail option is passed" do
    burst = PDF::Burst.new("file.pdf", :thumbnail => "128x128")
    burst.stub!(:page_count).and_return(5)
    burst.should_receive(:system).exactly(10).times
    burst.should_receive(:thumbnail_command).exactly(5).times
    burst.run!
  end

end
