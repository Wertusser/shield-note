import { useState } from "react";
import { useContractEvent } from "wagmi";
import { SHIELD_NOTE_CONTRACT_ADDRESS } from "../utils/constants";
import { ShieldNoteAbi } from "../fixtures";

export const useEvents = (eventsSize: number) => {
  const [contractEvents, setContractEvents] = useState<any[]>([]);

  const addContractEvent = (node: any) => {
    console.log("new event", node);
    setContractEvents([node, ...contractEvents.slice(0, eventsSize)]);
  };

  useContractEvent({
    address: SHIELD_NOTE_CONTRACT_ADDRESS,
    abi: ShieldNoteAbi,
    eventName: "RequestOrder",
    listener: addContractEvent,
  });
  useContractEvent({
    address: SHIELD_NOTE_CONTRACT_ADDRESS,
    abi: ShieldNoteAbi,
    eventName: "RedeemOrder",
    listener: addContractEvent,
  });
  useContractEvent({
    address: SHIELD_NOTE_CONTRACT_ADDRESS,
    abi: ShieldNoteAbi,
    eventName: "FulfillOrder",
    listener: addContractEvent,
  });

  return [contractEvents, setContractEvents];
};
