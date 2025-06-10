// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StudentGrades.sol";

contract StudentGradesTest is Test {
    StudentGrades public studentGrades;

    address admin;
    address student1;
    address student2;
    address outsider;

    function setUp() public {
        admin = address(0xA11CE);
        student1 = address(0xB0B);
        student2 = address(0xC0C);
        outsider = address(0xD00D);

        // Deploy contract as admin
        vm.prank(admin);
        studentGrades = new StudentGrades();

        // Add students
        vm.prank(admin);
        studentGrades.addStudent(student1, 85, "Alice");

        vm.prank(admin);
        studentGrades.addStudent(student2, 92, "Bob");
    }

    function testAddStudent() public {
        vm.prank(admin);
        studentGrades.addStudent(address(0xE0E), 75, "Eve");

        bool isAdded = studentGrades.isStudent(address(0xE0E));
        assertTrue(isAdded, "Eve should be added");
    }

    function testAddStudentFailsIfNotAdmin() public {
        vm.expectRevert("Only admin can perform this action.");
        vm.prank(outsider);
        studentGrades.addStudent(outsider, 66, "Hacker");
    }

    function testAddDuplicateStudentFails() public {
        vm.expectRevert("Student already added.");
        vm.prank(admin);
        studentGrades.addStudent(student1, 77, "Fake Alice");
    }

    function testViewMyGrade() public {
        vm.prank(student2);
        uint256 grade = studentGrades.viewMyGrade();
        assertEq(grade, 92, "Grade should be 92 for Bob");
    }

    function testViewMyGradeFailsIfNotStudent() public {
        vm.expectRevert("You are not a registered student.");
        vm.prank(outsider);
        studentGrades.viewMyGrade();
    }

    function testGetStudentScore() public {
        uint256 score = studentGrades.getStudentScore(student1);
        assertEq(score, 85, "Score should be 85 for Alice");
    }

    function testGetStudentName() public {
        string memory name = studentGrades.getStudentName(student2);
        assertEq(name, "Bob", "Name should be Bob");
    }

    function testIsStudent() public {
        assertTrue(studentGrades.isStudent(student1));
        assertTrue(studentGrades.isStudent(student2));
        assertFalse(studentGrades.isStudent(outsider));
    }
}
