// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ballot {
    uint public totalVoteCount;

    enum VoterStatus { NotVoted, Voted }

    struct Voter {
        VoterStatus status;
        string name;
        uint voteCounter;
    }

    mapping(uint => Voter) public voters;
    mapping(address => bool) public voted;

    event CandidateAdded(uint indexed candidateId, string name);
    event VoteCast(address indexed voter, uint indexed candidateId);

    modifier onlyOwner() {
        require(msg.sender == INEC, "Only INEC");
        _;
    }

    address public INEC;

    constructor() {
        INEC = msg.sender;
        addCandidate("Daniel");
        addCandidate("Sogo");
        addCandidate("Jeff");
    }

    function addCandidate(string memory _name) public onlyOwner {
        voters[totalVoteCount] = Voter(VoterStatus.NotVoted, _name, 0);
        emit CandidateAdded(totalVoteCount, _name);
    }

    function vote(uint _candidate) external {
        require(!voted[msg.sender], "Already voted");
        require(_candidate <= totalVoteCount, "Invalid candidate");

        // Update voteCounter for the selected candidate
        voters[_candidate].voteCounter++;
        voters[_candidate].status = VoterStatus.Voted;

        voted[msg.sender] = true;

        emit VoteCast(msg.sender, _candidate);
    }

    function winnerName() external view returns (string memory winnerName_) {
        uint maxVotes = 0;
        for (uint i = 1; i <= totalVoteCount; i++) {
            if (voters[i].voteCounter > maxVotes) {
                maxVotes = voters[i].voteCounter;
                winnerName_ = voters[i].name;
            }
        }
    }
}

