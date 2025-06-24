class WellnessData {
  final String userId;
  final String userName;
  final String userImage;
  final double liveWellScore;
  final Map<String, DimensionScore> dimensionScores;

  WellnessData({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.liveWellScore,
    required this.dimensionScores,
  });

  // Helper method to get dimension score
  double getDimensionScore(String dimensionId) {
    final dimensionScore = dimensionScores[dimensionId];
    return dimensionScore?.score ?? 0.0;
  }

  // Sample data for demo
  static WellnessData sampleData() {
    return WellnessData(
      userId: '1',
      userName: 'Ann Smith',
      userImage: 'https://via.placeholder.com/40',
      liveWellScore: 0.65,
      dimensionScores: {
        'physical': DimensionScore(
          dimensionId: 'physical', 
          score: 0.78, 
          insights: ['Regular exercise', 'Good sleep patterns'],
        ),
        'environmental': DimensionScore(
          dimensionId: 'environmental', 
          score: 0.62, 
          insights: ['Home organization', 'Moderate commute time'],
          subSections: [
            SubSection(
              id: 'exterior',
              name: 'EXTERIOR',
              issues: [
                Issue(
                  id: 'non_slip_surfaces',
                  title: 'Non-slip surfaces',
                  description: 'Recommended to apply a textured, anti-slip concrete sealant.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/non_slip_surface.png',
                ),
                Issue(
                  id: 'lighting_exterior',
                  title: 'Lighting',
                  description: 'Recommended to install motion-activated lighting along the walkway and driveway.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/exterior_lighting.png',
                ),
                Issue(
                  id: 'hand_rails',
                  title: 'Hand rails',
                  description: 'Recommended to install handrail to exterior foyer.',
                  status: IssueStatus.nonUrgent,
                  imageUrl: 'assets/images/hand_rails.png',
                ),
                Issue(
                  id: 'threshold',
                  title: 'Threshold',
                  description: 'Recommended to reduce the height of the exterior front door.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/threshold.png',
                ),
              ],
            ),
            SubSection(
              id: 'entry',
              name: 'ENTRY',
              issues: [
                Issue(
                  id: 'lighting_entry',
                  title: 'Lighting',
                  description: 'Recommended to install brighter lighting.',
                  status: IssueStatus.nonUrgent,
                  imageUrl: 'assets/images/entry_lighting.png',
                ),
                Issue(
                  id: 'non_slip_surfaces_entry',
                  title: 'Non-slip surfaces',
                  description: 'Entry tile needs to be slip-resistant.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/entry_flooring.png',
                ),
              ],
            ),
            SubSection(
              id: 'bathroom',
              name: 'BATHROOM',
              issues: [
                Issue(
                  id: 'grab_bars',
                  title: 'Grab bars',
                  // description: 'There are no grab bars in the bathroom, which increases the risk of slips and falls—especially when getting in and out of the shower or using the toilet.\n\nRecommendations\n\nInstall grab bars to improve safety and make daily routines easier:\n\n• Shower Entry: A vertical or angled grab bar just outside the shower to assist with balance when stepping in and out.\n\n• Inside Shower: A horizontal bar along the back wall for stability while standing or moving.\n\n• Toilet Area: A horizontal grab bar on the wall beside the toilet to assist with sitting and standing.\n\n• Installation: All grab bars should be securely anchored into wall studs or blocking—not just drywall—for maximum support.\n\n• Finish: Choose a textured or non-slip finish for better grip, especially with wet hands.',
                  description: 'There are no grab bars in the bathroom, which increases the risk of slips and falls—especially when getting in and out of the shower or using the toilet.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/grab_bars.png',
                ),
                Issue(
                  id: 'non_slip_surfaces_bathroom',
                  title: 'Non-slip surfaces',
                  // description: 'The current bathroom flooring and shower/tub surfaces are smooth and become slippery when wet. This increases the risk of slips and falls, especially for older adults or anyone with balance or mobility concerns.\n\nRecommendations\n\n• Install non-slip strips or coating in the tub/shower area to create immediate traction.\n\n• Consider replacing the bathroom floor tile with slip-resistant flooring, such as textured vinyl, rubber, or slip-rated tile.\n\n• In the meantime, use non-slip bath mats with rubber backing outside the tub and near the sink to reduce fall risk.',
                  description: 'The current bathroom flooring and shower/tub surfaces are smooth and become slippery when wet. This increases the risk of slips and falls, especially for older adults or anyone with balance or mobility concerns.',
                  status: IssueStatus.urgent,
                  imageUrl: 'assets/images/non_slip_surface_bathroom.png',
                ),
                Issue(
                  id: 'shower_controls',
                  title: 'Shower controls',
                  // description: 'The current shower has a twist-style knob that is positioned too low, which can be difficult to reach or turn—especially for someone with limited mobility or arthritis. There is also no handheld showerhead, which limits accessibility and ease of use.\n\nRecommendations\n\n• Replace the knob with a single-lever handle mounted at waist height for easier temperature control without bending or straining.\n\n• Install a handheld, detachable showerhead with an adjustable slide bar to make bathing safer and more comfortable, whether seated or standing.\n\n• Choose models with large, easy-to-use controls for added convenience.',
                  description: 'The current shower has a twist-style knob that is positioned too low, which can be difficult to reach or turn—especially for someone with limited mobility or arthritis. There is also no handheld showerhead, which limits accessibility and ease of use.',
                  status: IssueStatus.nonUrgent,
                  imageUrl: 'assets/images/shower_controls.png',
                ),
                Issue(
                  id: 'toilet_seat',
                  title: 'Toilet seat',
                  // description: 'The existing toilet is standard height, which can be difficult for someone with limited strength, balance, or mobility to sit down on or stand up from safely.\n\nRecommendations\n\n• Install a raised toilet seat to increase the height by 2-4 inches, making transfers easier and reducing strain on the knees and hips.\n\n• Choose a model that securely attaches to the existing toilet and includes armrests or side handles for added stability and support.\n\n• Consider a toilet safety frame for additional balance assistance if needed.',
                  description: 'The existing toilet is standard height, which can be difficult for someone with limited strength, balance, or mobility to sit down on or stand up from safely.',
                  status: IssueStatus.nonUrgent,
                  imageUrl: 'assets/images/toilet_seat.png',
                ),
              ],
            ),
          ],
        ),
        'social': DimensionScore(
          dimensionId: 'social', 
          score: 0.85, 
          insights: ['Strong family connections', 'Active social life'],
        ),
        'emotional': DimensionScore(
          dimensionId: 'emotional', 
          score: 0.72, 
          insights: ['Good stress management', 'Positive outlook'],
        ),
        'occupational': DimensionScore(
          dimensionId: 'occupational', 
          score: 0.55, 
          insights: ['Career satisfaction', 'Work-life balance needs improvement'],
        ),
        'intellectual': DimensionScore(
          dimensionId: 'intellectual', 
          score: 0.68, 
          insights: ['Regular learning', 'Creative hobbies'],
        ),
        'spiritual': DimensionScore(
          dimensionId: 'spiritual', 
          score: 0.60, 
          insights: ['Meditation practice', 'Connection to values'],
        ),
        'financial': DimensionScore(
          dimensionId: 'financial', 
          score: 0.42, 
          insights: ['Budget management', 'Savings goals in progress'],
        ),
      },
    );
  }
}

class DimensionScore {
  final String dimensionId;
  final double score;
  final List<String> insights;
  final List<SubSection> subSections;

  DimensionScore({
    required this.dimensionId,
    required this.score,
    required this.insights,
    this.subSections = const [],
  });
}

class SubSection {
  final String id;
  final String name;
  final List<Issue> issues;
  final bool isExpanded;

  SubSection({
    required this.id,
    required this.name,
    required this.issues,
    this.isExpanded = true, // Default to expanded
  });
}

class Issue {
  final String id;
  final String title;
  final String description;
  final IssueStatus status;
  final String? imageUrl;

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.imageUrl,
  });
}

enum IssueStatus {
  urgent,
  nonUrgent,
  passed
}