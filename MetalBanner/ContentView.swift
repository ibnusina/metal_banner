//
//  ContentView.swift
//  MetalBanner
//
//  Created by ibnu on 06/02/26.
//

import SwiftUI
import CachedAsyncImage
internal import Combine

struct ContentView: View {
    @State private var showingIdx = 0
    private let images = [
        "banner_1",
        "banner_2"
    ]
    
    @State private var currentDate = Date.now
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    
    /// The opacity of our preview view, so users can check how fading works.
    @State private var opacity = 1.0
    @State private var counter = 0

    var body: some View {
        VStack {
            Image(images[counter]).frame(height:200).padding()
                    .opacity(opacity)
                    .drawingGroup()
                    .transition(self.diamondWave(size: 20))
                    .onReceive(timer) { input in
                        withAnimation(.easeIn(duration: 1.5)) {
                            counter = (counter + 1) % images.count
                        }
                    }
                    
            
        }
        .toolbar {
            ToggleAlphaButton(opacity: $opacity)
        }
        .navigationSubtitle("Shader")
    }
    
    public func diamondWave(size: Double = 20) -> AnyTransition {
        .asymmetric(
            insertion: .modifier(
                active: DiamondWaveTransition(size: size, progress: 0),
                identity: DiamondWaveTransition(size: size, progress: 1)
            ),
            removal: .scale(scale: 1 + Double.ulpOfOne)
        )
    }
}

struct ToggleAlphaButton: View {
    @Binding var opacity: Double

    var body: some View {
        Button("Toggle Opacity", systemImage: "cube.transparent") {
            withAnimation {
                if opacity.isZero {
                    opacity = 1
                } else {
                    opacity = 0
                }
            }
        }
        .labelStyle(.titleAndIcon)
    }
}

#Preview {
    ContentView()
}

/// A transition where many diamonds grow upwards to reveal the new content,
/// with the diamonds moving outwards from the top-left edge.
@available(iOS 17, macOS 14, macCatalyst 17, tvOS 17, visionOS 1, *)
struct DiamondWaveTransition: ViewModifier {
    /// How big to make the diamonds.
    var size = 20.0

    /// How far we are through the transition: 0 is unstarted, and 1 is finished.
    var progress = 0.0

    func body(content: Content) -> some View {
        content
            .visualEffect { content, proxy in
                content
                    .colorEffect(
                        ShaderLibrary.diamondWaveTransition(
                            .float2(proxy.size),
                            .float(progress),
                            .float(size)
                        )
                    )
            }
    }
    
    
}
