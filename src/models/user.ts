export type TeamRole =
  | "director_of_ops"
  | "head_coach"
  | "assistant_coach"
  | "athletic_trainer"
  | "equipment_manager"
  | "sports_information"
  | "admin";

export type Sport =
  | "volleyball"
  | "basketball"
  | "football"
  | "soccer"
  | "baseball"
  | "softball"
  | "track_and_field"
  | "swimming"
  | "tennis"
  | "golf"
  | "wrestling"
  | "other";

export interface User {
  id: string;
  fullName: string;
  email: string;
  avatarUrl?: string;
}

export interface Team {
  id: string;
  athleticDepartmentId: string;
  name: string;
  sport: Sport;
}

export interface AthleticDepartment {
  id: string;
  universityId: string;
  name: string;
  networkParticipation: boolean;
}

export interface TeamMembership {
  userId: string;
  teamId: string;
  role: TeamRole;
}
