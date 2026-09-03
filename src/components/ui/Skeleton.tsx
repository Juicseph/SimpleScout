export function PlaceCardSkeleton() {
  return (
    <div className="overflow-hidden rounded-xl2 border border-sand-200 bg-white shadow-card">
      <div className="h-40 w-full animate-pulse bg-sand-200" />
      <div className="space-y-3 p-4">
        <div className="h-4 w-2/3 animate-pulse rounded bg-sand-200" />
        <div className="h-3 w-1/3 animate-pulse rounded bg-sand-200" />
        <div className="h-3 w-full animate-pulse rounded bg-sand-200" />
        <div className="h-8 w-full animate-pulse rounded-xl bg-sand-100" />
      </div>
    </div>
  );
}
