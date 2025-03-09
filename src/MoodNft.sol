// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721, Ownable {
    error MoodNft__TokenUriNotFound();
    error MoodNft__CantFlipMoodIfNotOwner();

    enum MoodState {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSvgUri;
    string private s_happySvgUri;

    mapping(uint256 => MoodState) private s_tokenIdToState;

    event CreatedNFT(uint256 indexed tokenId);

    constructor(string memory sadSvgUri, string memory happySvgUri) ERC721("Mood NFT", "MN") Ownable(msg.sender) {
        s_tokenCounter = 0;
        s_sadSvgUri = sadSvgUri;
        s_happySvgUri = happySvgUri;
    }

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter;
        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        emit CreatedNFT(tokenCounter);
    }

    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToState[tokenId] == MoodState.HAPPY) {
            s_tokenIdToState[tokenId] = MoodState.SAD;
        } else {
            s_tokenIdToState[tokenId] = MoodState.HAPPY;
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert MoodNft__TokenUriNotFound();
        }
        string memory imageURI = s_happySvgUri;

        if (s_tokenIdToState[tokenId] == MoodState.SAD) {
            imageURI = s_sadSvgUri;
        }
        return string.concat(
            _baseURI(),
            Base64.encode(
                abi.encodePacked(
                    '{"name":"',
                    name(),
                    '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                    '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                    imageURI,
                    '"}'
                )
            )
        );
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /*//////////////////////////////////////////////////////////////
                         VIEW & PURE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getHappySvg() public view returns (string memory) {
        return s_happySvgUri;
    }

    function getSadSvg() public view returns (string memory) {
        return s_sadSvgUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}