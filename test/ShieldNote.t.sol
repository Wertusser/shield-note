// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import {ShieldNote} from "../src/ShieldNote.sol";
// import {Pairing, Verifier} from "../src/verifiers/fulfill.sol";
// import {Pairing, Verifier} from "../src/verifiers/redeem.sol";

// // prover_sk 2061898512262334998049153476770149213675078907792940038676731350170041123939
// // prover_pk [
// // "17634831716325538367321621394135784607956077755005683047939507810499081869630",
// // "12087942341350686317967609166315820128900721428539267846365073945815776132046"
// // ]
// //

// // sender_sk 14160695933298451691146973714489109542276136350330255120821863650657060177278
// // sender_pk [
// // "12352607808132763279574522879852508422728584071995588127511667808545829045780",
// // "21881438302212627207006031416819538600875081188696628696214892054290994874061"
// // ]
// //
// // preimage 17710664066201710529619552699805122155492501405997203553482791760428261221123
// // data 148800228

// // output   [
// //   "7872083662924875337472871316294847390753236595182432348005548527179369436192",
// //   "3247721841450902554079979655445681557106247798299857316699047792692870760990"
// // ]

// contract NoteMarketTest is Test {
//     NoteMarket public market;

//     uint256[2] public senderKey;
//     uint256[2] public proverKey;
//     uint256 public preimage;
//     uint256[2] public output;

//     function setUp() public {
//         market = new NoteMarket();
//         proverKey = [
//             17634831716325538367321621394135784607956077755005683047939507810499081869630,
//             12087942341350686317967609166315820128900721428539267846365073945815776132046
//         ];
//         senderKey = [
//             12352607808132763279574522879852508422728584071995588127511667808545829045780,
//             21881438302212627207006031416819538600875081188696628696214892054290994874061
//         ];
//         preimage = 17710664066201710529619552699805122155492501405997203553482791760428261221123;
//         output = [
//             7872083662924875337472871316294847390753236595182432348005548527179369436192,
//             3247721841450902554079979655445681557106247798299857316699047792692870760990
//         ];
//     }

//     function testRequestAndClose(address sender) public {
//         vm.prank(sender);
//         market.request(preimage, senderKey);
//         /*
//             "a": [
//       "0x081af38a997a0aebfc6fd31926a6d739b57c53e05c542e640499486e2a2afb6e",
//       "0x0c89151a6f8aaa17785af70d22e54026d887da64d5cdaca178748c81d2e05a6f"
//     ],
//     "b": [
//       [
//         "0x013d371ba21c6bb24378e04e6a57bfb3245bfc896fde67bd215a74f3a1e69422",
//         "0x06e27aa1c4dc8348a09305039c07f45175c86b35be76a4215a76b03a777700a0"
//       ],
//       [
//         "0x1aeac9db84a16d549c443a3e1090fda86cd55c829aebe1205c2b9ce3fff961cb",
//         "0x2da3e9493cec62432ce06e994b6876e08fcbb188425a3edadf5ba65324f32756"
//       ]
//     ],
//     "c": [
//       "0x1cfd690546e1a6f4dcd9cb5d9f76194a6465f62811b01c5098c1597d54a879bc",
//       "0x12350c9f4137ac9419a6fe7a745c9db80b392b31dbfb0f63270bcd46141dd69f"
//     ]
//         */

//         market.close(preimage);
//         uint8 status = market.getStatus(sender, preimage);
//         console2.log(status);
//     }

//     function testRequestAndFulfill(address sender, address prover) public {
//         vm.prank(sender);
//         market.request(preimage, senderKey);
//         vm.prank(prover);
//         Verifier.Proof memory proof = Verifier.Proof(
//             Pairing.G1Point(
//                 0x2055bc4944fd5a5e96ed2d1154433da8c483f6766459e39f29a346a069504267,
//                 0x16302bb80858cd48ee7a0104831699b7b05d51b59ca0e410433379d83ffddb40
//             ),
//             Pairing.G2Point(
//                 [
//                     0x0f30eb3498a0f7b2562fdac4fdb16b16de57f4aa7c03ba2517a4dcda2ad10fe4,
//                     0x2e6a71b444179e9a80385a063184ffb88fb6a499009dec9427c695cd4d8e6486
//                 ],
//                 [
//                     0x1fef4b534a7b7703f626c60628f6aa61cf7ade6afeb10d3b100cbad58cf4153a,
//                     0x07b06c2ad899fc969d29af20bd8c2a27e21cbfc56a1d84a7137a46af4aebedc9
//                 ]
//             ),
//             Pairing.G1Point(
//                 0x2e4df91f219aa5cca953a462ba4200aeff98af8df0b67bf8f0b306a5855b31a5,
//                 0x109f51392c00ca17360a211dc2d171fe02688307a23542823a17cdc3cb1084a3
//             )
//         );
//         market.fulfill(proof, preimage, sender, proverKey, output);
//     }
// }
