#!/usr/bin/python3
import heapq
import model
import datetime

TIMESTEP = 1.0 / 12.0
FAKEFILE = "fake.txt"
REALFILE = "real.txt"
ANGLEFILE = "angles.txt"

events = [
	( 4, 'set_angular_velocity', (   0,  90,   0)),
	( 5, 'set_angular_velocity', (   0,   0,   0)),
	( 9, 'set_angular_velocity', (   0,  90,   0)),
	(10, 'set_angular_velocity', (   0,   0,   0)),
	(14, 'set_angular_velocity', (   0, -90,   0)),
	(15, 'set_angular_velocity', (   0,   0,   0)),
	(19, 'set_angular_velocity', (   0, -90,   0)),
	(20, 'set_angular_velocity', (   0,   0,   0)),
	(24, 'set_angular_velocity', (   0, -90,   0)),
	(25, 'set_angular_velocity', (   0,   0,   0)),
	(29, 'set_angular_velocity', (   0, -90,   0)),
	(30, 'set_angular_velocity', (   0,   0,   0)),
	(34, 'set_angular_velocity', (   0,  90,   0)),
	(35, 'set_angular_velocity', (   0,   0,   0)),
	(39, 'set_angular_velocity', (   0,  90,   0)),
	(40, 'set_angular_velocity', (   0,   0,   0)),
	(45, 'end', [])
]
heapq.heapify(events)

with open(FAKEFILE,  'w') as fakef, \
	 open(REALFILE,  'w') as realf, \
	 open(ANGLEFILE, 'w') as anglef:
	tag = model.Model(0.0001, 0.00264)
	dt = datetime.datetime(1990, 1, 1)
	step = datetime.timedelta(milliseconds=TIMESTEP*1000)
	time = 0.0
	while True:
		# parse command
		if time >= events[0][0]:
			cmd, args = heapq.heappop(events)[1:]
			if cmd == 'set_angular_velocity':
				tag.set_angular_velocity(*args)
			elif cmd == 'set_angle':
				tag.set_angle(*args)
			#~ elif cmd == 'set_linear_accel':
				#~ tag.set_linear_accel(*args)
			elif cmd == 'end':
				break
			else:
				raise KeyError("Invalid event: %s" % (cmd,))
		# print tag data
		dts = dt.strftime("%m-%d-%Y %H:%M:%S:%f")
		fakef.write(dts)
		fakef.write(tag.get_readouts())
		fakef.write("\n")
		
		realf.write(dts)
		realf.write(tag.get_actual())
		realf.write("\n")
		
		anglef.write(tag.get_angle_s())
		# update ts
		tag.update(TIMESTEP)
		dt += step
		time += TIMESTEP
