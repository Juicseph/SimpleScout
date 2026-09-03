import type { Place } from "@/models";

function Fact({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <div>
      <dt className="text-[11.5px] font-semibold uppercase tracking-wide text-ink-500">{label}</dt>
      <dd className="mt-0.5 text-[13.5px] font-medium text-ink-950">{value}</dd>
    </div>
  );
}

function overviewFacts(place: Place): { label: string; value: React.ReactNode }[] {
  const facts: { label: string; value: React.ReactNode }[] = [
    { label: "Category", value: place.category.replace("_", " ") },
  ];
  if (place.external.priceLevel != null) {
    facts.push({ label: "Price", value: "$".repeat(place.external.priceLevel + 1) });
  }
  if (place.external.hoursToday) {
    const hours = place.external.hoursToday;
    facts.push({
      label: "Hours today",
      value: hours === "open_24h" ? "Open 24 hours" : hours === "closed" ? "Closed" : `${hours.opens} – ${hours.closes}`,
    });
  }
  if (place.hotel) facts.push({ label: "Rooms", value: place.hotel.totalRooms ?? "—" });
  if (place.restaurant) facts.push({ label: "Cuisine", value: place.restaurant.cuisine });
  if (place.caterer) {
    facts.push({ label: "Min order", value: place.caterer.minOrderCount ?? "—" });
    facts.push({ label: "Lead time", value: place.caterer.leadTimeHours ? `${place.caterer.leadTimeHours}h` : "—" });
    if (place.caterer.estimatedCostPerPerson) {
      facts.push({ label: "Est. cost / person", value: `$${place.caterer.estimatedCostPerPerson.toFixed(0)}` });
    }
  }
  return facts;
}

function teamInfoFacts(place: Place): { label: string; value: React.ReactNode }[] {
  const a = place.athletics;
  const facts: { label: string; value: React.ReactNode }[] = [];
  if (a.busParking != null) facts.push({ label: "Bus parking", value: a.busParking ? "Yes" : "No" });
  if (a.maxRecommendedGroup) facts.push({ label: "Max recommended group", value: a.maxRecommendedGroup });
  if (a.hasPrivateDining != null) facts.push({ label: "Private dining", value: a.hasPrivateDining ? "Yes" : "No" });
  if (a.hasMeetingSpace != null) facts.push({ label: "Meeting space", value: a.hasMeetingSpace ? "Yes" : "No" });
  if (a.earlyBreakfastAvailable != null) {
    facts.push({ label: "Early breakfast", value: a.earlyBreakfastAvailable ? "Available on request" : "No" });
  }
  if (a.laundryAvailable != null) facts.push({ label: "Laundry", value: a.laundryAvailable ? "Yes" : "No" });
  if (a.deliveryAvailable != null) facts.push({ label: "Delivery", value: a.deliveryAvailable ? "Yes" : "No" });
  if (a.cateringAvailable != null) facts.push({ label: "Catering", value: a.cateringAvailable ? "Yes" : "No" });
  if (a.dietaryOptions && a.dietaryOptions.length > 0) {
    facts.push({ label: "Dietary options", value: a.dietaryOptions.join(", ") });
  }
  return facts;
}

export function PlaceFacts({ place }: { place: Place }) {
  const overview = overviewFacts(place);
  const teamInfo = teamInfoFacts(place);

  return (
    <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
      <section className="rounded-xl2 border border-sand-200 bg-white p-5">
        <h2 className="mb-3 text-[15px] font-bold text-ink-950">Overview</h2>
        <dl className="grid grid-cols-2 gap-4">
          {overview.map((f) => (
            <Fact key={f.label} label={f.label} value={f.value} />
          ))}
        </dl>
      </section>

      {teamInfo.length > 0 && (
        <section className="rounded-xl2 border border-sand-200 bg-white p-5">
          <h2 className="mb-3 text-[15px] font-bold text-ink-950">Team Info</h2>
          <dl className="grid grid-cols-2 gap-4">
            {teamInfo.map((f) => (
              <Fact key={f.label} label={f.label} value={f.value} />
            ))}
          </dl>
          {place.athletics.groupSalesContact && (
            <p className="mt-4 border-t border-sand-200 pt-3 text-[12.5px] text-ink-500">
              Group contact: <span className="font-medium text-ink-950">{place.athletics.groupSalesContact.name}</span>{" "}
              ({place.athletics.groupSalesContact.role})
            </p>
          )}
        </section>
      )}
    </div>
  );
}
