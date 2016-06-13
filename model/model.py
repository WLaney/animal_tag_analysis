#!/usr/bin/python3
"""model.py - Models a tag with accelerometer and gyroscope.

This is a script to simulate a gravity-affected "tag" and the readouts
from its accelerometers (measuring acceleration) and gyroscopes 
(measuring angular velocity). It allows you to move and rotate the 
object in real time, getting its 'real' acceleration and angular 
velocity (with and without gravity) as well as accelerometer
and gyroscope readouts (with controllable added noise).

The tag starts out in an "initial orientation" of [0.0, 0.0, 0.0]
(Euler angles) and is at rest such that whatever it's resting
on is pushing up against gravity (I'm not the best physicist).

Acceleration is measured in m/sec^2. Angular velocity is measured
in degrees per second. For this project, a left-hand coordinate
system is used with this model:

^ z (yaw)
|
|
*----> x (pitch)
 \
  > y (roll)
"""
import math
import random

GRAVITY = 9.8 

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
		g_angle = [0.0, 90.0, 0.0]
		g_angle = [g - a for g, a in zip(g_angle, self.get_angular_velocity())]
		g_vec = self._angle_to_vector(*g_angle)
		return [g * GRAVITY for g in g_vec]

	def get_accelerometer(self):
		"""Get the current accelerometer readout (with noise)."""
		return random.gauss(self.get_acceleration(), self._accel_noise)

	def _angle_to_vector(self, p, r, y):
		"""Return a normalized (x,y,z) vector from an angle.
		
		Each angle is in degrees.
		"""
		p = math.radians(p)
		r = math.radians(r)
		y = math.radians(y)
		# Create a vector and rotate it around each axis
		x, y, z = [1.0, 0.0, 0.0]
		# Z axis
		cyaw, syaw = math.cos(y), math.sin(y)
		x, y = x*cyaw - y*syaw , x*syaw - y*cyaw
		# Y axis
		cp, sp = math.cos(p), math.sin(p)
		y, z = y*cp - z*sp , y*sp - z*cp
		# X axis
		cr, sr = math.cos(r), math.sin(r)
		x, z = z*sr + x*cr , z*cr - x*sr
		return [x, y, z]

	def __str__(self):
		"""Print out the current state as [accel], [gyro], [real angle]."""
		print("%10.8f %10.8f %10.8f" % self.get_accelerometer(),
			  "%10.8f %10.8f %10.8f" % self.get_gyroscope(),
			  "%10.8f %10.8f %10.8f" % self.get_angle()
			  )

