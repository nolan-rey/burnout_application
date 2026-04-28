#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform vec2 u_offset;    
uniform float u_time;     

out vec4 fragColor;

// Palette iridescente (génère des couleurs en fonction du temps et de la position)
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.33, 0.67);
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (fragCoord - u_offset) / u_resolution;
    vec2 pos = uv * 2.0 - 1.0;
    
    // Distance mathématique (la coupure réelle de forme est faite par Flutter drawRRect)
    // On l'utilise uniquement pour l'éclairage.
    float dist = length(pos);
    float safeDist = min(dist, 1.0);
    
    // Calcul de la normale pour effet 3D pseudo-goutte
    float z = sqrt(1.0 - safeDist * safeDist);
    vec3 normal = normalize(vec3(pos.x, pos.y, z * 0.4)); // Z plus bas = rendu plus plat/visqueux
    
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    
    // Mouvement organique de la source de lumière
    vec3 lightPos = normalize(vec3(
        -0.4 + sin(u_time * 1.5) * 0.1, 
        -0.4 + cos(u_time * 1.2) * 0.1, 
        1.2
    ));
    
    // Reflet spéculaire puissant (le point brillant)
    vec3 halfVector = normalize(lightPos + viewDir);
    float specular = pow(max(dot(normal, halfVector), 0.0), 32.0);
    
    // Effet Fresnel sur les rebords extérieurs de la capsule
    float fresnel = pow(1.0 - max(dot(normal, viewDir), 0.0), 2.5);
    
    // Iridescence algorithmique sur les bords de la goutte
    vec3 colorEdge = palette(dist * 0.5 - u_time * 0.3);
    vec3 iridescence = colorEdge * fresnel * 1.5;
    
    // Base de la goutte (très subtile translucide)
    vec3 glassColor = vec3(0.85, 0.9, 1.0) * 0.05;
    
    // Couleur Finale
    vec3 finalColor = glassColor + iridescence + (vec3(1.0) * specular);
    
    // Transparence au centre, bord coloré fort + reflet pur blanc
    float alpha = mix(0.05, 0.7, fresnel) + specular;
    alpha = clamp(alpha, 0.0, 1.0);
    
    // On ne coupe aucun pixel à dist > 1.0 ! 
    // Cela corrige le carré noir intrusif. La forme finale sera découpée 
    // par l'API vectorielle de Flutter RRect.
    
    fragColor = vec4(finalColor * alpha, alpha);
}
