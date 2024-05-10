// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Whitelist {

    // Alamat pemilik kontrak
    address public owner;

    // Biaya untuk join whitelist
    uint256 public whitelistFee = 0.01 ether;

    // Mapping untuk menyimpan alamat yang sudah diwhitelist
    mapping(address => bool) public whitelistedAddresses;

    // Acara whitelist terbuka atau tidak
    bool public whitelistOpen = true;

    // Variabel untuk menyimpan jumlah alamat yang diwhitelist
    uint public whitelistedCount = 0;

    // Event untuk menandakan alamat ditambahkan ke whitelist
    event AddressWhitelisted(address indexed _address);

    // Array untuk menyimpan alamat yang diwhitelist
    address[] public whitelistedAddressesArray;

    // Event untuk menandakan acara whitelist ditutup
    event WhitelistClosed();

    constructor() {
        owner = msg.sender;
    }

    // Modifier untuk membatasi akses hanya ke pemilik
    modifier onlyOwner() {
        require(msg.sender == owner, "Hanya pemilik yang dapat mengakses fungsi ini");
        _;
    }

    // Fungsi untuk menambahkan alamat ke whitelist
    function addToWhitelist() public payable {
        require(whitelistOpen, "Acara whitelist sudah ditutup");
        require(msg.value >= whitelistFee, "Pembayaran tidak cukup");

        whitelistedAddresses[msg.sender] = true;
        whitelistedCount++;
        whitelistedAddressesArray.push(msg.sender);
        emit AddressWhitelisted(msg.sender);
    }

    // Fungsi untuk menutup acara whitelist
    function closeWhitelist() public onlyOwner {
        whitelistOpen = false;
        emit WhitelistClosed();
    }

    // Fungsi untuk mendapatkan jumlah alamat yang sudah diwhitelist
    function getNumberOfWhitelisted() public view returns (uint) {
        return whitelistedCount;
    }

    // Fungsi untuk mendapatkan daftar alamat yang sudah diwhitelist
    function getWhitelistedAddresses() public view returns (address[] memory) {
        return whitelistedAddressesArray;
    }

    // Fungsi untuk menarik dana yang terkumpul dari biaya whitelist
    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
