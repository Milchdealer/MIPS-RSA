from __future__ import print_function
from __future__ import absolute_import

import os, sys
import unittest

from io import StringIO

import subprocess

import random

import generate_mips

words = ['a', 'ab', 'pom', 'sunu', '..', 'rabel', 'kaltxi', 'klavier', 'bananenbrot', 'superkalifragelistike']

class TestRSA_C(unittest.TestCase):

	def setUp(self):
		os.chdir('../C')
		os.system('make')

	def c_crypt(self, s):
		proc = subprocess.Popen(['../bin/rsa', s], stdout=subprocess.PIPE)
		output = proc.stdout.read()
		#self.assertTrue(output.endswith("Decrypted message: %s" % s), "Wrong decryption: %d \n%s" % (len(s), output))

	def test_decrypt(self):
		wds = words[:]
		for l in range(1000, 14000, 2000):
			wds.append(''.join( chr(random.randint(63, 120)) for i in range(l) ))
		map(self.c_crypt, wds)

	"""def test_spam(self):
		for w in words:
			for i,j in [(20,30),(20,50),(20,70),(20,90),(25,30),(30,50),(30,70),(30,90),(30,37),(30,50),(30,70),(30,90),(50,70),(50,90)]:
				proc = subprocess.Popen(['../bin/rsa', w, str(i), str(j)], stdout=subprocess.PIPE)
				output = proc.stdout.read()
				print(output)"""

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

	def test_gcd(self):
		generate_mips.link_file('gcd.s')

		for val, expected in [ ([10,5], 5), ([12,18],6), ([144,160], 16), ([16,175], 1), ([1071,1029], 21) ]:
			self.assertEquals( self.call_mips('gen/gcd.s', '%d\n%d\n' % tuple(val)), str(expected) )

	def test_powmod(self):
		generate_mips.link_file('powmod.s')

		for val, expected in [ ([5,3,13],8), ([4,13,497],445), ([2,50,13],4), ([2,40,13],3), ([97,5,504],265) ]:
			self.assertEquals( self.call_mips('gen/powmod.s', '%d\n%d\n%d\n' % tuple(val)), str(expected) )
	
	def test_inverse(self):
		generate_mips.link_file('inverse.s')

		for val, expected in [ ([20,7],3), ([32,25],9), ([12,7],7), ([504,421],85), ([72,7],31) ]:
			self.assertEquals( self.call_mips('gen/inverse.s', '%d\n%d\n' % tuple(val)), str(expected) )

	def test_getprime(self):
		generate_mips.link_file('getprime.s')

		for val, expected in [ (2,2),(3,3),(4,3),(5,5),(6,7),(7,7),(10,11),(15,17),(20,19),(40,41),(43,43),
								(50,53),(61,61),(70,71),(83,83),(89,89),(91,89),(99,101) ]:
			actual = self.call_mips('gen/getprime.s', '%d\n' % val)
			self.assertEquals( actual, str(expected), "getprime(%s) returned %s, but expected %s" % (val, actual, expected) )

	def test_publicExp(self):
		generate_mips.link_file('publicExp.s')

		for val, expected in [(16,3), (24,5), (40,3), (48,5), (64,3), (72,5), (88,3), (112,3), (120,7), (144,5), 
								(160,3), (168,5), (184,3), (36,5), (60,7), (96,5), (108,5), (132,5), 
								(180,7), (216,5), (240,7), (252,5), (276,5), (100,3)]:
			actual = self.call_mips('gen/publicExp.s', '%d\n' % val)
			self.assertEquals( actual, str(expected), 'publicExp(%s) returned %s, but expected %s' % (val, actual, expected))

	def test_encrypt(self):
		import encrypt_provider
		generate_mips.link_file('encrypt.s')

		for (e,phi), code, expected in encrypt_provider.coded:
			actual = self.call_mips( 'gen/encrypt.s', '%d\n%d\n%s\n' % (e,phi,'\n'.join(str(c) for c in code)) )
			self.assertEquals(  actual, '%s\n' % '\n'.join( str(exp) for exp in expected )  )

	def test_totient(self):
		generate_mips.link_file('totient.s')

		for val, expected in [ ([2, 2], [4, 1]), ([17, 11], [187, 160]), ([13, 7], [91, 72]), ([23, 47], [1081, 1012]) ]:
			self.assertEquals( self.call_mips('gen/totient.s', '%d\n%d\n' % tuple(val)), '%d\n%d' % (tuple(expected)) )


if __name__ == '__main__':
	unittest.main()

