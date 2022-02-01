class EgTracer
  attr_accessor :elements

  LOG_FILE = "#{ ENV['HOME'] }/shopify_logs/eg_tracer.log"

  def initialize
    @elements = []
    ensure_log_file
  end

  def trace obj=nil
    location = caller_locations(1, 1).first
    elements << {
      caller: location.label,
      log: obj&.inspect || "", # could maybe have context as default
      time: Time.now.to_s,
      path: location.path,
      lineno: location.lineno,
      context: context(location),
    }
    log elements.last
    obj
  end

  def context location
    if File.exist? location.path
      # start = location.lineno-5 > 0 ? location.lineno-5 : 1
      # File.readlines(location.path)[ start..location.lineno+5 ]
      i = location.lineno - 1
      lines = File.readlines(location.path)
      i = i-1 while i > 0 && !lines[i].match(/\s*def \w/)
      if i!=0
        start = i
        spaces = lines[i].match(/^(\s*)/)[1]
        i = location.lineno + 1
        i = i + 1 while i < 5000 && !lines[i].match(/^#{Regexp.quote(spaces)}end$/)
        finish = i
      end
      lines[start..finish]
    else
      []
    end
  end

  def log obj
    File.open(LOG_FILE, 'a') do |f|
      f.puts "Time: #{ obj[:time] }"
      f.puts "File: #{ obj[:path] }"
      f.puts "Line: #{ obj[:lineno] }"
      f.puts "Caller: #{ obj[:caller] }"
      f.puts obj[:log]
      f.puts ""
      f.puts "Context:\n\n" + obj[:context].join("")
      f.puts ""
    end
    obj
  end

  def ensure_log_file
    unless File.exists?(LOG_FILE)
      `mkdir -p #{ LOG_FILE.gsub('/eg_tracer.log', '') }`
      `touch #{ LOG_FILE }`
    end
  end
end

$eg_tracer = EgTracer.new
