stikker
=======

a ruby class help to add stickers(texts, images) to a background image easily. based on imagemagick

easy to use
=======

#example
require '../stikker.rb'

stikker = Stikker.new("http://photo.yupoo.com/ninjapan/Bp2axpm7/medish.jpg")
stikker.add_text(230, 580, "& WHITE", {'fontsize'=>'33', 'fontcolor'=>'#ffffff'})
stikker.add_text(210, 580, "BLACK")
stikker.generate("./example/example1.jpg")
