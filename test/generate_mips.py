
import re

import os.path

reg_include = re.compile( r'#INCLUDE "(.*?)"' )
reg_main_block = re.compile( r'#BEGIN{{(.*)#END}}', re.DOTALL )

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

	open('../mips/gen/%s' % os.path.basename(path), 'w').write(linked_src)

def main(target_file_path):
	link_file(target_file_path)

if __name__ == '__main__':
	import sys
	main( *sys.argv[1:] )