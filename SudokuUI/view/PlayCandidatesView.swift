//
//  CandidatesView.swift
//  SudokuDevHelper
//
//  Created by 徐珺炜 on 5/17/25.
//

import SwiftUI

struct PlayCandidatesView: View {
    private let inner_padding: CGFloat = 8
    @Bindable var candidates: RenderCandidates
    let size: CGFloat
    var body: some View {
//        let _ = print("PlayCandidatesView: Rerendering")
        VStack {
            let candidate_size = (size - inner_padding - inner_padding) / 3
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    PlayCandidateView(candidate: candidates.renderCandidates[0], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[1], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[2], size: candidate_size)
                }
                HStack(spacing: 1) {
                    PlayCandidateView(candidate: candidates.renderCandidates[3], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[4], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[5], size: candidate_size)
                }
                HStack(spacing: 1) {
                    PlayCandidateView(candidate: candidates.renderCandidates[6], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[7], size: candidate_size)
                    PlayCandidateView(candidate: candidates.renderCandidates[8], size: candidate_size)
                }
            }
            .padding(.all, inner_padding)
        }
        .frame(width: size, height: size)
    }
}

#Preview("Hide All") {
    PlayCandidatesView(candidates: RenderCandidates(), size: 64)
}

#Preview("Show All") {
    PlayCandidatesView(candidates: RenderCandidates(renderCandidates: [
        RenderCandidate(candidate: 1, isShown: true),
        RenderCandidate(candidate: 2, isShown: true),
        RenderCandidate(candidate: 3, isShown: true),
        RenderCandidate(candidate: 4, isShown: true),
        RenderCandidate(candidate: 5, isShown: true),
        RenderCandidate(candidate: 6, isShown: true),
        RenderCandidate(candidate: 7, isShown: true),
        RenderCandidate(candidate: 8, isShown: true),
        RenderCandidate(candidate: 9, isShown: true),
    ]), size: 64)
}

#Preview("Show Some") {
    PlayCandidatesView(candidates: RenderCandidates(renderCandidates: [
        RenderCandidate(candidate: 1, ),
        RenderCandidate(candidate: 2, isShown: true),
        RenderCandidate(candidate: 3, isShown: true),
        RenderCandidate(candidate: 4, ),
        RenderCandidate(candidate: 5, ),
        RenderCandidate(candidate: 6, isShown: true),
        RenderCandidate(candidate: 7, ),
        RenderCandidate(candidate: 8, ),
        RenderCandidate(candidate: 9, isShown: true),
    ]), size: 64)
}

#Preview("Show Some Highlighted") {
    PlayCandidatesView(candidates: RenderCandidates(renderCandidates: [
        RenderCandidate(candidate: 1, ),
        RenderCandidate(candidate: 2, isShown: true, highlightColor: Color.candidateCellInfo1),
        RenderCandidate(candidate: 3, isShown: true),
        RenderCandidate(candidate: 4, ),
        RenderCandidate(candidate: 5, ),
        RenderCandidate(candidate: 6, isShown: true),
        RenderCandidate(candidate: 7, ),
        RenderCandidate(candidate: 8, ),
        RenderCandidate(candidate: 9, isShown: true),
    ]), size: 64)
}
