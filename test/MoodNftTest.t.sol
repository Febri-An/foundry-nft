// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

contract MoodNftTest is Test {
    string constant NFT_NAME = "Mood NFT";
    string constant NFT_SYMBOL = "MN";

    DeployMoodNft public deployer;
    address public deployerAddress;
    MoodNft public moodNft;

    string public constant HAPPY_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdJR2hsYVdkb2REMGlOREF3SWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGp4amFYSmpiR1VnWTNnOUlqRXdNQ0lnWTNrOUlqRXdNQ0lnWm1sc2JEMGllV1ZzYkc5M0lpQnlQU0kzT0NJZ2MzUnliMnRsUFNKaWJHRmpheUlnYzNSeWIydGxMWGRwWkhSb1BTSXpJaTgrUEdjZ1kyeGhjM005SW1WNVpYTWlQanhqYVhKamJHVWdZM2c5SWpjd0lpQmplVDBpT0RJaUlISTlJakV5SWk4K1BHTnBjbU5zWlNCamVEMGlNVEkzSWlCamVUMGlPRElpSUhJOUlqRXlJaTgrUEM5blBqeHdZWFJvSUdROUltMHhNell1T0RFZ01URTJMalV6WXk0Mk9TQXlOaTR4TnkwMk5DNHhNU0EwTWkwNE1TNDFNaTB1TnpNaUlITjBlV3hsUFNKbWFXeHNPbTV2Ym1VN0lITjBjbTlyWlRvZ1lteGhZMnM3SUhOMGNtOXJaUzEzYVdSMGFEb2dNenNpTHo0OEwzTjJaejQ9In0=";
        // "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+PGcgY2xhc3M9ImV5ZXMiPjxjaXJjbGUgY3g9IjcwIiBjeT0iODIiIHI9IjEyIi8+PGNpcmNsZSBjeD0iMTI3IiBjeT0iODIiIHI9IjEyIi8+PC9nPjxwYXRoIGQ9Im0xMzYuODEgMTE2LjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiLz48L3N2Zz4=";
    string public constant SAD_SVG_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBEOTRiV3dnZG1WeWMybHZiajBpTVM0d0lpQnpkR0Z1WkdGc2IyNWxQU0p1YnlJL1BqeHpkbWNnZDJsa2RHZzlJakV3TWpSd2VDSWdhR1ZwWjJoMFBTSXhNREkwY0hnaUlIWnBaWGRDYjNnOUlqQWdNQ0F4TURJMElERXdNalFpSUhodGJHNXpQU0pvZEhSd09pOHZkM2QzTG5jekxtOXlaeTh5TURBd0wzTjJaeUkrUEhCaGRHZ2dabWxzYkQwaUl6TXpNeUlnWkQwaVRUVXhNaUEyTkVNeU5qUXVOaUEyTkNBMk5DQXlOalF1TmlBMk5DQTFNVEp6TWpBd0xqWWdORFE0SURRME9DQTBORGdnTkRRNExUSXdNQzQySURRME9DMDBORGhUTnpVNUxqUWdOalFnTlRFeUlEWTBlbTB3SURneU1HTXRNakExTGpRZ01DMHpOekl0TVRZMkxqWXRNemN5TFRNM01uTXhOall1Tmkwek56SWdNemN5TFRNM01pQXpOeklnTVRZMkxqWWdNemN5SURNM01pMHhOall1TmlBek56SXRNemN5SURNM01ub2lMejQ4Y0dGMGFDQm1hV3hzUFNJalJUWkZOa1UySWlCa1BTSk5OVEV5SURFME1HTXRNakExTGpRZ01DMHpOeklnTVRZMkxqWXRNemN5SURNM01uTXhOall1TmlBek56SWdNemN5SURNM01pQXpOekl0TVRZMkxqWWdNemN5TFRNM01pMHhOall1Tmkwek56SXRNemN5TFRNM01ucE5Namc0SURReU1XRTBPQzR3TVNBME9DNHdNU0F3SURBZ01TQTVOaUF3SURRNExqQXhJRFE0TGpBeElEQWdNQ0F4TFRrMklEQjZiVE0zTmlBeU56Sm9MVFE0TGpGakxUUXVNaUF3TFRjdU9DMHpMakl0T0M0eExUY3VORU0yTURRZ05qTTJMakVnTlRZeUxqVWdOVGszSURVeE1pQTFPVGR6TFRreUxqRWdNemt1TVMwNU5TNDRJRGc0TGpaakxTNHpJRFF1TWkwekxqa2dOeTQwTFRndU1TQTNMalJJTXpZd1lUZ2dPQ0F3SURBZ01TMDRMVGd1TkdNMExqUXRPRFF1TXlBM05DNDFMVEUxTVM0MklERTJNQzB4TlRFdU5uTXhOVFV1TmlBMk55NHpJREUyTUNBeE5URXVObUU0SURnZ01DQXdJREV0T0NBNExqUjZiVEkwTFRJeU5HRTBPQzR3TVNBME9DNHdNU0F3SURBZ01TQXdMVGsySURRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURBZ09UWjZJaTgrUEhCaGRHZ2dabWxzYkQwaUl6TXpNeUlnWkQwaVRUSTRPQ0EwTWpGaE5EZ2dORGdnTUNBeElEQWdPVFlnTUNBME9DQTBPQ0F3SURFZ01DMDVOaUF3ZW0weU1qUWdNVEV5WXkwNE5TNDFJREF0TVRVMUxqWWdOamN1TXkweE5qQWdNVFV4TGpaaE9DQTRJREFnTUNBd0lEZ2dPQzQwYURRNExqRmpOQzR5SURBZ055NDRMVE11TWlBNExqRXROeTQwSURNdU55MDBPUzQxSURRMUxqTXRPRGd1TmlBNU5TNDRMVGc0TGpaek9USWdNemt1TVNBNU5TNDRJRGc0TGpaakxqTWdOQzR5SURNdU9TQTNMalFnT0M0eElEY3VORWcyTmpSaE9DQTRJREFnTUNBd0lEZ3RPQzQwUXpZMk55NDJJRFl3TUM0eklEVTVOeTQxSURVek15QTFNVElnTlRNemVtMHhNamd0TVRFeVlUUTRJRFE0SURBZ01TQXdJRGsySURBZ05EZ2dORGdnTUNBeElEQXRPVFlnTUhvaUx6NDhMM04yWno0PSJ9";
    
        address public USER = makeAddr("USER");

    function setUp() public {
        deployer = new DeployMoodNft();
        
        string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
        string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");
        moodNft = new MoodNft(deployer.svgToImageURI(sadSvg), deployer.svgToImageURI(happySvg));
    }

    function testInitializedCorrectly() public view {
        assert(keccak256(abi.encodePacked(moodNft.name())) == keccak256(abi.encodePacked((NFT_NAME))));
        assert(keccak256(abi.encodePacked(moodNft.symbol())) == keccak256(abi.encodePacked((NFT_SYMBOL))));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        moodNft.mintNft();

        assert(moodNft.balanceOf(USER) == 1);
    }

    function testTokenURIDefaultIsCorrectlySet() public {
        vm.prank(USER);
        moodNft.mintNft();

        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(HAPPY_SVG_URI)));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);

        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(SAD_SVG_URI)));
    }

    function testEventRecordsCorrectTokenIdOnMinting() public {
        uint256 currentAvailableTokenId = moodNft.getTokenCounter();

        vm.prank(USER);
        vm.recordLogs();
        moodNft.mintNft();
        Vm.Log[] memory entries = vm.getRecordedLogs();

        uint256 tokenId = uint256(entries[1].topics[1]);

        assertEq(tokenId, currentAvailableTokenId);
    }

    function testGetHappySvgUri() public view {
        string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");
        string memory expectedHappySvgUri = deployer.svgToImageURI(happySvg);
        string memory happySvgUri = moodNft.getHappySvg();

        assertEq(happySvgUri, expectedHappySvgUri);
    }

    function testGetSadSvgUri() public view {
        string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
        string memory expectedSadSvgUri = deployer.svgToImageURI(sadSvg);
        string memory sadSvgUri = moodNft.getSadSvg();

        assertEq(sadSvgUri, expectedSadSvgUri);
    }

    function testGetTokenCounter() public view {
        uint256 expectedTokenCounter = 0;
        uint256 tokenCounter = moodNft.getTokenCounter();

        assertEq(tokenCounter, expectedTokenCounter);
    }
}