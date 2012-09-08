require '../stikker.rb'

stikker = Stikker.new("http://img1.baixing.net/m/6efdd859dafc2e6e684c66ce1db4d1bd.jpg")
stikker.add_text(0, 0, "a", 'bgcolor'=>'green')
stikker.add_text(5, 5, "a", 'bgcolor'=>'yellow')
stikker.add_text(10, 10, "a", 'bgcolor'=>'blue')
stikker.add_image(100, 100, "../tmp/bar.png")
stikker.add_text(15, 15, "a", 'bgcolor'=>'pink')
stikker.add_text(50, 50, "吃\n过了\"中'文 空格　没有，‘小王’", 'bgcolor'=>'gray')
stikker.generate("/Users/wumz/Desktop/hello_text.png")