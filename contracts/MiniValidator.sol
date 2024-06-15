// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
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

    event NFTMinted(uint256 _tokenId, string _finalId);
    event NFTOwnerUpdated(uint256 _tokenId, address _currentOwner);

    function initialize(address initialOwner) public initializer {
        __ERC721_init("MiniValidator", "MiniV");
        __ERC721URIStorage_init();
        __Ownable_init(initialOwner);
    }

    function safeMint(string memory uri) public onlyOwner {
        TokenId++;
        _safeMint(address(this), TokenId);
        _setTokenURI(TokenId, uri);

        string memory id = Strings.toString(TokenId);
        string memory hash = "# 12 - ";
        string memory finalId = string(abi.encodePacked(hash, id));
        nftInfo[TokenId] = NFTInfo(finalId, address(this));

        emit NFTMinted(TokenId, finalId);
    }

    function updateOwner(uint256 _tokenid, address _toeknidOwner) public {
        require(
            msg.sender == owner() ||
                msg.sender == nftInfo[_tokenid].currentOwner,
            "You are not authorized to call this function"
        );
        nftInfo[_tokenid].currentOwner = _toeknidOwner;
        emit NFTOwnerUpdated(_tokenid, _toeknidOwner);
    }

    //------------Overriding all transfere function so that only------------------------

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721Upgradeable, IERC721) onlyOwner {
        if (ownerOf(tokenId) == address(this)) {
            _transfer(address(this), to, tokenId);
        } else {
            _transfer(from, to, tokenId);
        }
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint256 tokenId
    // ) public virtual override(ERC721Upgradeable, IERC721) onlyOwner {
    //     safeTransferFrom(from, to, tokenId, "");
    // }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override(ERC721Upgradeable, IERC721) onlyOwner {
        super.safeTransferFrom(from, to, tokenId, data);
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
