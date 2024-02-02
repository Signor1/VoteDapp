// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;



contract Ballot {
    // This represents a single voter.
    struct Voter {
        uint id
        bool voted;  
        uint vote;   
    }

    // This is a type for a single Candidate.
    struct Candidate {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }


    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Candidate` structs.
    Candidate[] public Candidates;

    /// Create a new ballot to choose one of `CandidateNames`.
    constructor(bytes32[] memory CandidateNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided Candidate names,
        // create a new Candidate object and add it
        // to the end of the array.
        for (uint i = 0; i < CandidateNames.length; i++) {
            // `Candidate({...})` creates a temporary
            // Candidate object and `Candidates.push(...)`
            // appends it to the end of `Candidates`.
            Candidates.push(Candidate({
                name: CandidateNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) external {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) external {
        // assigns reference
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        // Voters cannot delegate to accounts that cannot vote.
        require(delegate_.weight >= 1);

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender]`.
        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            Candidates[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to Candidate `Candidates[Candidate].name`.
    function vote(uint Candidate) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = Candidate;

        // If `Candidate` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        Candidates[Candidate].voteCount += sender.weight;
    }

    /// @dev Computes the winning Candidate taking all
    /// previous votes into account.
    function winningCandidate() public view
            returns (uint winningCandidate_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < Candidates.length; p++) {
            if (Candidates[p].voteCount > winningVoteCount) {
                winningVoteCount = Candidates[p].voteCount;
                winningCandidate_ = p;
            }
        }
    }

    // Calls winningCandidate() function to get the index
    // of the winner contained in the Candidates array and then
    // returns the name of the winner
    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = Candidates[winningCandidate()].name;
    }
}