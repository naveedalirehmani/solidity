// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    address public electionCreator;
    bool public electionStarted;
    bool public electionEnded;

    struct Candidate {
        uint id;
        string name;
        string description;
        string symbol;
        uint voteCount;
        address[] voters;
    }

    struct Voter {
        bool hasVoted;
        uint votedCandidateId;
    }

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    uint public totalVotes;

    modifier onlyElectionCreator() {
        require(msg.sender == electionCreator, "Only the election creator can perform this action");
        _;
    }

    modifier electionNotStarted() {
        require(!electionStarted, "Election has already started");
        _;
    }

    modifier electionInProgress() {
        require(electionStarted && !electionEnded, "Election is not in progress");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        _;
    }

    constructor() {
        electionCreator = msg.sender;
    }

    function addCandidate(string memory _name, string memory _description, string memory _symbol) public onlyElectionCreator electionNotStarted {
        candidatesCount++;
        address[] memory emptyArray;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, _description, _symbol, 0, emptyArray);
    }

    function startElection() public onlyElectionCreator electionNotStarted {
        electionStarted = true;
    }

    function endElection() public onlyElectionCreator {
        require(electionStarted, "Election has not started yet");
        electionEnded = true;
    }

    function vote(uint _candidateId) public electionInProgress hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");

        voters[msg.sender] = Voter(true, _candidateId);
        candidates[_candidateId].voteCount++;
        candidates[_candidateId].voters.push(msg.sender);
        totalVotes++;
    }

    function getTotalCandidates() public view returns (uint) {
        return candidatesCount;
    }

    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }

    function getCandidate(uint _candidateId) public view returns (uint, string memory, string memory, string memory, uint, address[] memory) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.description, candidate.symbol, candidate.voteCount, candidate.voters);
    }

    function getVoter(address _voter) public view returns (bool, uint) {
        Voter memory voter = voters[_voter];
        return (voter.hasVoted, voter.votedCandidateId);
    }
}
