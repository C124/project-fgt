extends Label

var ms = 0
var s = 0 
var m = 0

func _process(delta):
	
	if ms > 9 :
		s += 1
	
	if s > 59 :
		m += 1
		s = 0
	
	set_text(str(s)+":"+str(ms))
	
	pass
