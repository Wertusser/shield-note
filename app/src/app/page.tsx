"use client";
import styled from "styled-components";
import { Column, Row } from "./styles";
import { useEvents } from "@/lib/hooks/use-events";
import { ConnectWallet } from "./components/connect-wallet";
import { useVerifierState } from "@/lib/hooks/use-verifier-state";
import { RequestForm } from "./components/request-form";
import { FulfillForm } from "./components/fulfill-form";

export const MainLayout = styled(Column)`
  background: #7d7d7d;
  padding: 0 24px;
  align-items: center;
`;

export const ContentLayout = styled(Row)`
  gap: 24px;
  flex-wrap: wrap;

  @media (max-width: 1100px) {
    width: min-content;
  }
`;

export const Header = styled(Row)`
  width: 100%;
  justify-content: space-between;
  align-items: center;
`;

export const EventsColumn = styled(Column)`
  padding: 24px;
  background-color: lightgreen;

  @media (max-width: 1100px) {
    width: 100%;
  }
`;

export const FormColumn = styled(Column)`
  gap: 24px;
  background-color: #203840;
  padding: 24px;

  @media (max-width: 1100px) {
    width: 100%;
  }
`;

export const FormBlock = styled(Column)`
  padding: 10px;
  border-radius: 10px;
  background-color: lightblue;
`;


export default function Home() {
  const [events] = useEvents(32);
  const [fulfillVerifier, redeemVerifier] = useVerifierState();

  return (
    <MainLayout>
      <Header>
        <h1>ShieldNote</h1>
        <ConnectWallet />
      </Header>
      <ContentLayout>
        <EventsColumn></EventsColumn>
        <FormColumn>
          <FormBlock>
            <RequestForm />
          </FormBlock>
          <FormBlock>
            <FulfillForm />
          </FormBlock>
        </FormColumn>
      </ContentLayout>
    </MainLayout>
  );
}
