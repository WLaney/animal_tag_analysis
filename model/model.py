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
		#~ self._linear_accel = [0.0, 0.0, 0.0]
		self._accel_noise = accel_noise
		self._gyro_noise = gyro_noise

	def update(self, timestep):
		"""Advance this model by timestep seconds."""
		for i in range(0,len(self._angle)):
			self._angle[i] += self._angular_velocity[i] * timestep

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

	#~ def get_linear_accel(self):
		#~ """Get the current linear acceleration.
		
		#~ This represents acceleration not due to gravity, and
		#~ throws off the accelerometer.
		#~ """
		#~ return self._linear_accel

	#~ def set_linear_accel(self, x, y, z):
		#~ """Get the current linear acceleration.
		
		#~ This represents acceleration not due to gravity, and
		#~ throws off the accelerometer.
		#~ """
		#~ self._linear_accel = [x, y, z]

	def get_gyroscope(self):
		"""Get the current gyroscope readout (with noise)."""
		gyro = self.get_angular_velocity()
		return [random.gauss(g, self._gyro_noise) for g in gyro]

	def get_acceleration(self):
		"""Get the current acceleration due to gravity as (x,y,z)."""
		g_accel = self._get_gravity_vector(*self.get_angle())
		#~ return [g+l for g, l in zip(g_accel,self.get_linear_accel())]
		return g_accel

	def get_accelerometer(self):
		"""Get the current accelerometer readout (with noise)."""
		accel = self.get_acceleration()
		return [random.gauss(a, self._accel_noise) for a in accel]

	"""
	Rotation matrix taken from our accelerometer paper. Since our
	original vector is along the Z axis, Z rotation shouldn't do jack
	to it, so we can use a simpler model that just takes pitch and
	roll instead.
	
	(Used eq.11 from "Tilt Sensing Using a Three-Axis Accelerometer")
	"""

	def _get_gravity_vector(self, p, r, yw):
		"""Return a vector representing the force of gravity."""
		p  = math.radians(-p)
		r  = math.radians(r)
		# Rotate a gravity vector (parallel to Z axis)
		cos_p = math.cos(p)
		x = cos_p * math.sin(r)
		y = -math.sin(p)
		z = cos_p * math.cos(r)
		return [x, y, z]

	def get_readouts(self) -> str:
		"""Return gyroscope and accelerometer data, tab-sep."""
		return "%13.8f %13.8f %13.8f" % (*self.get_gyroscope(),) + "\t" + \
		       "%13.8f %13.8f %13.8f" % (*self.get_accelerometer(),) 

	def get_actual(self) -> str:
		"""Return angular velocity and acceleration, tab-sep."""
		return "%13.8f %13.8f %13.8f" % (*self.get_angular_velocity(),) \
				+ "\t" + "%13.8f %13.8f %13.8f" % (*self.get_acceleration(),) #\
				#+ "\t" + "%13.8f %13.8f %13.8f" % (*self.get_linear_accel(),) 
				
	def get_angle_s(self) -> str:
		"""Return the angle as a tab-separated string."""
		return "%5.3f\t%5.3f\t%5.3f\n" % (*self.get_angle(),)
