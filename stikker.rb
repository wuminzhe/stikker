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
    size =  config['size'].nil?           ? '560x'                    : config['size']
    font =  config['font'].nil?           ? "#{@dir}/fonts/msyh.ttf"  : config['font']
    fontsize = config['fontsize'].nil?    ? '21'                      : config['fontsize']
    fontcolor = config['fontcolor'].nil?  ? '#000000'                 : config['fontcolor']
    kerning = config['kerning'].nil?      ? '0'                       : config['kerning']
    bgcolor = config['bgcolor'].nil?      ? 'none'                    : config['bgcolor']
    scale = config['scale'].nil?          ? '100%'                        : config['scale']

    #
    #@command << "-page +#{x}+#{y} \\\( -size #{size} -font '#{font}' -fill '#{fontcolor}' -pointsize #{fontsize} -kerning #{kerning} -background '#{bgcolor}' caption:\"#{content}\" \\\)"
    geometry = scale=='100%' ? "+#{x}+#{y}" : "#{scale}x#{scale}+#{x}+#{y}"
    @command << "\\\( -size #{size} -font '#{font}' -fill '#{fontcolor}' -pointsize #{fontsize} -kerning #{kerning} -background '#{bgcolor}' caption:\"#{content}\" \\\) -geometry #{geometry} -composite"
  end

  def add_image(x, y, image, config={})
    if image.start_with? 'http'
      image = download(image)
    end

    scale = config['scale'].nil? ? '100%' : config['scale']
    geometry = scale=='100%' ? "+#{x}+#{y}" : "#{scale}x#{scale}+#{x}+#{y}"
    @command << "'#{image}' -geometry #{geometry} -composite" 
  end

  #顺时针
  def generate(file, rotate_degree=nil)
    if not rotate_degree.nil? 
      #@command << "-background none -layers flatten miff:- | convert -rotate #{rotate_degree} - '#{file}'"
      @command << "miff:- | convert -rotate #{rotate_degree} - '#{file}'"
    else
      #@command << "-background none -layers flatten '#{file}'"
      @command << "'#{file}'"
    end
    
    puts @command.join(" \\\n")
    `#{@command.join(" ")}`
  end

  #不管怎么样，都生成jpg，imagemagick自动会进行图片格式转换
  #result_file = "./stikker/tmp/result_#{Digest::SHA1.hexdigest(json)}.jpg" 
  #如果同样的图片已经生成过了，那就不用第二次生成了
  #return result_file if FileTest.exist?(result_file)
  def Stikker.generate(json, file, rotate_degree=nil)
    return nil if json.nil? or json.strip==''
    return nil if json.include? '<html>'

    #开始生成
    covers_objs = JSON.parse(json)

    #背景
    background = covers_objs['background'].nil? ? 'http://kai7.cn/images/2368c013c52ad7be356da0ef02d5b30be1cbe936.png' : covers_objs["background"]
    stikker = Stikker.new(background)

    #文字
    if(not covers_objs['texts'].nil?)
      covers_objs['texts'].each do |t|
        text = t['content'].gsub("　", "").gsub("\n", "").gsub("\r", "").gsub("'", "\\\’").gsub("\"", "\\\"").gsub(" ", "")
        x = t['x']
        y = t['y']
        size = t['size']
        color = t['color']
        kerning = t['kerning']
        #rotate = t['rotate']
        width = t['width']
        scale = t["scale"]

        if not text.nil? and text.strip != ''
          stikker.add_text(x, y, text, 'size'=>width, 'fontsize'=>size, 'fontcolor'=>color, 'kerning'=>kerning, 'scale'=>scale)
        end
      end
    end
    
    #图片
    if(not covers_objs['images'].nil?)
      covers_objs['images'].each do |i|
        src = i['src']
        x = i['x']
        y = i['y']
        scale = i["scale"]

        if not src.nil? and src.strip != ''
          stikker.add_image(x, y, src, 'scale'=>scale)
        end
      end
    end
    
    stikker.generate(file, rotate_degree)
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
