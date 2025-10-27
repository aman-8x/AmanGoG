// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DappVerse
 * @dev A decentralized application hub allowing users to register and share DApps.
 */
contract DappVerse {
    struct Dapp {
        uint id;
        string name;
        string description;
        address creator;
    }

    uint private dappCount;
    mapping(uint => Dapp) public dapps;

    event DappRegistered(uint indexed id, string name, address indexed creator);
    event DappUpdated(uint indexed id, string newDescription);

    // Function 1: Register a new DApp
    function registerDapp(string memory _name, string memory _description) public {
        dappCount++;
        dapps[dappCount] = Dapp(dappCount, _name, _description, msg.sender);
        emit DappRegistered(dappCount, _name, msg.sender);
    }

    // Function 2: Update existing DApp description
    function updateDapp(uint _id, string memory _newDescription) public {
        require(_id > 0 && _id <= dappCount, "Invalid DApp ID");
        Dapp storage dapp = dapps[_id];
        require(msg.sender == dapp.creator, "Only creator can update");
        dapp.description = _newDescription;
        emit DappUpdated(_id, _newDescription);
    }

    // Function 3: Retrieve all DApp count
    function getTotalDapps() public view returns (uint) {
        return dappCount;
    }
}
