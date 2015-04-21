#!/usr/bin/python

import sys
sys.path.append('./')

# Input file: race_2010_input
# 
# 
# Input format: 
# County	Total	Hispanic or Latino	Not Hispanic or Latino:
# Autauga County|Alabama	54571	1310	53261
# Baldwin County|Alabama	182265	7992	174273
# Barbour County|Alabama	27457	1387	26070
#
# Output format: 
# County Name, Hispanic or Latino, Not Hispanic or Latino
# 

def mapper(argv):

	state_dict = {}

	f = open('codes', 'r')
	for l in f:
		name, ab = line.strip().split("\t")
		if ab not in state_dict:
			state_dict[ab] = name

	print len(state_dict)
	print state_dict

	errors = 0
	for line in sys.stdin:
		try:
			data = line.strip().split("\t")
			county = data[0]
			total = int(data[1])
			hispanic = float(data[2])/total
			non_hispanic = float(data[3])/total
			print "%s,%f,%f" %(county, hispanic, non_hispanic)

		except Exception as e:
			errors += 1
			e = sys.exc_info()[0]
			sys.stderr.write("\nERROR Mapper:  %s **** %s" % (line,e))
			continue

	# print "errors %d" %(errors)

if __name__ == '__main__':
   mapper(sys.argv)
