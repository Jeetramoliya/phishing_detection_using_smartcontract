// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract PhishingScamDetector {
    
    struct PhishingSite {
        string siteUrl;
        address reporter;
        bool isReported;
    }
    
    mapping (address => bool) public isAdmin;
    mapping (string => PhishingSite) public phishingSites;
    
    event PhishingSiteReported(string siteUrl, address reporter);
    
    constructor(address[] memory _adminAddresses) {
        for (uint i = 0; i < _adminAddresses.length; i++) {
            isAdmin[_adminAddresses[i]] = true;
        }
    }
    
    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Unauthorized: Caller is not an admin");
        _;
    }
    
    function reportPhishingSite(string memory _siteUrl) public {
        require(bytes(_siteUrl).length > 0, "Invalid site URL");
        require(!phishingSites[_siteUrl].isReported, "Site already reported");
        
        phishingSites[_siteUrl] = PhishingSite(_siteUrl, msg.sender, true);
        emit PhishingSiteReported(_siteUrl, msg.sender);
    }
    
    function unreportPhishingSite(string memory _siteUrl) public onlyAdmin {
        require(bytes(_siteUrl).length > 0, "Invalid site URL");
        require(phishingSites[_siteUrl].isReported, "Site not reported");
        
        phishingSites[_siteUrl].isReported = false;
    }
    
    function isPhishingSite(string memory _siteUrl) public view returns (bool) {
        require(bytes(_siteUrl).length > 0, "Invalid site URL");
        
        return phishingSites[_siteUrl].isReported;
    }
}
