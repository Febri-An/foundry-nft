// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNftTest is Test {
    string constant NFT_NAME = "Dogie";
    string constant NFT_SYMBOL = "DOG";

    BasicNft public basicNft;
    DeployBasicNft public deployer;

    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    address public USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
        basicNft = new BasicNft();
    }

    function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked((NFT_NAME))));
        assert(keccak256(abi.encodePacked(basicNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testTokenCounterIsZero() public view {
        assert(basicNft.getTokenCounter() == 0);
    }

    function testTokenCounterIncrements() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        
        assert(basicNft.getTokenCounter() == 1);
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI)));
    }
}