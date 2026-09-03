export type VisibilityLevel = "personal" | "team" | "department" | "network";

export interface AthleticsReview {
  id: string;
  placeId: string;
  authorName: string;
  authorRole: string;
  teamName: string;
  visibility: VisibilityLevel;
  overallRating: number; // 1-5
  categoryRatings: Record<string, number>;
  body?: string;
  createdAt: string;
}

export interface PublicReview {
  id: string;
  placeId: string;
  authorName?: string;
  rating: number;
  body?: string;
}

export interface StaffNote {
  id: string;
  placeId: string;
  authorName: string;
  authorRole: string;
  teamName?: string;
  visibility: VisibilityLevel;
  body: string;
  createdAt: string;
}

export interface TeamVisit {
  id: string;
  placeId: string;
  teamName: string;
  sport: string;
  visitedOn: string; // ISO date, display as "September 2025"
}

export interface DepartmentVisitSummary {
  placeId: string;
  visitCount: number;
  lastVisitedOn?: string;
  visits: TeamVisit[];
}

export interface NetworkRecommendationSummary {
  placeId: string;
  teamsUsedCount: number;
  recommendCount: number;
  commonNotes: string[];
}

/** Composed, read-time aggregation — see docs/ARCHITECTURE.md §8. */
export interface KnowledgeSummary {
  athleticsRating?: number;
  athleticsReviewCount: number;
  departmentVisits?: DepartmentVisitSummary;
  topNotes: StaffNote[];
  networkSignal?: NetworkRecommendationSummary;
}
