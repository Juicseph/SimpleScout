import {
  Building2,
  Dumbbell,
  Flame,
  Hotel,
  Pill,
  ShoppingBasket,
  Soup,
  Stethoscope,
  Tv,
  UtensilsCrossed,
} from "lucide-react";
import { cn } from "@/lib/utils";
import type { PhotoTheme } from "@/models";

const THEME_CONFIG: Record<PhotoTheme, { gradient: string; Icon: typeof Hotel }> = {
  "hotel-lobby": { gradient: "from-brand-700 via-brand-600 to-brand-500", Icon: Hotel },
  "hotel-exterior": { gradient: "from-ink-900 via-brand-700 to-brand-500", Icon: Building2 },
  "restaurant-interior": { gradient: "from-amber-700 via-amber-600 to-amber-400", Icon: UtensilsCrossed },
  "quick-service": { gradient: "from-orange-600 via-amber-500 to-yellow-400", Icon: Soup },
  catering: { gradient: "from-rose-700 via-rose-600 to-orange-400", Icon: Flame },
  "sporting-goods": { gradient: "from-emerald-700 via-emerald-600 to-teal-400", Icon: Dumbbell },
  electronics: { gradient: "from-slate-800 via-slate-700 to-slate-500", Icon: Tv },
  pharmacy: { gradient: "from-sky-700 via-sky-600 to-cyan-400", Icon: Pill },
  grocery: { gradient: "from-lime-700 via-lime-600 to-green-400", Icon: ShoppingBasket },
  medical: { gradient: "from-red-700 via-red-600 to-rose-400", Icon: Stethoscope },
  venue: { gradient: "from-indigo-800 via-indigo-700 to-violet-500", Icon: Building2 },
};

export function PhotoTile({ theme, className }: { theme: PhotoTheme; className?: string }) {
  const config = THEME_CONFIG[theme];
  const Icon = config.Icon;
  return (
    <div
      className={cn(
        "relative flex items-center justify-center overflow-hidden bg-gradient-to-br",
        config.gradient,
        className
      )}
    >
      <Icon className="h-8 w-8 text-white/85" strokeWidth={1.75} />
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_left,rgba(255,255,255,0.18),transparent_55%)]" />
    </div>
  );
}
