from __future__ import print_function
from __future__ import absolute_import

import os, sys
import unittest

from io import StringIO

import subprocess

import random

import generate_mips

words = ['a', 'ab', 'pom', 'sunu', '..', 'rabel', 'kaltxi', 'klavier', 'bananenbrot', 'superkalifragelistike']

class TestRSA_C():#unittest.TestCase):

	def setUp(self):
		os.chdir('../C')
		os.system('make')

	def c_crypt(self, s):
		proc = subprocess.Popen(['../bin/rsa', s], stdout=subprocess.PIPE)
		output = proc.stdout.read()
		self.assertTrue(output.endswith("Decrypted message: %s" % s), "Wrong decryption: %d \n%s" % (len(s), output))

	def test_decrypt(self):
		wds = words[:]
		for l in range(1000, 14000, 2000):
			wds.append(''.join( chr(random.randint(63, 120)) for i in range(l) ))
		map(self.c_crypt, wds)

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
		generate_mips.link_file('text2int.s')
		
		for val, expected in [ ('A', '650'), ('ABC', '6566670'), ('hallo', '104971081081110') ]:
			self.assertEquals( self.call_mips('gen/text2int.s', '%s\n' % val), expected )

	def test_int2text(self):
		generate_mips.link_file('int2text.s')

		for val, expected in [ ([65,0], 'A'), ([65,66,67,0], 'ABC'), ([104,97,108,108,111,0], 'hallo') ]:
			self.assertEquals( self.call_mips('gen/int2text.s', '%s\n' % '\n'.join(str(v) for v in val)), expected )

	def test_strlen(self):
		for w in words:
			self.assertEquals( self.call_mips('strlen.s', '%s\n' % w), str(len(w) + 1) )

if __name__ == '__main__':
	unittest.main()

