#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

// Vertex attributes
layout (location = 0) in vec3 inPos;
layout (location = 1) in vec3 inNormal;
layout (location = 2) in vec2 inUV;
layout (location = 3) in vec3 inColor;

// Instanced attributes
layout (location = 4) in vec3 instancePos;
layout (location = 5) in vec3 instanceRot;
layout (location = 6) in float instanceScale;
layout (location = 7) in int instanceTexIndex;

layout (binding = 0) uniform UBO 
{
    mat4 view;
    mat4 projection;
    vec4 lightPos;
    vec3 camPos;
    float lightInt;
    float locSpeed;
    float globSpeed;
} ubo;

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec3 outColor;
layout (location = 2) out vec3 outUV;
layout (location = 3) out vec3 outViewVec;
layout (location = 4) out vec3 outLightVec;
layout (location = 5) out float outLightInt;

void main() 
{
	outColor = inColor;
	outUV = vec3(inUV, instanceTexIndex);

	mat3 mx, my, mz;
	
	// rotate around x
	float s = sin(instanceRot.x + ubo.locSpeed);
	float c = cos(instanceRot.x + ubo.locSpeed);

	mx[0] = vec3( c,   s,  0.0);
	mx[1] = vec3(-s,   c,  0.0);
	mx[2] = vec3(0.0, 0.0, 1.0);
	
	// rotate around y
	s = sin(instanceRot.y + ubo.locSpeed);
	c = cos(instanceRot.y + ubo.locSpeed);

	my[0] = vec3( c,  0.0,  s);
	my[1] = vec3(0.0, 1.0, 0.0);
	my[2] = vec3(-s,  0.0,  c);
	
	// rot around z
	s = sin(instanceRot.z + ubo.locSpeed);
	c = cos(instanceRot.z + ubo.locSpeed);	
	
	mz[0] = vec3(1.0, 0.0, 0.0);
	mz[1] = vec3(0.0,  c,   s);
	mz[2] = vec3(0.0, -s,   c);
	
	mat3 rotMat = mz * my * mx;

	mat4 gRotMat;
	s = sin(instanceRot.y + ubo.globSpeed);
	c = cos(instanceRot.y + ubo.globSpeed);
	gRotMat[0] = vec4( c,  0.0,  s,  0.0);
	gRotMat[1] = vec4(0.0, 1.0, 0.0, 0.0);
	gRotMat[2] = vec4(-s,  0.0,  c,  0.0);
	gRotMat[3] = vec4(0.0, 0.0, 0.0, 1.0);	
	
	vec4 locPos = vec4(rotMat * inPos.xyz, 1.0);
	gl_Position = ubo.projection * ubo.view * gRotMat * vec4((locPos.xyz * instanceScale) + instancePos, 1.0);
	outNormal = (gRotMat * vec4(rotMat * inNormal.xyz, 0.0)).xyz;
	
	vec4 pos  = gRotMat * vec4((locPos.xyz * instanceScale) + instancePos, 1.0);
	vec4 cPos = vec4(ubo.camPos, 1.0);
	vec4 lPos = (ubo.lightPos);
	
	outLightVec = (lPos - pos).xyz;
	outViewVec  = (cPos - pos).xyz;
	outLightInt = ubo.lightInt;
}
