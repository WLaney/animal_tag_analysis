#!/usr/bin/python3
"""model_test.py - unit tests for the Model class.

This isn't exhaustive, but I want to check my bases here.
"""
import unittest
import model

ZERO = [0.0, 0.0, 0.0]

class TestStringMethods(unittest.TestCase):
	
	def assertListAlmostEqual(self, first, second):
		self.assertEqual(len(first), len(second))
		for f, s in zip(first, second):
			self.assertAlmostEqual(f, s, msg="%s vs. %s" % (first, second))

	def setUp(self):
		self.model = model.Model(0.1, 0.1)

	def tearDown(self):
		del self.model

	def test_new(self):
		self.assertListAlmostEqual(self.model.get_angular_velocity(), ZERO)
		self.assertListAlmostEqual(self.model.get_angle(), ZERO)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, 1.0])

	def test_rotate(self):
		"""Flip the tag over and see if the perceived gravity vector has reversed."""
		self.model.set_angle(0.0, 180.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, -1.0])
		# yaw should not change the gravitational vector
		self.model.set_angle(0.0, 180.0, 90.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 0.0, -1.0])
		# pitch 90 degrees counterclockwise - gravity is y
		self.model.set_angle(90.0, 0.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, 1.0, 0.0])
		# reverse
		self.model.set_angle(270.0, 0.0, 0.0)
		self.assertListAlmostEqual(self.model.get_acceleration(), [0.0, -1.0, 0.0])

	def test_animate(self):
		self.model.set_angular_velocity(90.0, 45.0, 0.0)
		self.assertListAlmostEqual(self.model.get_angle(), ZERO)
		self.model.update(1.0) # should rotate 90 deg X, 45 deg Y
		self.assertListAlmostEqual(self.model.get_angle(), [90.0, 45.0, 0.0])
		self.model.update(2.0) # 180dx, 90dy
		self.assertListAlmostEqual(self.model.get_angle(), [270.0, 135.0, 0.0])

if __name__ == '__main__':
	unittest.main()
