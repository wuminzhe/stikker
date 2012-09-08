stikker
=======

a ruby class help to add stickers(texts, images) to a background image easily. based on imagemagick

Easy to use
-----------

```
#example1
require '../stikker.rb'

stikker = Stikker.new("http://photo.yupoo.com/ninjapan/Bp2axpm7/medish.jpg")
stikker.add_text(230, 580, "& WHITE", {'fontsize'=>'33', 'fontcolor'=>'#ffffff'})
stikker.add_text(210, 580, "BLACK")
stikker.add_image(50, 50, "../tmp/balloon.png")
stikker.generate("./example1.jpg")
```

Method and Options
-------

*   Stikker.new(background_image)

### `background_image: string`

Can be a local image or a image from web like `http://photo.yupoo.com/ninjapan/Bp2axpm7/medish.jpg`. If it is a web image, stikker will download it to tmp folder. Next time, if the file exsit, stikker will not download again.



*   stikker.add_text(x, y, options)

    ## `size: string`

    A string to define the width and height of text block. For example: `100x`, `200x100`. See imagemagick docs for detail.

    Default: `200x`


    ## `font: string`

    A path to a font file.

    Default: `fonts/msyh.ttf`

    Default: `200x`


## `fontsize: num`

font size.

Default: `18`


### `fontcolor: string`

font color

Default: `#000000`


### `kerning: num`

font kerning.

Default: `0`


### `bgcolor: string`

text background color. For example: `none`, `#ffffff`

Default: `none`



*   stikker.add_image(x, y, image)

### `image: string`

Can be a local image or a image from web.

Default: `200x`