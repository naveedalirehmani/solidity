// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    
    function getProfile(address _user) external view returns (UserProfile memory);
}

contract Twitter is Ownable {

    IProfile private profileContract;

    uint256 public MAX_TWEET_LENGTH = 280;
    struct Tweet {
        uint256  id;
        address  author;
        string   content;
        uint256  timestamp;
        uint256  likes;
    }
    mapping(address => Tweet[]) public tweetMap;

    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 totalLikeCount);
    event UnlikeTweet(address unLiker, address tweetAuthor, uint256 tweetid, uint256 totalLikeCount);

    modifier onlyRegistered() {
        IProfile.UserProfile memory tempProfile = profileContract.getProfile(msg.sender);
        require(bytes(tempProfile.displayName).length > 0 ,"You don't have a profile.");
        _;
    }

    constructor(address _userContractAddress) Ownable(msg.sender) {
        profileContract = IProfile(_userContractAddress);
    }

    // change max tweet lenth only by author
    function maxTweetLength (uint256 _newTwtLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTwtLength;
    }

    // create a tweet
    function addtweet(string memory _twt) public onlyRegistered {

        require(bytes(_twt).length <= MAX_TWEET_LENGTH, "A tweet must not be more than 280 charectors long");

        Tweet memory newTweet = Tweet({
            id : tweetMap[msg.sender].length,
            author : msg.sender,
            content : _twt,
            timestamp : block.timestamp,
            likes : 0
        });
        
        tweetMap[msg.sender].push(newTweet);

        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }
    
    // like tweet
    function likeTweet(uint256 id, address author) external onlyRegistered {
        require(tweetMap[author][id].id == id, "tweet does not exist");
        tweetMap[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweetMap[author][id].likes);
    }
    
    // unlike tweet
    function unLikeTweet(uint256 id, address author) external onlyRegistered {
        require(tweetMap[author][id].id == id, "tweet does not exist");
        require(tweetMap[author][id].likes > 0, "Tweet has no likes");
        
        tweetMap[author][id].likes--;

        emit UnlikeTweet(msg.sender, author, id, tweetMap[author][id].likes);
    }

    // getTweet functions
    function getTweet(address _owner, uint256 _i) public view returns (Tweet memory) {
        return tweetMap[_owner][_i];
    }

    function getAllTweets ( address _owner) public view returns(Tweet[] memory){
        return tweetMap[_owner];
    }

    function getTotalLikes(address _owner) external view returns(uint256){
        uint256 totalLikeCount = 0;
        for (uint16 i = 0; i < tweetMap[_owner].length; i++){
            totalLikeCount += tweetMap[_owner][i].likes;
        }
        return totalLikeCount;
    }

}