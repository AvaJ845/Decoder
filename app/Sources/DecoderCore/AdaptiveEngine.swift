import Foundation

/// The seam for "what to serve next." Sprint 0 ships a simple rules-based version;
/// the interface is deliberately narrow so it can grow into a model-driven mastery
/// estimator later without touching the game (build doc §6).
public protocol AdaptiveEngine {
    /// Pick the next item from the pack, given the learner's current profile.
    func nextItem(from pack: ContentPack, profile: LearnerProfile) -> Item?

    /// Pick the next item, excluding items already cleared this session. Returns nil
    /// when nothing remains — that's what lets a session actually *complete* (no
    /// infinite loop, no progress overflow). A protocol requirement (not just an
    /// extension) so it dynamic-dispatches to the concrete engine.
    func nextItem(from pack: ContentPack, excluding cleared: Set<String>, profile: LearnerProfile) -> Item?
}

public extension AdaptiveEngine {
    // Default for conformers that don't implement exclusion (falls back to the
    // unfiltered pick). Concrete engines should override for real session bounding.
    func nextItem(from pack: ContentPack, excluding cleared: Set<String>, profile: LearnerProfile) -> Item? {
        nextItem(from: pack, profile: profile)
    }
}

/// v1: target the weakest skill first, easiest-band first within it.
public struct SimpleAdaptiveEngine: AdaptiveEngine {
    public init() {}

    public func nextItem(from pack: ContentPack, profile: LearnerProfile) -> Item? {
        select(from: pack.items, profile: profile)
    }

    public func nextItem(from pack: ContentPack, excluding cleared: Set<String>, profile: LearnerProfile) -> Item? {
        select(from: pack.items.filter { !cleared.contains($0.itemId) }, profile: profile)
    }

    /// The single selection rule, shared by both entry points.
    private func select(from items: [Item], profile: LearnerProfile) -> Item? {
        items.min { a, b in
            let ma = profile.state(for: a.skillId).mastery
            let mb = profile.state(for: b.skillId).mastery
            if ma != mb { return ma < mb }
            return a.difficultyBand < b.difficultyBand
        }
    }
}
