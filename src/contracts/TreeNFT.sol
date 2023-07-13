// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "solmate/tokens/ERC721.sol";
import "solmate/auth/Owned.sol";
import "eas-contracts/IEAS.sol";
import "eas-contracts/SchemaResolver.sol";

contract TreeNFT is Owned, ERC721, SchemaResolver {
    string BASE_URI = "https://tree-nft.vercel.app/api/token/";

    mapping(uint256 => uint256) public growthStage;

    constructor(IEAS eas) Owned(msg.sender) ERC721("TreeNFT", "TREE") SchemaResolver(eas) {
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked(BASE_URI, id));
    }

    function mint(address to) onlyOwner public {
        _mint(to, uint256(uint160(to)));
    }
    
    function onAttest(Attestation calldata attestation, uint256 /*value*/) internal override returns (bool) {
        require(msg.sender == eas, "TreeNFT: only EAS can call this function");
        require(attestation.attester == owner, "TreeNFT: only owner can attest");



        return true;
    }

    function mintOrGrow(address to) internal {
        uint256 id = uint256(uint160(to));
        if (_exists(id)) {
            growthStage[id]++;
        } else {
            mint(to);
        }
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        return true;
    }

    function grow(uint256 id) public {
        require(msg.sender == EAS_SCHEMA_RESOLVER);
        require(growthStage[id] < 3, "TreeNFT: already fully grown");
        growthStage[id]++;
    }

    function transferFrom(address from, address to, uint256 id) public override {
        require(from == address(0) || to == address(0), "TreeNFT: transfer not allowed");
        super.transferFrom(from, to, id);
    }
}