import { WagmiConfig, createClient, configureChains, mainnet } from "wagmi";
import { jsonRpcProvider } from "wagmi/providers/jsonRpc";

const { chains, provider, webSocketProvider } = configureChains(
  [mainnet],
  [
    jsonRpcProvider({
      rpc: (chain) => ({
        http: `http://localhost:8545`,
      }),
    }),
  ]
);

export const wagmiClient = createClient({
  autoConnect: true,
  provider,
  webSocketProvider,
});
