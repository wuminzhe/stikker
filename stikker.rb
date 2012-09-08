require "sha1"
require "fileutils"
require "uri"
require 'open-uri'
require 'pathname'

class Stikker
  def initialize(background_image)
    @dir = Pathname.new(File.dirname(__FILE__)).realpath
    #
    if background_image.start_with? 'http'
      background_image = download(background_image)
    end
    @command = ["convert '#{background_image}'"]
  end

  def add_text(x, y, content, config={})
    x = x.nil? ? 0 : x
    y = y.nil? ? 0 : y

    #中文空格替换成中文逗号，英文空格替换为英文都好，因为空格有时会引起不正常换行
    #双引号转换成单引号
    #content = content.nil? ? '' : content.gsub("　", "，").gsub(" ", ",").gsub("\"", "'")
    content = content.nil? ? '' : content.gsub("\"", "'")
    
    #
    size =  config['size'].nil?           ? '200x'                    : config['size']
    font =  config['font'].nil?           ? "#{@dir}/fonts/msyh.ttf"  : config['font']
    fontsize = config['fontsize'].nil?    ? '18'                      : config['fontsize']
    fontcolor = config['fontcolor'].nil?  ? '#000000'                 : config['fontcolor']
    kerning = config['kerning'].nil?      ? '0'                       : config['kerning']
    bgcolor = config['bgcolor'].nil?      ? 'none'                   : config['bgcolor']

    #
    @command << "-page +#{x}+#{y} \\\( -size #{size} -font '#{font}' -fill '#{fontcolor}' -pointsize #{fontsize} -kerning #{kerning} -background '#{bgcolor}' caption:\"#{content}\" \\\)"
  end

  def add_image(x, y, image)
    if image.start_with? 'http'
      image = download(image)
    end
    @command << "-page +#{x}+#{y} '#{image}'"
  end

  def generate(file)
    @command << "-background none -layers flatten '#{file}'"
    `#{@command.join(" ")}`
  end

  private

  def download(url)

    if (suffix=url.split('.').last) == 'png' or suffix == 'jpg' or suffix == 'jpeg'
      filename = "#{Digest::SHA1.hexdigest(url)}.#{suffix}"
    else
      filename = "#{Digest::SHA1.hexdigest(url)}"
    end
    tmp_dir = "#{@dir}/tmp"
    FileUtils.mkdir(tmp_dir) unless File.directory?(tmp_dir)
    if FileTest.exist?("#{tmp_dir}/#{filename}")
      return "#{tmp_dir}/#{filename}"
    else
      puts "download #{url} ..."
      data = open(URI::encode(url)){|f| f.read} 
      file = File.new "#{tmp_dir}/#{filename}", 'w+' 
      file.binmode 
      file << data 
      file.flush 
      file.close
      return "#{tmp_dir}/#{filename}"
    end
    
  end

end
