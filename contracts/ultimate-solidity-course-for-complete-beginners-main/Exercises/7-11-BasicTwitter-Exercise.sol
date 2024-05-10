// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Twitter {

    uint256 public MAX_TWEET_LENGTH = 280;
    struct Tweet {
        uint256 id;
        address  auther;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping(address => Tweet[]) public tweetMap;
    address public contractOwner;

    constructor(){
        contractOwner = msg.sender;
    }

    modifier onlyOwner (){
        require(msg.sender == contractOwner, "You are not the owner of the contract");
        _;
    }

    // modifier hasTweetAccess(uint256 id, address author){
       
    //    _;
    // }

    function maxTweetLength (uint256 _newTwtLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTwtLength;
    }

    function addtweet(string memory _twt) public {

        require(bytes(_twt).length <= MAX_TWEET_LENGTH, "A tweet must not be more than 280 charectors long");

        Tweet memory newTweet = Tweet({
            id : tweetMap[msg.sender].length,
            auther : msg.sender,
            content : _twt,
            timestamp : block.timestamp,
            likes : 0
        });
        
        tweetMap[msg.sender].push(newTweet);
    }
    
    function likeTweet(uint256 id, address author) external {
        require(tweetMap[author][id].id == id, "tweet does not exist");
        tweetMap[author][id].likes++;
    }
    
    function unLikeTweet(uint256 id, address author) external {
        require(tweetMap[author][id].id == id, "tweet does not exist");
        require(tweetMap[author][id].likes > 0, "Tweet has no likes");
        
        tweetMap[author][id].likes--;
    }

    function getTweet(address _owner, uint256 _i) public view returns (Tweet memory) {
        return tweetMap[_owner][_i];
    }

    function getAllTweets ( address _owner) public view returns(Tweet[] memory){
        return tweetMap[_owner];
    }

}