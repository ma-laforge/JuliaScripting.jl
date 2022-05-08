module JuliaScripting
#Name of run environment used by scripts:
const RUN_ENVIRONMENT_NAME = "GlobalScripting_ASME"

#-------------------------------------------------------------------------------
@info("Global scope: Initializing code @ pre-compile time (typically)")
@warn(""""Only initialize structures with statically known code.
Ex: No `Dict()`s with `::DataTypes` as keys
--> (`::DataTypes` are not statically known)""")

#-------------------------------------------------------------------------------
using NumericIO
SI(x) = formatted(x, :SI, ndigits=2)

include("install.jl") #Load in installation utilities
include("readtables.jl")


#==Module initialization (optional)
===============================================================================#
function __init__()
	println()
	@info("__init__() function: Initializing code @ run time")
	println("""Place any initialization code that depends on "non-static" or external data.""")
	println("Ex: Load in global data structures from files.")
end


#==Top-level scripting functions
===============================================================================#
function RunTheScript(options)
	println()
	print("******************* Running the script **********************")
	readtables(options)
	println()
	println("Data processing complete!")
	return (answer=42, reason="It is simply the answer!")
end

end #module JuliaScripting