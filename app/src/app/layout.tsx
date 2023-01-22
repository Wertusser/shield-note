"use client";
import StyledComponentsRegistry from "@/lib/utils/registry";
import { wagmiClient } from "@/lib/utils/wagmi-client";
import { WagmiConfig } from "wagmi";
import "./global.css";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      {/*
        <head /> will contain the components retured by the nearest parent
        head.tsx. Find out more at https://beta.nextjs.org/docs/api-reference/file-conventions/head
      */}
      <head />
      <body>
        <WagmiConfig client={wagmiClient}>
          <StyledComponentsRegistry>{children}</StyledComponentsRegistry>
        </WagmiConfig>
      </body>
    </html>
  );
}
