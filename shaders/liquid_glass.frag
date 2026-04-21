#version 460 core
#include <flutter/runtime_effect.glsl>

// ---------------------------------------------------------------------------
// Liquid Glass — version "additive / non-destructive".
//
// Ce shader ne remplace PAS l'arrière plan : il produit uniquement
// les éléments lumineux du verre (highlight spéculaire + rim iridescent
// + teinte de réfraction très légère) à composer EN ADDITIF au dessus
// du fond déjà flouté par BackdropFilter.
//
// Pourquoi ? Un shader qui écrit une couleur opaque masquée par un
// rectangle crée la fameuse "coupure" noire quand son sampler renvoie
// du blanc/noir uni. Ici on sort une couleur prémultipliée avec alpha
// variable : 0 au centre (verre transparent) -> ~0.6 sur les bords
// (rim + highlight). Le BackdropFilter en dessous se voit à travers.
//
// Le path dessiné est une metaball Bézier passée depuis Dart via
// Paint.shader : on reçoit juste la bbox et on calcule un "pseudo SDF"
// elliptique pour l'iridescence. C'est volontaire : la forme réelle
// est donnée par le Path, pas par le shader, donc aucune géométrie
// rectangulaire ne fuite.
// ---------------------------------------------------------------------------

precision highp float;

uniform vec2  uSize;     // taille de la bbox de la bulle (px logiques)
uniform float uTime;     // temps (s)
uniform float uChroma;   // 0..1  intensité iridescence
uniform float uGlow;     // 0..1  intensité du rim lumineux

out vec4 fragColor;

void main() {
    vec2 fragXY = FlutterFragCoord().xy;
    vec2 uv     = fragXY / uSize;            // 0..1
    vec2 p      = uv * 2.0 - 1.0;            // -1..1 centré

    // Distance normalisée au centre, corrigée par le ratio -> ellipse douce.
    float r = length(p);

    // Hauteur de dôme (proche de 1 au centre, 0 au bord).
    float h = sqrt(max(0.0, 1.0 - r * r));

    // Normale du dôme en 2D pour rim et spéculaire.
    vec2 n = p * (1.0 - h);

    // --------------------------------------------------------------------
    // Highlight spéculaire doux en haut-gauche.
    // --------------------------------------------------------------------
    vec2  L    = normalize(vec2(-0.55, -0.8));
    float lam  = clamp(dot(normalize(n + 1e-4), L), 0.0, 1.0);
    float spec = pow(lam, 8.0) * smoothstep(0.1, 0.9, h);

    // --------------------------------------------------------------------
    // Rim iridescent : arc-en-ciel subtil qui voyage lentement.
    // --------------------------------------------------------------------
    float rim  = smoothstep(0.55, 1.0, r) * (1.0 - smoothstep(0.98, 1.02, r));
    float hue  = atan(p.y, p.x) / 6.2831853 + uTime * 0.08;
    vec3  iris = 0.5 + 0.5 * cos(6.2831853 * (vec3(0.00, 0.33, 0.67) + hue));
    vec3  rimCol = iris * rim * uChroma;

    // --------------------------------------------------------------------
    // Glow externe très doux (halo lumineux autour de la bulle).
    // --------------------------------------------------------------------
    float glow = smoothstep(1.0, 0.2, r) * 0.12 * uGlow;

    // --------------------------------------------------------------------
    // Teinte de verre interne — extrêmement légère, préserve la vue
    // sur le fond flouté.
    // --------------------------------------------------------------------
    vec3  glass  = vec3(1.0) * 0.05 * h;

    vec3  color  = glass + spec * vec3(1.0) + rimCol + vec3(glow);
    float alpha  = clamp(spec + max(max(rimCol.r, rimCol.g), rimCol.b)
                          + glow + 0.04 * h, 0.0, 1.0);

    // Couleur prémultipliée (Flutter attend du premul par défaut avec shader).
    fragColor = vec4(color * alpha, alpha);
}
