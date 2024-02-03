// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    uint public totalVoteCount;
    uint public candidateCount;
    uint public electionTime;
    string voterscardPasscode;

    enum VoterStatus {
        NotVoted,
        Voted
    }

    struct Voter {
        VoterStatus status;
        string name;
        uint voteCounter;
    }

    mapping(uint => Voter) public voters;
    mapping(address => bool) public voted;

    string[] public candidateNames;

    modifier electionTimeChecker() {
        require(block.timestamp < electionTime, "Election time has elapsed");
        _;
    }

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
        electionTime = block.timestamp + 30 minutes;
        voterscardPasscode = "123";
    }

    function addCandidate(string memory _name) public onlyOwner {
        require(
            candidateCount < 5,
            "Maximum number of candidates reached"
        );
        candidateCount++;
        //  candidateNames[candidateCount - 1] = _name;
        candidateNames.push(_name);
        voters[candidateCount] = Voter(VoterStatus.NotVoted, _name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    function vote(
        uint _candidate,
        string memory _voterscardPasscode
    ) external electionTimeChecker {
        require(!voted[msg.sender], "Already voted");
        require(_candidate <= candidateCount, "Invalid candidate");
        require(
            keccak256(abi.encodePacked(voterscardPasscode)) ==
                keccak256(abi.encodePacked(_voterscardPasscode)),
            "Wrong passcode, You can't vote, input correct passcode"
        );

        // Update voteCounter for the selected candidate
        voters[_candidate].voteCounter++;
        voters[_candidate].status = VoterStatus.Voted;

        voted[msg.sender] = true;
        totalVoteCount++;

        emit VoteCast(msg.sender, _candidate);
    }
    function getall() external view returns(string[] memory all){
        return candidateNames;

    }

    

    // function getAllCandidates()
    //     external
    //     view
    //     returns (string[] memory allNames)
    // {
    //     allNames = new string[](candidateCount);

    //     for (uint i = 0; i < candidateCount; i++) {
    //         allNames[i] = candidateNames[i];
    //     }

    //     return allNames;
    // }

    function winnerName() external view returns (string memory winnerName_) {
        uint maxVotes = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (voters[i].voteCounter > maxVotes) {
                maxVotes = voters[i].voteCounter;
                winnerName_ = voters[i].name;
            }
        }
    }
}