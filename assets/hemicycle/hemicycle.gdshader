shader_type canvas_item;
const int WIDTH = 19;
const int HEIGHT = 13;
const vec2 cycle_center = vec2(0.5,1.7);

uniform vec3 color_values[WIDTH*HEIGHT];

void vertex() {
	// Called for every vertex the material is visible on.
}

bool around_integer(float x, float eps) {
	float close_integer = ceil(x-0.5);
	return abs(x-float(close_integer)) < eps;
}

void fragment() {
	COLOR = vec4(1.,1.,1.,1.);

	vec2 diff = UV - cycle_center;
	float angle = atan(diff.y, diff.x);
	float r = length(diff)/0.5;

	float projectedy = r-2.;
	float projectedx = ((angle/PI + 1.)/2. - 0.2)/0.1;

	int celly = int(projectedy*float(HEIGHT));

	if (celly%2 == 1)
	{
		projectedx -= 0.5/float(WIDTH);
	}

	int cellx = int(projectedx*float(WIDTH));

	if (projectedx>=0. && projectedy>=0. && projectedy<=1. && projectedx<=1.)
	{
		COLOR = vec4(color_values[celly+HEIGHT*cellx],1.0);
	}

	if (projectedx>=-0.01/float(WIDTH) && projectedy>=-0.02/float(HEIGHT) &&
		projectedy<=1.+0.01/float(WIDTH) && projectedx<=1.+0.02/float(HEIGHT) &&
		(around_integer(projectedx*float(WIDTH),0.01) || around_integer(r*float(HEIGHT),0.02)))
	{
		COLOR = vec4((vec3(0.,0.,0.)+ 4.*color_values[celly+HEIGHT*cellx])/5.,1.);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
