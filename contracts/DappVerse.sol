// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title DappVerse
 * @notice A decentralized application hub that allows developers to publish,
 *         verify, and interact with decentralized apps (DApps) on-chain.
 */
contract Project {
    address public admin;
    uint256 public appCount;

    struct Dapp {
        uint256 id;
        address developer;
        string name;
        string description;
        string repoLink;
        bool verified;
        uint256 timestamp;
    }

    mapping(uint256 => Dapp) public dapps;

    event DappPublished(uint256 indexed id, address indexed developer, string name, string repoLink);
    event DappVerified(uint256 indexed id, address indexed verifier);
    event OwnershipTransferred(uint256 indexed id, address indexed oldDeveloper, address indexed newDeveloper);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyDeveloper(uint256 _id) {
        require(dapps[_id].developer == msg.sender, "Not the DApp developer");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Publish a new decentralized app (DApp)
     * @param _name DApp name
     * @param _description Short description of the DApp
     * @param _repoLink Link to the DApp repository (GitHub, IPFS, etc.)
     */
    function publishDapp(string memory _name, string memory _description, string memory _repoLink) external {
        require(bytes(_name).length > 0, "Name required");
        require(bytes(_description).length > 0, "Description required");
        require(bytes(_repoLink).length > 0, "Repository link required");

        appCount++;
        dapps[appCount] = Dapp(appCount, msg.sender, _name, _description, _repoLink, false, block.timestamp);

        emit DappPublished(appCount, msg.sender, _name, _repoLink);
    }

    /**
     * @notice Admin verifies a published DApp
     * @param _id DApp ID
     */
    function verifyDapp(uint256 _id) external onlyAdmin {
        require(_id > 0 && _id <= appCount, "Invalid DApp ID");
        require(!dapps[_id].verified, "Already verified");

        dapps[_id].verified = true;
        emit DappVerified(_id, msg.sender);
    }

    /**
     * @notice Transfer ownership of a DApp to another developer
     * @param _id DApp ID
     * @param _newDeveloper Address of the new developer
     */
    function transferOwnership(uint256 _id, address _newDeveloper) external onlyDeveloper(_id) {
        require(_newDeveloper != address(0), "Invalid address");
        address oldDev = dapps[_id].developer;
        dapps[_id].developer = _newDeveloper;

        emit OwnershipTransferred(_id, oldDev, _newDeveloper);
    }

    /**
     * @notice Get details of a specific DApp
     * @param _id DApp ID
     */
    function getDapp(uint256 _id) external view returns (Dapp memory) {
        require(_id > 0 && _id <= appCount, "Invalid DApp ID");
        return dapps[_id];
    }
}
