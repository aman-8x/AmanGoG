Function 1: Register a new DApp
    function registerDapp(string memory _name, string memory _description) public {
        dappCount++;
        dapps[dappCount] = Dapp(dappCount, _name, _description, msg.sender);
        emit DappRegistered(dappCount, _name, msg.sender);
    }

    Function 3: Retrieve all DApp count
    function getTotalDapps() public view returns (uint) {
        return dappCount;
    }
}
// 
update
// 
