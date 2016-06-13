#!/usr/bin/python3
"""model.py - Models a tag with accelerometer and gyroscope.

This is a script to simulate a gravity-affected "tag" and the readouts
from its 3-axis accelerometer and gyroscope.

The tag starts at an initial orientation of [0.0, 0.0, 0.0] such that
gravity is along the z axis. As such, starting acceleration is
[0.0, 0.0, 1.0], since the device is resting and not in freefall.

Acceleration is measured in m/sec^2. Angular velocity is measured
in degrees per second. For this project, a left-hand coordinate
system is used with this model:

^ z (yaw)
|
|
*----> x (pitch)
 \
  > y (roll)
  
Positive angles correspond with CLOCKWISE rotations.
"""
import math
import random

GRAVITY = 1.0

class Model:
	
	def __init__(self, accel_noise, gyro_noise):
		"""
		Create a new, unmoving model.
		
		accel_noise and gyro_noise are the stdev of a Gaussian
		distribution. (TODO see if noise is Gaussian or evenly
		distributed).
		"""
		self._angular_velocity = [0.0, 0.0, 0.0]
		self._angle = [0.0, 0.0, 0.0]
		self._accel_noise = accel_noise
		self._gyro_noise = gyro_noise

	def update(self, timestep):
		"""Advance this model by timestep seconds."""
		self._angle[0] += self._angular_velocity[0] * timestep
		self._angle[1] += self._angular_velocity[1] * timestep
		self._angle[2] += self._angular_velocity[2] * timestep

	def set_angular_velocity(self, p, r, y):
		"""Set the pitch, roll, and yaw in deg/sec."""
		self._angular_velocity = [p, r, y]

	def get_angular_velocity(self):
		"""Get the current angular velocity as (p, r, y)."""
		return self._angular_velocity

	def get_angle(self):
		"""Get the angle relative to its initial orientation."""
		return self._angle

	def set_angle(self, p, r, y):
		"""Set the current angle relative to its initial orientation."""
		self._angle = [p, r, y]

	def get_gyroscope(self):
		"""Get the current gyroscope readout (with noise)."""
		return random.gauss(self.get_angular_velocity(), self._gyro_noise)

	def get_acceleration(self):
		"""Get the current acceleration due to gravity as (x,y,z)."""
		ang = [-a for a in self.get_angle()]
		return self._get_gravity_vector(*ang)

	def get_accelerometer(self):
		"""Get the current accelerometer readout (with noise)."""
		return random.gauss(self.get_acceleration(), self._accel_noise)

	"""
	Rotational values stolen from a SIGGRAPH educational site.
	The coordinates had to be swapped around, though.

	X-Axis Rotation
	y' = y*cos q - z*sin q
	z' = y*sin q + z*cos q 

	Y-Axis Rotation
	z' = z*cos q - x*sin q
	x' = z*sin q + x*cos q

	Z-Axis
	x' = x*cos q - y*sin q
	y' = x*sin q + y*cos q
	"""

	def _get_gravity_vector(self, p, r, yw):
		"""Return a vector representing the force of gravity."""
		p = math.radians(p)
		r = math.radians(r)
		yw = math.radians(yw)
		# Create a vector and rotate it around each axis
		x, y, z = [0.0, 0.0, GRAVITY]
		# x (pitch)
		cp, sp = math.cos(p), math.sin(p)
		y, z = y*cp - z*sp , y*sp + z*cp
		# y (roll)
		cr, sr = math.cos(r), math.sin(r)
		z, x = z*cr - x*sr , z*sr + x*cr
		# z (yaw)
		cyw, syw = math.cos(yw), math.sin(yw)
		x, y = x*cyw - y*syw , x*syw + y*cyw
		return [x, y, z]

	def __str__(self):
		"""Print out the current state as [accel], [gyro], [real angle]."""
		print("%10.8f %10.8f %10.8f" % self.get_accelerometer(),
			  "%10.8f %10.8f %10.8f" % self.get_gyroscope(),
			  "%10.8f %10.8f %10.8f" % self.get_angle()
			  )

