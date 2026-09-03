import type { University, Venue } from "@/models";

export const OHIO_STATE: University = {
  id: "univ_osu",
  name: "Ohio State University",
  slug: "ohio-state",
  city: "Columbus",
  state: "OH",
  location: { lat: 40.0067, lng: -83.0305 },
  primaryColor: "#a6192e",
  abbreviation: "OSU",
};

export const FRESNO_STATE: University = {
  id: "univ_fresno",
  name: "Fresno State",
  slug: "fresno-state",
  city: "Fresno",
  state: "CA",
  location: { lat: 36.8125, lng: -119.7462 },
  primaryColor: "#c41230",
  abbreviation: "FRES",
};

export const UCLA: University = {
  id: "univ_ucla",
  name: "UCLA",
  slug: "ucla",
  city: "Los Angeles",
  state: "CA",
  location: { lat: 34.0689, lng: -118.4452 },
  primaryColor: "#2774ae",
  abbreviation: "UCLA",
};

export const BOISE_STATE: University = {
  id: "univ_boise",
  name: "Boise State University",
  slug: "boise-state",
  city: "Boise",
  state: "ID",
  location: { lat: 43.6035, lng: -116.1996 },
  primaryColor: "#0033a0",
  abbreviation: "BSU",
};

export const STANFORD: University = {
  id: "univ_stanford",
  name: "Stanford University",
  slug: "stanford",
  city: "Stanford",
  state: "CA",
  location: { lat: 37.4275, lng: -122.1697 },
  primaryColor: "#8c1515",
  abbreviation: "STAN",
};

export const UNIVERSITIES: University[] = [OHIO_STATE, FRESNO_STATE, UCLA, BOISE_STATE, STANFORD];

export const COVELLI_CENTER: Venue = {
  id: "venue_covelli",
  universityId: OHIO_STATE.id,
  name: "Covelli Center",
  sport: "volleyball",
  location: { lat: 40.0093, lng: -83.0225 },
};

export const VENUES: Venue[] = [COVELLI_CENTER];

export function findUniversityBySlug(slug: string): University | undefined {
  return UNIVERSITIES.find((u) => u.slug === slug);
}

export function getVenueById(id: string): Venue | undefined {
  return VENUES.find((v) => v.id === id);
}

export function searchUniversities(query: string): University[] {
  const q = query.trim().toLowerCase();
  if (!q) return UNIVERSITIES;
  return UNIVERSITIES.filter(
    (u) =>
      u.name.toLowerCase().includes(q) ||
      u.city.toLowerCase().includes(q) ||
      u.abbreviation.toLowerCase().includes(q)
  );
}
