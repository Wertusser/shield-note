// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

contract CompileCircuitsScript is Script {
    function setUp() public {}

    function clearTemporary() public {
        string[] memory rmInputs = new string[](3);
        rmInputs[0] = "rm";
        rmInputs[1] = "-rf";
        rmInputs[2] = "tmp";

        vm.ffi(rmInputs);

        string[] memory mkdirInputs = new string[](2);
        mkdirInputs[0] = "mkdir";
        mkdirInputs[1] = "tmp";

        vm.ffi(mkdirInputs);
    }

    function universalSetup() public {
        string[] memory inputs = new string[](8);
        inputs[0] = "zokrates";
        inputs[1] = "universal-setup";
        inputs[2] = "-u";
        inputs[3] = "tmp/universal_setup.dat";
        inputs[4] = "-s";
        inputs[5] = "marlin";
        inputs[6] = "-n";
        inputs[7] = "16";

        bytes memory res = vm.ffi(inputs);
        console2.log(string(res));
    }

    function compileCircuit(string memory name) public {
        string[] memory inputs = new string[](10);
        inputs[0] = "zokrates";
        inputs[1] = "compile";
        inputs[2] = "-i";
        inputs[3] = string.concat(string.concat("circuits/", name), ".zok");
        inputs[4] = "-o";
        inputs[5] = string.concat(string.concat("tmp/", name), "_out");
        inputs[6] = "--r1cs";
        inputs[7] = string.concat(string.concat("tmp/", name), "_out.r1cs");
        inputs[8] = "-s";
        inputs[9] = string.concat(string.concat("tmp/", name), "_abi.json");
        
        bytes memory res = vm.ffi(inputs);
        console2.log(string(res));
    }

    function setupCircuit(string memory name) public {
        string[] memory inputs = new string[](12);
        inputs[0] = "zokrates";
        inputs[1] = "setup";
        inputs[2] = "-u";
        inputs[3] = "tmp/universal_setup.dat";
        inputs[4] = "-s";
        inputs[5] = "marlin";
        inputs[6] = "--proving-key-path";
        inputs[7] = string.concat(string.concat("tmp/", name), "_proving.key");
        inputs[8] = "-v";
        inputs[9] = string.concat(
            string.concat("tmp/", name),
            "_verification.key"
        );
        inputs[10] = "-i";
        inputs[11] = string.concat(string.concat("tmp/", name), "_out");

        bytes memory res = vm.ffi(inputs);
        console2.log(string(res));
    }

    function createVerifier(string memory name) public {
        string[] memory inputs = new string[](6);
        inputs[0] = "zokrates";
        inputs[1] = "export-verifier";
        inputs[2] = "-o";
        inputs[3] = string.concat(
            string.concat("src/verifiers/", name),
            ".sol"
        );
        inputs[4] = "-i";
        inputs[5] = string.concat(
            string.concat("tmp/", name),
            "_verification.key"
        );
        
        bytes memory res = vm.ffi(inputs);
        console2.log(string(res));
    }

    function buildCircuit(string memory name) public {
        compileCircuit(name);
        setupCircuit(name);
        createVerifier(name);
    }

    function run() public {
        clearTemporary();
        universalSetup();
        buildCircuit("redeem");
        buildCircuit("fulfill");
    }
}
