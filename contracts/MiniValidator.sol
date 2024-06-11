// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";

contract MiniValidator is
    Initializable,
    ERC721Upgradeable,
    ERC721URIStorageUpgradeable,
    ERC721HolderUpgradeable,
    OwnableUpgradeable
{
    uint256 public TokenId;

    /// @custom:oz-upgrades-unsafe-allow constructor
    // constructor() {
    //     _disableInitializers();
    // }

    struct NFTInfo {
        string NFTNumber;
        address currentOwner;
    }
    // NFT Id => NFTInfo
    mapping(uint256 => NFTInfo) public nftInfo;

    function initialize(address initialOwner) public initializer {
        __ERC721_init("MiniValidator", "MiniV");
        __ERC721URIStorage_init();
        __Ownable_init(initialOwner);
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = TokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        string memory id = Strings.toString(tokenId);
        string memory hash = "# 12 - ";
        string memory finalId = string(abi.encodePacked(hash, id));
        nftInfo[tokenId] = NFTInfo(finalId, address(this));
    }

    function updateOwner(uint256 _tokenid, address _toeknidOwner)
        public
        onlyOwner
    {
        nftInfo[_tokenid].currentOwner = _toeknidOwner;
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
