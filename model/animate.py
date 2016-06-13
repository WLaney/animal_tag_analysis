#!/usr/bin/python3
import heapq
import model

TIMESTEP = 1.0 / 12.0
FAKEFILE = "fake.txt"
REALFILE = "real.txt"

events = [
	( 0, 'set_angular_velocity', (90, 0, 0)),
	( 4, 'set_angular_velocity', (0, 0, 0)),
	( 5, 'set_angular_velocity', (0, 90, 0)),
	( 9, 'set_angular_velocity', (0, 0, 0)),
	(10, 'set_angular_velocity', (0, 0, 90)),
	(14, 'set_angular_velocity', (0, 0, 0)),
	(15, 'end', [])
]
heapq.heapify(events)

with open(FAKEFILE, 'w') as fakef, \
	 open(REALFILE, 'w') as realf:
	tag = model.Model(0.2, 0.2)
	time = 0.0
	while True:
		# parse command
		if time >= events[0][0]:
			cmd, args = heapq.heappop(events)[1:]
			if cmd == 'set_angular_velocity':
				tag.set_angular_velocity(*args)
			elif cmd == 'set_angle':
				tag.set_angle(*args)
			elif cmd == 'end':
				break
			else:
				raise KeyError("Invalid event: %s" % (cmd,))
		# print tag data
		fakef.write(tag.get_readouts())
		fakef.write("\n")
		realf.write(tag.get_actual())
		realf.write("\n")
		# update ts
		tag.update(TIMESTEP)
		time += TIMESTEP
