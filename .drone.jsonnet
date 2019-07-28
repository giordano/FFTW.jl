local Pipeline(os, arch, version) = {
    kind: "pipeline",
    name: os+" - "+arch+" - Julia "+version,
    platform: {
	os: os,
	arch: arch
    },
    steps: [
	{
	    name: "build",
	    image: "julia:"+version,
	    commands: [
		"ldd $(which julia)",
		"find / -name 'libm.so*' 2> /dev/null",
		"julia --project=. --check-bounds=yes --color=yes -e 'using Pkg; Pkg.instantiate(); Pkg.build(); using FFTW; using Libdl; Libdl.dlopen(FFTW.libfftw3)'",
		"julia --project=. --check-bounds=yes --color=yes -e 'using FFTW; run(`ldd $(FFTW.libfftw3)`)'",
		"julia --project=. --check-bounds=yes --color=yes -e 'using InteractiveUtils; versioninfo(verbose=true); using Pkg; Pkg.build(); Pkg.test(coverage=true)'"
	    ]
	}
    ]
};

[
    Pipeline("linux", "arm",   "1.0"),
    # Pipeline("linux", "arm",   "1.1"),
    Pipeline("linux", "arm64", "1.0"),
    Pipeline("linux", "arm64", "1.1")
]
