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
      burst = PDF::Burst.new("my.pdf", :output_filename => "my_pages.%04d")
      burst.send(:page_filename, 13).should == "my_pages.0013.pdf"
    end

  end
  
  context "output file" do

    it "has a default path" do
      burst = PDF::Burst.new("my.pdf")
      burst.send(:output_file_path, 2).should == "#{FileUtils.pwd}/page_2.pdf"
    end

    it "is customizable" do
      burst = PDF::Burst.new("magazine.pdf", :output_path => "/tmp/")
      burst.send(:output_file_path, 4).should == "/tmp/page_4.pdf"
    end

  end

  it "runs the ghostscript burst command for each page" do
    burst = PDF::Burst.new("file.pdf")
    burst.stub!(:page_count).and_return(5)
    burst.should_receive(:system).exactly(5).times
    burst.should_receive(:burst_command).exactly(5).times
    burst.run!
  end

end
