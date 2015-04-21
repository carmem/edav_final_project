#!/usr/bin/python

import sys
sys.path.append('./')

# Input file: race_2010_input
# 
# 
# Input format (codes): 
# 01001|Autauga County, AL
# 01003|Baldwin County, AL
# 01005|Barbour County, AL
# 01007|Bibb County, AL
#
# Input format (state_abbreviations):
# Alabama	AL
# Alaska	AK
# Arizona	AZ
# Arkansas	AR
# California	CA
# Colorado	CO
# 
# Output format: 
# 01001|Autauga County|Alabama
# 01003|Baldwin County|Alabama
# 01005|Barbour County|Alabama
# 01007|Bibb County|Alabama
# 01009|Blount County|Alabama
# 01011|Bullock County|Alabama
# 

def mapper(argv):

	state_dict = {}

	f = open('state_abbreviations', 'r')
	for l in f:
		name, ab = l.strip().split("\t")

		if ab not in state_dict:
			state_dict[ab] = name


	errors = 0
	for line in sys.stdin:
		try:
			data = line.strip().split("|")
			code = data[0]
			data1 = data[1].strip().split(',')
			if len(data1) == 2:
				county = data1[0]
				state = state_dict[data1[1].replace(" ","")]
				print "%s|%s|%s" %(code, county, state)

		except Exception as e:
			errors += 1
			e = sys.exc_info()[0]
			sys.stderr.write("\nERROR Mapper:  %s **** %s" % (line,e))
			continue

	# print "errors %d" %(errors)

if __name__ == '__main__':
   mapper(sys.argv)
