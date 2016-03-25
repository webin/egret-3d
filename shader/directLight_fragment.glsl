const int max_directLight = 0 ;
uniform float uniform_directLightSource[11*max_directLight] ;

struct DirectLight{
    vec3 direction;
	vec3 diffuse;
	vec3 halfColor;
    float intensity;
    float halfIntensity;
};

vec4 light ;

float phongSpecular(vec3 lightDirection,vec3 viewDirection,vec3 surfaceNormal,float shininess) {
  vec3 R = -reflect(lightDirection, surfaceNormal);
  return pow(max(0.0, dot(viewDirection, R)), shininess);
}

vec3 flatNormal(vec3 pos){
    vec3 fdx = -dFdx(pos);
    vec3 fdy = dFdy(pos);
    return normalize(cross(fdx, fdy));
}

void calculateDirectLight( MaterialSource materialSource ){
	float specularfract,NdotL ; 
    vec3 vReflect,ldir,ndir,N;
    //N = flatNormal(varying_pos.xyz);
    N = normalize(normal.xyz);
    for(int i = 0 ; i < max_directLight ; i++){ 
		  DirectLight L ; 
		  L.direction = vec3(uniform_directLightSource[i*10+0],uniform_directLightSource[i*10+1],uniform_directLightSource[i*10+2]); 
		  L.diffuse = vec3(uniform_directLightSource[i*10+3],uniform_directLightSource[i*10+4],uniform_directLightSource[i*10+5]); 
		  L.halfColor = vec3(uniform_directLightSource[i*10+6],uniform_directLightSource[i*10+7],uniform_directLightSource[i*10+8]); 
		  L.intensity = uniform_directLightSource[i*7+9]; 
		  L.halfIntensity = uniform_directLightSource[i*7+10]; 
      
		  ambient.xyz *= L.diffuse.xyz ;
		  ldir = L.direction ;       
		  ndir = normalize(L.direction) ; 
		  NdotL = clamp(dot( N , ndir ),0.0,1.0);

		  float lambertTerm = NdotL* L.intensity ; 
		  light.xyz += L.diffuse * lambertTerm ; 
      
		  float halfLambertTerm = clamp(dot(N,-ldir),0.0,1.0); 
		  light.xyz += ( halfLambertTerm * L.halfColor * 0.25 + L.halfColor * 0.25 ) * L.halfIntensity; 
		  specular.xyz += L.diffuse * phongSpecular(ndir,normalize(varying_eyedir),N,materialSource.shininess) ;	
    }; 
}


 
void main() {
	calculateDirectLight( materialSource );
}
