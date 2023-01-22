import { initialize } from "zokrates-js";
import Web3 from "web3";

const web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

const requestOrder = async (preimage: string, sender: BigNumber[]): Promise<void> => {

};


const fulfillOrder = async (input: string, preimage: string): Promise<void> => {

};
