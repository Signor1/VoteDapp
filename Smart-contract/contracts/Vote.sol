// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    uint public totalVoteCount;
    uint public candidateCount;
    uint public electionTime;
    string voterscard;

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
    mapping(address => bool) public Registeredvoter;

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
        addCandidate("Emmanuel");
        electionTime = block.timestamp + 30 minutes;
        voterscard = "123";
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
        string memory _voterscard
    ) external electionTimeChecker {
        require(!Registeredvoter[msg.sender], "Already voted");
        require(_candidate <= candidateCount, "Invalid candidate");
        require(
            keccak256(abi.encodePacked(voterscard)) ==
                keccak256(abi.encodePacked(_voterscard)),
            "Wrong passcode, You can't vote, input correct passcode"
        );

        // Update  and increment the voteCounter
        voters[_candidate].voteCounter++;
        voters[_candidate].status = VoterStatus.Voted;

        Registeredvoter[msg.sender] = true;
        totalVoteCount++;

        emit VoteCast(msg.sender, _candidate);
    }
    function getCandidates() external view returns(string[] memory all){
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

    function Winner() external view returns (string memory winnerName_) {
        uint max = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (voters[i].voteCounter > max) {
                max = voters[i].voteCounter;
                winnerName_ = voters[i].name;
            }
        }
    }
}