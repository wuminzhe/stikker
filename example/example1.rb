require '../stikker.rb'

stikker = Stikker.new("http://photo.yupoo.com/ninjapan/Bp2axpm7/medish.jpg")
stikker.add_text(230, 580, "& WHITE", {'fontsize'=>'33', 'fontcolor'=>'#ffffff'})
stikker.add_text(210, 580, "BLACK")
stikker.add_image(50, 50, "../tmp/balloon.png")
stikker.generate("./example1.jpg")