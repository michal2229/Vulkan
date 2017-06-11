#!/usr/bin/env python3

import pyshaderc
import sys

scriptname = sys.argv[0]
shadertype = sys.argv[1]  # vert, frag...
filelist   = [str(i) for i in sys.argv[2:]]

for fil in filelist:
    spirv = pyshaderc.compile_file_into_spirv(fil, shadertype)
    
    with open("{}.spv".format(fil), "wb") as file:
        file.write(spirv)
    
    
    
#    spirvFile = open("{}.spv".format(fil), "wb")
#    spirvFile.write(spirv)
    

#spirv = pyshaderc.compile_file_into_spirv('./instancing.vert', 'vert')
#newFile = open("./instancing.vert.spv", "wb")
#newFile.write(spirv)

#with open("foo.bin", "wb") as file:
#  file.write(pack("<IIIII", *bytearray([120, 3, 255, 0, 100])))
