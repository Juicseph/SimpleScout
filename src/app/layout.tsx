import type { Metadata } from "next";
import "@/styles/globals.css";
import { NavBar } from "@/components/layout/NavBar";
import { BottomNav } from "@/components/layout/BottomNav";

export const metadata: Metadata = {
  title: "SimpleScout — College Athletics Travel",
  description: "The operating system for college athletics team travel.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-sand-50 pb-20 md:pb-0">
        <NavBar />
        {children}
        <BottomNav />
      </body>
    </html>
  );
}
