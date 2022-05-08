# `JuliaScripting.jl` (for Windows)
A demo project showing how you can create a user-configurable scripting tool
in Julia

## Installation
```julia
julia> ]
pkg> add https://github.com/ma-laforge/JuliaScripting
pkg> ← (backspace)
julia> using JuliaScripting
julia> JuliaScripting.install()
```

`JuliaScripting.install()` does the following:
- Creates a sample "shared" Julia environment (`GlobalScripting_ASME`).
  - (`GlobalScripting_ASME` environment is used by sample script [`sample_scripts/sample1.jl_script`](sample_scripts/sample1.jl_script).)
- Copies a powershell script (`launch_julia_script.ps1`) to the active Julia directory.
  - This might require Windows admin privileges.
- Adds RMB "Execute with Julia" action for `.jl_script` files in Windows Explorer.
  - Also requires Windows admin privileges.

## Known Limitations
- Use of legacy file type associations in the Windows regsistry?

### Details: Legacy file type associations
The autor believes the current method of associating RMB actions to the
`.jl_script` file type is using Windows XP-era legacy registry entries.

Please open a GitHub issue/pull-request to help migrate to the more modern system.

### Compatibility

Extensive compatibility testing of JuliaScripting.jl has not been performed.  The module has been tested using the following environment(s):
- Windows 10 / Julia-1.7.2

## Disclaimer
The `JuliaScripting.jl` module was created for demonstration purposes.  Feel free to copy/modify as needed. Expect significant changes.