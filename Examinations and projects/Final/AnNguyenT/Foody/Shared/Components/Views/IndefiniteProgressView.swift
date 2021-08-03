//
//  SwiftUIView.swift
//  Foody
//
//  Created by MBA0283F on 3/19/21.
//

import SwiftUI

struct IndefiniteProgressView: View {
  @ScaledMetric(relativeTo: .headline) private var iconSize: CGFloat = 36
  @ScaledMetric(relativeTo: .headline) private var strokeSize: CGFloat = 3
  @ScaledMetric(relativeTo: .headline) private var paddingSize: CGFloat = 20
  @ScaledMetric(relativeTo: .headline) private var cornerSize: CGFloat = 9

  @State private var isAnimating: Bool = false

  #if os(iOS) || os(tvOS)
  private let labelColor = Color(.label)
  #endif
  private let backgroundColor = Color(.secondarySystemBackground)

  #if os(macOS)
  private let labelColor = Color(.labelColor)
  #endif

  var body: some View {
    VStack {
      Circle()
        .trim(from: 0.02, to: 0.98)
        .stroke(
          AngularGradient(
            gradient: Gradient(colors: [backgroundColor, labelColor]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
          ),
          style: StrokeStyle(lineWidth: strokeSize, lineCap: .round, lineJoin: .round)
        )
        .frame(width: iconSize, height: iconSize)
        .rotationEffect(.degrees(-90))
        .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
        .animation(
          isAnimating
            ? Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
            : nil
        )
        .onAppear {
          DispatchQueue.main.async {
            isAnimating = true
          }
        }
        .onDisappear {
          isAnimating = false
        }
    }
    .padding(paddingSize)
    .cornerRadius(cornerSize)
    .background(backgroundColor.edgesIgnoringSafeArea(.all))
    .cornerRadius(20)
  }
}



struct IndefiniteProgressView_Previews: PreviewProvider {
    static var previews: some View {
        IndefiniteProgressView()
    }
}
