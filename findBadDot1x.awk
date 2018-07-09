#! /bin/awk -f

BEGIN {
	currentRecord = ""
	currentFile = ""
}

/^interface .*\/[0-9]{1,2}/,/reinitialize vlan|!/ { 

	if (FILENAME != currentFile) {
		print "\n" FILENAME "\n"
		currentFile = FILENAME
	}

	if ($0 ~ /^interface/) {
		if (currentRecord != "") {
			fldNum = split(currentRecord, fields, " ")
			if (fldNum == 3 && (fields[2] != fields[3])) {
				print "interface " fields[1]
				print " no authentication event server dead action reinitialize vlan " fields[3]
				print " authentication event server dead action reinitialize vlan " fields[2] 
			}
			currentRecord = ""
		}
		currentRecord = $2
	}

	if ($0 ~ /access vlan [0-9]{1,4}$/) {
		currentRecord = currentRecord " " $4
	}

	if ($0 ~ /reinitialize vlan/) {
		currentRecord = currentRecord " " $8
	}
}

END {
	fldNum = split(currentRecord, fields, " ")
        if (fldNum == 3 && (fields[2] != fields[3])) {
		print "interface " fields[1]
		print " no authentication event server dead action reinitialize vlan " fields[3]
		print " authentication event server dead action reinitialize vlan " fields[2] 
        }
}
