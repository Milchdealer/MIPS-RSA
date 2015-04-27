from __future__ import print_function

import os, sys
import unittest

from io import StringIO

import subprocess

import random

class TestRSA_C(unittest.TestCase):

	def setUp(self):
		os.chdir('../C')
		os.system('make')

	def c_crypt(self, s):
		proc = subprocess.Popen(['../bin/rsa', s], stdout=subprocess.PIPE)
		output = proc.stdout.read()
		self.assertTrue(output.endswith("Decrypted message: %s" % s), "Wrong decryption: %d \n%s" % (len(s), output))

	def test_decrypt(self):
		words = ['a', 'ab', 'pom', 'sunu', '..', 'rabel', 'kaltxi', 'klavier', 'bananenbrot', 'superkalifragelistike']
		for l in range(1000, 14000, 2000):
			words.append(''.join( chr(random.randint(63, 120)) for i in range(l) ))
		map(self.c_crypt, words)

class TestRSA_MIPS(unittest.TestCase):

	def setUp(self):
		os.chdir('../mips')

	def call_mips(self, path, input_str):

		proc = subprocess.Popen(['../bin/spim load %s' % path], stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
		proc.stdin.write(input_str)
		output = proc.stdout.read()

		return output.replace('Loaded: /usr/share/spim/exceptions.s\n', '')

	def test_fact(self):

		for val, expected in [ (0,1), (1,1), (2,2), (3,6), (4,24), (5,120) ]:
			self.assertEquals( self.call_mips('fact.s', '%s\n' % val), str(expected) )

	def test_text2int(self):

		pass

if __name__ == '__main__':
	unittest.main()

