#Installation tools
#-------------------------------------------------------------------------------
using Pkg
const QT = "\""

MODULE_PATH = realpath(joinpath(dirname(pathof(@__MODULE__)), ".."))


#==Individual installation steps
===============================================================================#

#-------------------------------------------------------------------------------
function setup_run_environment(;develop_this_module::Bool=true)
	"""- develop_this_module: Set to `true` if this module isn't registered with the Julia package registry"""
	println("Creating \"shared\" environment: $RUN_ENVIRONMENT_NAME...")
	env_presets = joinpath(@__DIR__, "..", "env_presets")
	src = joinpath(env_presets, RUN_ENVIRONMENT_NAME * ".toml")
	dest = joinpath(Pkg.envdir(), RUN_ENVIRONMENT_NAME, "Project.toml")
	mkpath(dirname(dest))
	cp(src, dest, force=true)

	#println("-->Activating $RUN_ENVIRONMENT_NAME.") #Already shown by Pkg.activate()
	Pkg.activate(RUN_ENVIRONMENT_NAME, shared=true)
	if develop_this_module
		println("-->Linking $(@__MODULE__) to $MODULE_PATH.")
		Pkg.develop(path=MODULE_PATH) #Will
	end

	println("-->Updating \"shared\" environment $RUN_ENVIRONMENT_NAME...")
	Pkg.update() #Instantiate & download newest versions
	println("Done.")
	println()
	@info("Shared environment ready for use: $RUN_ENVIRONMENT_NAME.")

	println("\nRestoring active environment to default:")
	Pkg.activate() #Go back to default environment
end

#-------------------------------------------------------------------------------
function install_JLScript_launcher()
	file_inf = "JLScriptRegistration.inf"
	file_ps1launcher = "launch_julia_script.ps1"
	dir_install_files = joinpath(@__DIR__, "..", "install_files")
	#juliacmd = joinpath(Sys.BINDIR, Base.julia_exename())

	print("Copying .ps1 JuliaScript launcher... ")
	src = joinpath(dir_install_files, file_ps1launcher)
	dest = joinpath(Sys.BINDIR, file_ps1launcher)
	launchercmd = dest
	cp(src, dest, force=true)
	println("Done.")

	#Create .inf action installer from template file:
	println("Adding RMB launch action to `.jl_script` file extensions:")
	print("-->Creating temporary `.inf` installation file... ")
	path_template = joinpath(dir_install_files, file_inf * "_template")
	script = readlines(path_template)
	script = join(script, "\n") #Convert to a single string
	script = replace(script,
	r"\$\(JULIA_VERSION\)" => "v$(Base.VERSION)",
	r"\$\(LANUCHERCMD\)" => launchercmd,
	r"\$\(ACTION_NAME\)" => "JLScript-v$(Base.VERSION)",
	)

	mktemp() do path_inf_tmp, io
		#Write script to temp file:
		print(io, script)
		close(io)
		println("Done.")

		print("-->Applying `.inf` to windows registry... ")
		#run(`InfDefaultInstall "$path_inf_tmp"`) #Doesn't seem to work
		#Need to run using powershell:
		run(`powershell -ExecutionPolicy Bypass -Command "InfDefaultInstall" "$path_inf_tmp"`)
		println("Done.")
	end
end


#==Top-level install function
===============================================================================#
function install()
	@info("Installing JuliaScripting...")
	setup_run_environment()
	println()
	install_JLScript_launcher()
end