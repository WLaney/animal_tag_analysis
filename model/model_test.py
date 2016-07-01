#!/usr/bin/python3
"""model_test.py - unit tests for the Model class.
"""
import unittest
import model
import math

ZERO = [0.0, 0.0, 0.0]
DG45 = math.sqrt(2) / 2.0

class TestStringMethods(unittest.TestCase):
	
	def assertListAlmostEqual(self, first, second, message=""):
		"""Check for equality in two lists of floats.
		In the event of a mismatch, the lists' contents are diplayed in full.
		"""
		self.assertEqual(len(first), len(second))
		for f, s in zip(first, second):
			msg = "%s vs. %s" % (first, second)
			if message:
				msg = message + "\n" + msg
			self.assertAlmostEqual(f, s, msg=msg)

	def setUp(self):
		self.model = model.Model(0.1, 0.1)

	def tearDown(self):
		del self.model

	def test_new(self):
		"""Test that a brand-new tag is correctly oriented."""
		self.assertListAlmostEqual(self.model.get_angular_velocity(), ZERO, \
			"Angular velocity is not zero on initialization.")
		self.assertListAlmostEqual(self.model.get_angle(), ZERO, \
			"Angle is not zero on initialization.")
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, 1.0], \
			"Acceleration != g on initialization.")

	def test_flipTagOver(self):
		self.model.set_angle(0.0, 180.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, -1.0], \
			"Flipped tag over; gravity != -g.")

	def test_flipAndYaw(self):
		self.model.set_angle(0.0, 180.0, 90.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, -1.0], \
			"Yawing tag and flipping it over != -g.")

	def test_pitch90(self):
		self.model.set_angle(90.0, 0.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 1.0, 0.0], \
			"Pitching 90 degrees counterclockwise failed.")

	def test_pitch270(self):
		self.model.set_angle(270.0, 0.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, -1.0, 0.0], \
			"Pitching 270 degrees counterclockwise failed.")
	
	def test_pitch45(self):
		"""p=45 -> [0, sqrt(2)/2, sqrt(2)/2]"""
		self.model.set_angle(45.0, 0.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, DG45, DG45], \
			"Pitching 45 degrees counterclockwise failed.")

	def test_rolls(self):
		angles = [
			[0.0,  90.0, 0.0],
			[0.0, 180.0, 0.0],
			[0.0, 270.0, 0.0],
			[0.0,  45.0, 0.0]
		]
		vectors = [
			[ 1.0, 0.0,  0.0],
			[ 0.0, 0.0, -1.0],
			[-1.0, 0.0,  0.0],
			[DG45,   0, DG45]
		]
		names = ["90", "180", "270", "45"] 
		for angle, vector, name in zip(angles, vectors, names):
			with self.subTest(msg=name):
				self.model.set_angle(*angle)
				self.assertListAlmostEqual(self.model.get_acceleration(), vector, \
					"Roll test failed.")

	def test_p270r90(self):
		"""Test some weird roll/pitch combos."""
		self.model.set_angle(270, 90, 0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0, -1, 0], \
			"270p, 90r test failed.")

	def test_reflexive(self):
		"""Test that the gravity for negative angles = their equivalent positives."""
		tests = [
			[1, 0, 0],
			[0, 1, 0],
			[0, 0, 1]
		]
		names = ["X", "Y", "Z"]
		for test, name in zip(tests, names):
			with self.subTest(msg=name):
				angle1 = [-90 * t for t in test]
				self.model.set_angle(*angle1)
				accel1 = self.model.get_acceleration()
				angle2 = [270 * t for t in test]
				self.model.set_angle(*angle2)
				accel2 = self.model.get_acceleration()
				self.assertListAlmostEqual(accel1, accel2, name + "reflexivity failed")

	def test_animate(self):
		"""Test that update() correctly advances the angle."""
		self.model.set_angular_velocity(90.0, 45.0, 0.0)
		self.assertListAlmostEqual(self.model.get_angle(), ZERO)
		self.model.update(1.0) # should rotate 90 deg X, 45 deg Y
		self.assertListAlmostEqual(self.model.get_angle(), [90.0, 45.0, 0.0])
		self.model.update(2.0) # 180dx, 90dy
		self.assertListAlmostEqual(self.model.get_angle(), [270.0, 135.0, 0.0])

if __name__ == '__main__':
	unittest.main()
