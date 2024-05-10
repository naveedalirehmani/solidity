// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1️⃣ Create a Twitter Contract 
// 2️⃣ Create a mapping between user and tweet 
// 3️⃣ Add function to create a tweet and save it in mapping
// 4️⃣ Create a function to get Tweet 
// 5️⃣ Add array of tweets

contract Twitter {

    uint16 constant MAX_TWEET_LENGTH = 280;
    
    struct Tweet {
        address  auther;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweetMap;

    function addtweet(string memory _twt) public {

        require(bytes(_twt).length <= MAX_TWEET_LENGTH, "A tweet must not be more than 280 charectors long");

        Tweet memory newTweet = Tweet({
            auther : msg.sender,
            content : _twt,
            timestamp : block.timestamp,
            likes : 0
        });
        
        tweetMap[msg.sender].push(newTweet);
    }

    function getTweet(address _owner, uint256 _i) public view returns (Tweet memory) {
        return tweetMap[_owner][_i];
    }

    function getAllTweets ( address _owner) public view returns(Tweet[] memory){
        return tweetMap[_owner];
    }

}