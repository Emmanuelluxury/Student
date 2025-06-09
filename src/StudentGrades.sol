// SPDX-License-Identifier: MIX
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StudentGrades.sol";

contract StudentGrades {
    address public admin;

    struct Student {
        bool exists;
        uint256 score; 
        string name; 
        uint256 grade;
    }

    mapping(address => Student) public students;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier onlyStudent() {
        require(students[msg.sender].exists, "You are not a registered student.");
        _;
    }

    constructor() {
        admin = msg.sender; // Set the contract deployer as the admin
    }

    function addStudent(address studentAddress, uint256 score, string memory name) external onlyAdmin {
    require(!students[studentAddress].exists, "Student already added.");
    students[studentAddress] = Student(true, score, name, 0);
    }

    function viewMyGrade() public view onlyStudent returns (uint256) {
        return students[msg.sender].score; // Return the student's score
    }

    function isStudent(address student) public view returns (bool) {
        return students[student].exists; // Check if the address is a registered student
    }


    function getStudentScore(address studentAddress) public view returns (uint256) {
        require(students[studentAddress].exists, "Student does not exist.");
        return students[studentAddress].score; // Return the score of the specified student
    }

    function getStudentName(address studentAddress) public view returns (string memory) {
        require(students[studentAddress].exists, "Student does not exist.");
        return students[studentAddress].name; // Return the name of the specified student
    }
}
