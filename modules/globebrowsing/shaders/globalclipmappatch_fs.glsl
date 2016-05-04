/*****************************************************************************************
 *                                                                                       *
 * OpenSpace                                                                             *
 *                                                                                       *
 * Copyright (c) 2014                                                                    *
 *                                                                                       *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this  *
 * software and associated documentation files (the "Software"), to deal in the Software *
 * without restriction, including without limitation the rights to use, copy, modify,    *
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to    *
 * permit persons to whom the Software is furnished to do so, subject to the following   *
 * conditions:                                                                           *
 *                                                                                       *
 * The above copyright notice and this permission notice shall be included in all copies *
 * or substantial portions of the Software.                                              *
 *                                                                                       *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,   *
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A         *
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT    *
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF  *
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE  *
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                         *
 ****************************************************************************************/

/*
// Heightmap coverage
uniform sampler2D textureSamplerHeight00;
uniform sampler2D textureSamplerHeight10;
uniform sampler2D textureSamplerHeight01;
uniform sampler2D textureSamplerHeight11;
uniform mat3 uvTransformPatchToTileHeight00;
uniform mat3 uvTransformPatchToTileHeight10;
uniform mat3 uvTransformPatchToTileHeight01;
uniform mat3 uvTransformPatchToTileHeight11;
*/

// Colortexture coverage
uniform sampler2D textureSamplerColor00;
uniform sampler2D textureSamplerColor10;
uniform sampler2D textureSamplerColor01;
uniform sampler2D textureSamplerColor11;
uniform mat3 uvTransformPatchToTileColor00;
uniform mat3 uvTransformPatchToTileColor10;
uniform mat3 uvTransformPatchToTileColor01;
uniform mat3 uvTransformPatchToTileColor11;

//uniform int segmentsPerPatch;

in vec4 vs_position;
in vec3 fs_position;
in vec2 fs_uv;

#include "PowerScaling/powerScaling_fs.hglsl"
#include "fragment.glsl"

Fragment getFragment() {
	Fragment frag;

	frag.color = vec4(0);
	vec4 color00, color10, color01, color11;

	vec2 uv00 = vec2(uvTransformPatchToTileColor00 * vec3(fs_uv.s, fs_uv.t, 1));
	color00 = texture(textureSamplerColor00, uv00);

	vec2 uv10 = vec2(uvTransformPatchToTileColor10 * vec3(fs_uv.s, fs_uv.t, 1));
	color10 += texture(textureSamplerColor10, uv10);
	
	vec2 uv01 = vec2(uvTransformPatchToTileColor01 * vec3(fs_uv.s, fs_uv.t, 1));
	color01 += texture(textureSamplerColor01, uv01);
	
	vec2 uv11 = vec2(uvTransformPatchToTileColor11 * vec3(fs_uv.s, fs_uv.t, 1));
	color11 += texture(textureSamplerColor11, uv11);

	frag.color = max(color00, max(color10, max(color01, color11))) * 10;
	frag.color = vec4(frag.color.r, frag.color.r, frag.color.r, 1);

	frag.depth =  vs_position.w;

	return frag;
}

