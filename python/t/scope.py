#!/usr/bin/python

j,k = 1,2

def proc1():
	#local variables
	j,k = 3,4
	print 'j == %d k == %d' % (j,k)
	k = 5

def proc2():
	# j -- local : k -- global
	j = 6
	proc1()
	print 'j == %d k == %d' % (j,k)

k = 7
proc1() # 3,4
print 'j == %d k == %d' % (j,k) # 1,7

j = 8
proc2() # 3,4 6,7
print 'j == %d k == %d' % (j,k) # 8,7

