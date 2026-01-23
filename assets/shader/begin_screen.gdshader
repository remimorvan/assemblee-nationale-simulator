shader_type canvas_item;

const float ratio = 1908./960.;
uniform float alpha:hint_range(0.0, 1.0, 0.1);
uniform sampler2D tex1;
uniform sampler2D tex2;
uniform sampler2D tex3;
uniform sampler2D tex4;
uniform sampler2D tex5;
uniform sampler2D tex6;
const float size = 15.;

void vertex() {
	// Called for every vertex the material is visible on.
}

bool around_integer(float x, float eps) {
	float close_integer = ceil(x-0.5);
	return abs(x-float(close_integer)) < eps;
}

void fragment() {
	vec2 pos = vec2(UV.x, UV.y/ratio);
	pos -= vec2(0.,TIME)/50.;
	float picture_size = 1./size;
	float x = floor(pos.x/picture_size);
	float y = floor(pos.y/picture_size);
	vec2 tex_coords = vec2(mod(pos.x,picture_size),mod(pos.y,picture_size))/picture_size*1.5;
	float n = x + y * size;
	float color = mod(n, 6.);
	
	if (tex_coords.x >= 1. || tex_coords.y >= 1.) {
		COLOR = vec4(0.);
	} else if (color < 1.) {
		COLOR.rgb = texture(tex1, tex_coords).rgb;
		COLOR.a = min(texture(tex1, tex_coords).a, alpha);
	} else if (color < 2.) {
		COLOR = texture(tex2, tex_coords);
		COLOR.a = min(texture(tex2, tex_coords).a, alpha);
	} else if (color < 3.) {
		COLOR = texture(tex3, tex_coords);
		COLOR.a = min(texture(tex3, tex_coords).a, alpha);
	} else if (color < 4.) {
		COLOR = texture(tex4, tex_coords);
		COLOR.a = min(texture(tex4, tex_coords).a, alpha);
	} else if (color < 5.) {
		COLOR = texture(tex5, tex_coords);
		COLOR.a = min(texture(tex5, tex_coords).a, alpha);
	} else {
		COLOR = texture(tex6, tex_coords);
		COLOR.a = min(texture(tex6, tex_coords).a, alpha);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
