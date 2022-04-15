// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.6.0 <0.9.0;

contract NotificationModuleCore {
    address owner;

    constructor() {
      owner = msg.sender;
    }

    function destroy(address payable _to) public {
         require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        selfdestruct(_to);
    }

    struct Channel {
        address owner;
        string protocol;
        address protocolContractAddress;
        string _hash;
        User[] subscriber;
        bool exists;
    }

    struct User {
        address userAddress;
        string _hash;
        bool isSubsribed;
    }

    mapping(address => User) private users;
    mapping(uint256 => Channel) private channels;

    // Modifiers to be added with User Role/Permissions

// Events
    event ChannelCreated(address owner, uint256 uuid, uint256 timestamp, string filehash);
    event ChannelUpdated(address owner, uint256 timestamp, string filehash);
    event ChannelDisabled(address owner, uint256 timestamp, string filehash);

    event SubscribedToChannel(address owner, uint256 channelUUID, uint256 timestamp);
    event UnubscribedChannel(address owner, uint256 channelUUID, uint256 timestamp);

    event UserInfoUpdated(address owner, string hash, uint256 timestamp);

    function createChannel(uint256 uuid, string memory protocol, address protocolContractAddress, string memory _newHash) public {
       // can be developed further with modifiers (duplicate check) (// modifier access copntrat)
        if (channels[uuid].owner == msg.sender) {
            revert("channel exists");
        }
        channels[uuid].owner = msg.sender;
        channels[uuid].protocol = protocol;
        channels[uuid].protocolContractAddress = protocolContractAddress;
        channels[uuid]._hash = _newHash;
        channels[uuid].exists = true;
        emit ChannelCreated(msg.sender, uuid, block.timestamp, _newHash);
    }

    function getChannel(uint256 uuid) public view returns (string memory protocol, address protocolContractAddress, string memory _newHash) {
        require(channels[uuid].exists, "Channel does not exist.");
        return (channels[uuid].protocol, channels[uuid].protocolContractAddress, channels[uuid]._hash);
    }

    function subscribedToChannel(uint256 uuid, string memory _newHash) public{
        require(channels[uuid].exists, "Channel does not exist.");
       User memory user = User(msg.sender, _newHash, true);
       channels[uuid].subscriber.push(user);
       emit SubscribedToChannel(msg.sender, uuid, block.timestamp);
    }

     function getUserInfo(address userAddress) public view returns (string memory) {
         return users[userAddress]._hash;
     }

     function upDateUserInfo(string memory hash) public {
        if (users[msg.sender].userAddress == msg.sender) {
            revert("invalid account");
        }
         users[msg.sender]._hash = hash;
        emit UserInfoUpdated(msg.sender, hash, block.timestamp);

     }

     function unSubscribeChannel(uint256 uuid) public{
           require(channels[uuid].exists, "Channel does not exist.");
          for (uint256 i = 0; i < channels[uuid].subscriber.length; i++) {
             if(channels[uuid].subscriber[i].userAddress == msg.sender) {
                 channels[uuid].subscriber[i].isSubsribed = false;
             }
        }
         // to be done
         emit UnubscribedChannel(msg.sender, uuid, block.timestamp);
    }

    function getListOfSubscriber(uint256 channelId) public view returns (address[] memory, string[] memory, bool[] memory) {
         uint length = channels[channelId].subscriber.length;
          address[] memory addrs = new address[](length);
          string[] memory hash = new string[](length);
          bool[] memory isSubsribed = new bool[](length);

        for (uint i = 0; i < length; i++) {
            addrs[i] = channels[channelId].subscriber[i].userAddress;
            hash[i] = channels[channelId].subscriber[i]._hash;
            isSubsribed[i] = channels[channelId].subscriber[i].isSubsribed;
        }
        return (addrs, hash, isSubsribed);
    }

}
