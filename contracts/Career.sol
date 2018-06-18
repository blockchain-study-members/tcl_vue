pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

contract Career {
    string[] people;

    constructor() public {
        people.push("ttt");
    }

    function addPerson(string name) public returns(string[]){
        people.push(name);
        return people;
    }

    function getPerson() public returns(string[]){
        return people;
    }
    
}
