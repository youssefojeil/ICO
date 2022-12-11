// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";


contract CryptoDevToken is ERC20, Ownable {

    ICryptoDevs CryptoDevsNFT;

    uint256 public constant tokensPerNFT = 10 * 10**18;

    //mapping to keep track of which tokenIDs claimed their erc-20
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function claim() public {
        address sender = msg.sender;
        uint256 balance = CryptoDevsNFT.balanceOf(sender);
        require(balance > 0, "You dont own any Crypto Dev NFTs");
        uint256 amount = 0;

        // for each nft that an address owns
        for(uint256 i = 0; i < balance; i ++) {

            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if(!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have already claimed all your tokens");

        _mint(msg.sender, amount * tokensPerNFT);
    }
}