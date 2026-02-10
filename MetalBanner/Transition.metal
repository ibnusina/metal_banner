//
//  Transition.metal
//  MetalBanner
//
//  Created by ibnu on 06/02/26.
//

#include <metal_stdlib>
using namespace metal;


[[ stitchable ]] half4 diamondWaveTransition(float2 position, half4 color, float2 size, float amount, float diamondSize) {
    // Calculate our coordinate in UV space, 0 to 1.
    half2 uv = half2(1.0 - (position / size));

    // Figure out our position relative to the nearest
    // diamond.
    half2 f = half2(fract(position / diamondSize));

    // Calculate the Manhattan distance from our pixel to
    // the center of the nearest diamond.
    half d = abs(f.x - 0.5h) + abs(f.y - 0.5h);

    // If the transition has progressed beyond our distance,
    // factoring in our X/Y UV coordinate…
    if (d + uv.x + uv.y < amount * 3.0) {
        // Send back the color
        return color;
    } else {
        // Otherwise send back clear.
        return half4(0.0h);
    }
}


