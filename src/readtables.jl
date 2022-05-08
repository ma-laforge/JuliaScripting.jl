#Reading in table data
#-------------------------------------------------------------------------------

#==Base functions
===============================================================================#
function readtable(filename)
	println("Reading file $filename...")
	return "Imagine contents of $filename here."
end


#==Top-level scripting functions
===============================================================================#
function readtables(options)
	println()
	@info("""Executing `readtables()`
	\tUsing output directory: $(options.output_dir)...""")

	#Test usage of an external package (environment properly loaded):
	freq_str = SI(2.4e9)
	println("Using NumericIO to display frequency=$(freq_str)Hz")

	global table1 = readtable("table1.csv")
	global table2 = readtable("table2.csv")
end