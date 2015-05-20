
import re

import os.path

reg_include = re.compile( r'#INCLUDE "(.*?)"' )
reg_main_block = re.compile( r'#BEGIN{{(.*?)#END}}', re.DOTALL )

reg_push = re.compile( r'#PUSH_REGISTERS' )
reg_pop = re.compile( r'#POP_REGISTERS' )

rescue_registers = ['$s0','$s1','$s2','$s3','$s4','$s5','$s6','$s7','$ra']

def push_registers(registers):
	s = ''
	offset = 0
	for reg in registers:
		s += 'sw %s, %d($sp)\n\t' % (reg, offset)
		offset += 4

	s += 'addi $sp, $sp, %d\n' % offset

	return s

def pop_registers(registers):
	s = 'addi $sp, $sp, -%d\n\t' % (len(registers) * 4)
	offset = 0
	for reg in registers:
		s += 'lw %s, %d($sp)\n\t' % (reg, offset)
		offset += 4

	return s

def extract_block(mips_code):

	m = reg_main_block.search(mips_code)

	if m:
		return m.group(1)
	else:
		return mips_code

def read_mips_file(path):
	return open( os.path.join('../mips', path) ).read()

def link_file(path):

	src = open(path).read()

	def substitute_include(m):
		return extract_block( read_mips_file(m.group(1)) )

	linked_src = reg_include.sub(substitute_include, src)

	linked_src = reg_push.sub(lambda m: push_registers(rescue_registers), linked_src)
	linked_src = reg_pop.sub(lambda m: pop_registers(rescue_registers), linked_src)

	open('../mips/gen/%s' % os.path.basename(path), 'w').write(linked_src)

def main(target_file_path):
	link_file(target_file_path)

if __name__ == '__main__':
	import sys
	main( *sys.argv[1:] )