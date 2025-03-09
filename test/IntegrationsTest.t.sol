// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {MintBasicNft} from "script/Interactions.s.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract MintBasicNftTest is Test {
    BasicNft public basicNft;
    MintBasicNft public mintBasicNft;
    address public USER = makeAddr("USER");
    string public constant PUG_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        basicNft = new BasicNft();
        mintBasicNft = new MintBasicNft();
    }

    function testMintNft() public {
        uint256 initialSupply = basicNft.getTokenCounter();
        
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        
        uint256 newSupply = basicNft.getTokenCounter();
        assertEq(newSupply, initialSupply + 1);
        assertEq(basicNft.tokenURI(newSupply - 1), PUG_URI);
    }
}