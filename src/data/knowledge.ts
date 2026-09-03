import type { KnowledgeSummary, StaffNote, TeamVisit } from "@/models";

const marriottVisits: TeamVisit[] = [
  { id: "visit_1", placeId: "place_marriott_columbus", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2024-03-08" },
  { id: "visit_2", placeId: "place_marriott_columbus", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2025-02-14" },
  { id: "visit_3", placeId: "place_marriott_columbus", teamName: "Softball", sport: "softball", visitedOn: "2026-03-21" },
];

const marriottNotes: StaffNote[] = [
  {
    id: "note_1",
    placeId: "place_marriott_columbus",
    authorName: "Jamie Ortega",
    authorRole: "Director of Operations",
    teamName: "Women's Basketball",
    visibility: "department",
    body: "Easy bus parking behind the hotel — plan to arrive from the north entrance.",
    createdAt: "2025-02-16",
  },
  {
    id: "note_2",
    placeId: "place_marriott_columbus",
    authorName: "Sam Delgado",
    authorRole: "Director of Operations",
    teamName: "Softball",
    visibility: "department",
    body: "They opened breakfast at 6:00 AM specifically for us with advance notice.",
    createdAt: "2026-03-23",
  },
  {
    id: "note_3",
    placeId: "place_marriott_columbus",
    authorName: "Jamie Ortega",
    authorRole: "Director of Operations",
    teamName: "Women's Basketball",
    visibility: "department",
    body: "Ask for rooms on floors 3 and 4 — quietest and closest to the elevator bank.",
    createdAt: "2025-02-16",
  },
];

const hydeParkNotes: StaffNote[] = [
  {
    id: "note_4",
    placeId: "place_hyde_park_steakhouse",
    authorName: "Jamie Ortega",
    authorRole: "Director of Operations",
    teamName: "Women's Basketball",
    visibility: "department",
    body: "Private room upstairs fit our full traveling party with room to spare for film setup.",
    createdAt: "2025-02-15",
  },
];

const chipotleNotes: StaffNote[] = [
  {
    id: "note_5",
    placeId: "place_chipotle_lane",
    authorName: "Priya Shah",
    authorRole: "Equipment Manager",
    teamName: "Women's Volleyball",
    visibility: "team",
    body: "Call ahead 45 minutes for a 25+ person order — they'll have it bagged and labeled by player.",
    createdAt: "2025-09-10",
  },
];

const KNOWLEDGE: Record<string, KnowledgeSummary> = {
  place_marriott_columbus: {
    athleticsRating: 4.9,
    athleticsReviewCount: 6,
    departmentVisits: {
      placeId: "place_marriott_columbus",
      visitCount: 4,
      lastVisitedOn: "2026-03-21",
      visits: marriottVisits,
    },
    topNotes: marriottNotes,
    networkSignal: {
      placeId: "place_marriott_columbus",
      teamsUsedCount: 12,
      recommendCount: 11,
      commonNotes: ["Excellent bus parking", "Early breakfast available", "Large meeting room"],
    },
  },
  place_hyde_park_steakhouse: {
    athleticsRating: 4.8,
    athleticsReviewCount: 3,
    departmentVisits: {
      placeId: "place_hyde_park_steakhouse",
      visitCount: 1,
      lastVisitedOn: "2025-02-15",
      visits: [
        { id: "visit_4", placeId: "place_hyde_park_steakhouse", teamName: "Women's Basketball", sport: "basketball", visitedOn: "2025-02-15" },
      ],
    },
    topNotes: hydeParkNotes,
  },
  place_chipotle_lane: {
    athleticsRating: 4.6,
    athleticsReviewCount: 4,
    departmentVisits: {
      placeId: "place_chipotle_lane",
      visitCount: 2,
      lastVisitedOn: "2025-09-10",
      visits: [
        { id: "visit_5", placeId: "place_chipotle_lane", teamName: "Women's Volleyball", sport: "volleyball", visitedOn: "2025-09-10" },
        { id: "visit_6", placeId: "place_chipotle_lane", teamName: "Softball", sport: "softball", visitedOn: "2026-03-22" },
      ],
    },
    topNotes: chipotleNotes,
  },
  place_cameron_mitchell_catering: {
    athleticsRating: 4.9,
    athleticsReviewCount: 2,
    topNotes: [
      {
        id: "note_6",
        placeId: "place_cameron_mitchell_catering",
        authorName: "Sam Delgado",
        authorRole: "Director of Operations",
        teamName: "Softball",
        visibility: "department",
        body: "Boxed postgame meals were ready 15 minutes early and held hot.",
        createdAt: "2026-03-21",
      },
    ],
  },
};

export function getKnowledgeForPlace(placeId: string): KnowledgeSummary | undefined {
  return KNOWLEDGE[placeId];
}

export function knowledgeMap(): Map<string, KnowledgeSummary> {
  return new Map(Object.entries(KNOWLEDGE));
}
