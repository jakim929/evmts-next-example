// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "solmate/tokens/ERC721.sol";
import "solmate/auth/Owned.sol";

contract TreeNFT is Owned, ERC721 {
    string BASE_URI = "https://tree-nft.vercel.app/api/token/";

    mapping(uint256 => uint256) public growthStage;

    constructor() ERC721("TreeNFT", "TREE") Owned(msg.sender) {}

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked(BASE_URI, id));
    }

    function mint(address to) onlyOwner public {
        _mint(to, uint256(uint160(to)));
    }

    

    function transferFrom(address from, address to, uint256 id) public override {
        require(from == address(0) || to == address(0), "TreeNFT: transfer not allowed");
        super.transferFrom(from, to, id);
    }
}