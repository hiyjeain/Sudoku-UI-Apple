//
//  CellView.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 2/27/25.
//

import SwiftUI

struct PlayCandidateView: View {
    @ObservedObject var candidate: RenderCandidate
    let size: CGFloat

    var body: some View {
//        let _ = print("PlayCandidateView(\(candidate.candidate): Rerendering")
        ZStack {
            if let backgroundColor = candidate.highlightColor {
                Rectangle()
                    .fill(backgroundColor)
            }
                
            if candidate.isShown {
                // Display the value
                Text("\(candidate.candidate)")
                    .foregroundColor(candidate.candidateTextColor)
                    .font(.system(size: size * 0.618))
                    .fontWeight(.bold)
            }
        }
        .frame(width: size, height: size)
        .border(candidate.highlightColor != nil ? candidate.candidateCellBorderColor : Color.white.opacity(0.0), width: 1)
    }
}


#Preview("Shown Candidate", traits: .sizeThatFitsLayout) {
    PlayCandidateView(candidate: RenderCandidate(candidate: 1, isShown: true), size: 35)
}

#Preview("Hidden Candidate", traits: .sizeThatFitsLayout) {
    PlayCandidateView(candidate: RenderCandidate(candidate: 1, isShown: false), size: 35)
}

#Preview("Shown Candidate with Highlight", traits: .sizeThatFitsLayout) {
    PlayCandidateView(candidate: RenderCandidate(
        candidate: 1,
        isShown: true,
        highlightColor: Color.candidateCellInfo1),
                      size: 35)
}
