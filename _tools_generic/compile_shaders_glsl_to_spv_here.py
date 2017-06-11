#!/usr/bin/env python3

import pyshaderc
import sys

scriptname = str(sys.argv[0])
shadertype = str(sys.argv[1])  # vert, frag...
filelist   = [str(i) for i in sys.argv[2:]]

for fil in filelist:
    spirv = pyshaderc.compile_file_into_spirv(fil, shadertype)
    
    with open("{}.spv".format(fil), "wb") as file:
        file.write(spirv)

