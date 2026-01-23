shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

const vec3 yellow = vec3(0.99609375, 0.89453125, 0.41015625);
const float nb_rays = 10.;

void fragment() {
	// set origin at center screen
	vec2 pos = 2.*UV - vec2(1.,1.);
	float r = length(pos);
	float angle = atan(pos.y,pos.x);	// between -PI and PI
	angle = (angle/PI + 1.)/2.;
	angle += TIME/30.;
	angle = mod(angle, 1.);
	COLOR = vec4(0.);
	if (mod(angle*nb_rays*2.,2.) < 1.)
	{
		float alpha = clamp(1.7-2.*r,0.,1.);
		vec3 col = mix(yellow,vec3(1.),2.2*r-1.2);
		COLOR = vec4(col, alpha);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
