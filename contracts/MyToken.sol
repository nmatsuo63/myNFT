// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {

    // NFTのIDと固有部分を管理するマッピング
    // ID:uint, URI固有部分:string
    mapping(uint => string) tokenURIs;

    // ERC721のコンストラクタを見ると引数は(_name, _symbol)となっている
    constructor() ERC721("MyToken", "MKT") {}

    // 発行と紐付けを行うための関数
    function linkData(address to, uint tokenId) public {
        // ERC721で定義された_safeMint（はNFTを発行するための関数）を継承している
        // 引数は、NFTの送付先アドレスとID
        _safeMint(to, tokenId);
        // ここでNFTとMetadataを紐付ける関数を呼び出す
        setTokenURI(tokenId, uri);
    }

    // URIの共通部分を管理するための関数
    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    // tokenURIsにNFTのIDとURIを保存するための関数
    function setTokenURI(uint tokenId, string memory uri) internal {
        // NFTが発行されていなければ処理を中断するようにする
        // これがないと、NFTを発行できなかった場合でもNFTのIDとURIを保存してしてしまう（ガス代がかかる？）
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token...");
        tokenURIs[tokenId] = uri;
    }

    // URIを渡すための関数
    // OpenSeaではMetadataのURIを渡すための関数名はtokenURIとする必要がある。
    // To find this URI, we use the tokenURI method in ERC721 and the uri method in ERC1155.
    // https://docs.opensea.io/docs/metadata-standards
    function tokenURI(uint tokenId) public view override returns (string memory) {
        string memory baseURI = _baseURI();
        string memory currentIPHash = tokenURIs[tokenId];
        return string.concat(baseURI, currentIPHash);
    }
}
