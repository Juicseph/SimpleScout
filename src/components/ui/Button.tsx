import { cn } from "@/lib/utils";

type ButtonVariant = "primary" | "secondary" | "ghost" | "outline";
type ButtonSize = "sm" | "md" | "lg";

const VARIANT_CLASSES: Record<ButtonVariant, string> = {
  primary: "bg-ink-950 text-white hover:bg-ink-900",
  secondary: "bg-sand-200 text-ink-950 hover:bg-sand-300",
  ghost: "bg-transparent text-ink-950 hover:bg-sand-200",
  outline: "bg-white text-ink-950 border border-sand-300 hover:border-ink-700",
};

const SIZE_CLASSES: Record<ButtonSize, string> = {
  sm: "text-sm px-3 py-1.5 rounded-full",
  md: "text-sm px-4 py-2.5 rounded-full",
  lg: "text-base px-6 py-3.5 rounded-full",
};

export function Button({
  children,
  variant = "primary",
  size = "md",
  className,
  ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: ButtonVariant; size?: ButtonSize }) {
  return (
    <button
      className={cn(
        "inline-flex items-center justify-center gap-2 font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50",
        VARIANT_CLASSES[variant],
        SIZE_CLASSES[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}
