import { Badge, type BadgeTone } from "@/components/ui/Badge";

const TAG_LABELS: Record<string, { label: string; tone: BadgeTone }> = {
  team_friendly: { label: "Team Friendly", tone: "brand" },
  bus_parking: { label: "Bus Parking", tone: "info" },
  staff_favorite: { label: "Staff Favorite", tone: "warning" },
  department_recommended: { label: "Department Recommended", tone: "success" },
  fast_team_meal: { label: "Fast Team Meal", tone: "info" },
  catering: { label: "Catering", tone: "neutral" },
  open_late: { label: "Open Late", tone: "neutral" },
  open_now: { label: "Open Now", tone: "success" },
  used_before: { label: "Used Before", tone: "brand" },
  private_dining: { label: "Private Dining", tone: "neutral" },
  large_group_friendly: { label: "Large Group Friendly", tone: "info" },
  value: { label: "Great Value", tone: "neutral" },
  fits_your_party: { label: "Fits Your Party", tone: "success" },
};

export function PlaceBadges({ tags, max = 3 }: { tags: string[]; max?: number }) {
  const visible = tags.slice(0, max).map((t) => TAG_LABELS[t]).filter(Boolean) as { label: string; tone: BadgeTone }[];
  if (visible.length === 0) return null;
  return (
    <div className="flex flex-wrap gap-1.5">
      {visible.map((tag) => (
        <Badge key={tag.label} tone={tag.tone}>
          {tag.label}
        </Badge>
      ))}
    </div>
  );
}
