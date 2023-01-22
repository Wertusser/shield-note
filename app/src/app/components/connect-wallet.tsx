import { useAccount, useBalance, useConnect, useEnsName } from "wagmi";
import { InjectedConnector } from "wagmi/connectors/injected";

export const ConnectWallet = () => {
  const { address, isConnected } = useAccount();
  const { data: balance } = useBalance({ address });
  const { data: ensName } = useEnsName({ address });
  const { connect } = useConnect({
    connector: new InjectedConnector(),
  });

  if (isConnected)
    return (
      <div>
        <span>Connected to {ensName ?? address?.slice(0, 8)}</span>
        <br />
        <span>Balance: {String(balance?.value)}</span>
      </div>
    );
  return <button onClick={() => connect()}>Connect Wallet</button>;
};
