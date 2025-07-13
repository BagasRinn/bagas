import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Text "mo:base/Text";

actor {
  type Candidate = Text;
  type Voter = Principal;

  let candidates: [Candidate] = ["Alice", "Bob", "Charlie"];

  var votes : Trie.Trie<Candidate, Nat> = Trie.empty();
  var voted : Trie.Trie<Voter, Bool> = Trie.empty();

  public query func getCandidates() : async [Candidate] {
    return candidates;
  };

  public func vote(candidate : Candidate) : async Text {
    let voter = msg.caller;

    switch (Trie.get(voted, voter, Principal.equal)) {
      case (?true) {
        return "Kamu sudah memilih!";
      };
      case (_) {
        if (Array.contains(candidates, candidate, Text.equal)) {
          let currentVotes = switch (Trie.get(votes, candidate, Text.equal)) {
            case (?n) n;
            case null 0;
          };
          votes := Trie.put(votes, candidate, Text.equal, currentVotes + 1);

          voted := Trie.put(voted, voter, Principal.equal, true);
          return "Voting berhasil!";
        } else {
          return "Calon tidak ditemukan.";
        };
      }
    };
  };

  public query func getResults() : async [(Candidate, Nat)] {
    return Trie.toArray(votes);
  };
};