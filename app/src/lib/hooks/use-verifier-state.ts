import { useState } from "react";
import { useContractEvent, useContractRead } from "wagmi";
import { SHIELD_NOTE_CONTRACT_ADDRESS } from "../utils/constants";
import { ShieldNoteAbi } from "../fixtures";

export const useVerifierState = () => {
  const fulfillVerifier = useContractRead({
    address: SHIELD_NOTE_CONTRACT_ADDRESS,
    abi: ShieldNoteAbi,
    functionName: "fulfillVerifier",
  });
  const redeemVerifier = useContractRead({
    address: SHIELD_NOTE_CONTRACT_ADDRESS,
    abi: ShieldNoteAbi,
    functionName: "redeemVerifier",
  });

  return [fulfillVerifier, redeemVerifier];
};
