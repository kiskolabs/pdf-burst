# PDF::Burst

## What?

PDF::Burst is a gem that lets you split a PDF document with several pages into single page files.


## Why?

We needed this functionality for the development of [Lehtilompakko](http://lehtilompakko.fi/), and did not want any Java app to do the job.


## How?

Simple! Once you install the 'pdf-burst' gem, all you need is:

    require 'pdf-burst'
    PDF::Burst.new("/path/to/my/document.pdf").run!

By default, the PDF files will be output to your current working directory. But that's not what you want, is it?

    PDF::Burst.new("document.pdf", :output_path => "/tmp").run!

Better, huh?

Another default is the page name. They'll all be nicely named like "page_1.pdf", "page_2.pdf". We let you change that too:

    PDF::Burst.new("document.pdf", :page_filename => "doc.%04d").run!

Would output them like this: "doc.0001.pdf", "doc.0002.pdf", etc.


## Special thanks

Thanks to [Hopeinen Norsu](http://hopeinennorsu.fi/) for letting us release this as open-source.


## License

Check the LICENSE file. It's the MIT license.
