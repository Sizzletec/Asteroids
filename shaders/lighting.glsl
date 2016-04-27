extern number numLights;
extern vec2 lightArray[4];

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
	vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
	int count = 0;
	lightArray;
	bool lit = false;
	while(count < numLights){

		vec2 ship = lightArray[count];

		float dist = distance(ship,screen_coords);

		  if(dist < 400){
		  	lit = true;
		  }
		count++;
	}

	if(!lit){
	  	pixel.r = pixel.r - 0.3;
		pixel.g = pixel.g - 0.3;
		pixel.b = pixel.b - 0.3;

	}
	return pixel;
}