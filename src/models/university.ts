export interface LatLng {
  lat: number;
  lng: number;
}

export interface University {
  id: string;
  name: string;
  slug: string;
  city: string;
  state: string;
  location: LatLng;
  primaryColor: string;
  abbreviation: string;
}

export interface Venue {
  id: string;
  universityId: string;
  name: string;
  sport?: string;
  location: LatLng;
}
