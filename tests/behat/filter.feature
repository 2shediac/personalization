@filter @filter_personalization @javascript
Feature: Filter replacements.

    Background:
        Given the following "users" exist:
            | username | firstname | lastname | idnumber | email | phone1 | phone2 | address | city | country |
            | teacher1 | John | Doe | idteacher1 | teacher1@example.com | 1111111111 | 2222222222 | 123 Fake St. | Toronto | CA |
            | student1 | Janie | Smith | idstudent1 | student1@example.com | 3333333333 | 4444444444 | 456 Notareal St. | New York | US |
            | student2 | John | Smith | idstudent1 | student2@example.com | 5555555555 | 6666666666 | 777 Long St. | Florida | US |
        And the following "courses" exist:
            | fullname | shortname | category | idnumber | summary |
            | Course 1 | C1 | 0 | idnc1 | This is a test course |
        And the following "course enrolments" exist:
            | user | course | role |
            | teacher1 | C1 | editingteacher |
            | student1 | C1 | student |
            | student2 | C1 | student |
        And the "personalization" filter is enabled

    Scenario: Basic user fields.
        Given the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | <div id="filter_personalization_username">Hello {USER_USERNAME}.</div><div id="filter_personalization_idnumber">Your IDNumber is {USER_IDNUMBER}.</div><div id="filter_personalization_email">Your email address is {USER_EMAIL}.</div><div id="filter_personalization_names">Your first name is {USER_FIRSTNAME}. Your last name is {USER_LASTNAME}. Your full name is {USER_FULLNAME}.</div><div id="filter_personalization_phone">Your phone numbers are {USER_PHONE1} and {USER_PHONE2}.</div><div id="filter_personalization_address">Your address is {USER_ADDRESS} {USER_CITY} {USER_COUNTRY}</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1" in the "#filter_personalization_username" "css_element"
        And I should see "Your IDNumber is idteacher1" in the "#filter_personalization_idnumber" "css_element"
        And I should see "Your email address is teacher1@example.com." in the "#filter_personalization_email" "css_element"
        And I should see "Your first name is John. Your last name is Doe. Your full name is John Doe." in the "#filter_personalization_names" "css_element"
        And I should see "Your phone numbers are 1111111111 and 2222222222." in the "#filter_personalization_phone" "css_element"
        And I should see "Your address is 123 Fake St. Toronto CA" in the "#filter_personalization_address" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1" in the "#filter_personalization_username" "css_element"
        And I should see "Your IDNumber is idstudent1" in the "#filter_personalization_idnumber" "css_element"
        And I should see "Your email address is student1@example.com." in the "#filter_personalization_email" "css_element"
        And I should see "Your first name is Janie. Your last name is Smith. Your full name is Janie Smith." in the "#filter_personalization_names" "css_element"
        And I should see "Your phone numbers are 3333333333 and 4444444444." in the "#filter_personalization_phone" "css_element"
        And I should see "Your address is 456 Notareal St. New York US" in the "#filter_personalization_address" "css_element"

    Scenario: Basic course fields.
        Given the course start date for "C1" is set to "July 24, 2016 9:00am"
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | <div id="filter_personalization_username">Hello {USER_USERNAME}.</div><div id="filter_personalization_coursename">Welcome to {COURSE_FULLNAME} ({COURSE_SHORTNAME}).</div><div id="filter_personalization_courseidnumber">The ID Number of this course is {COURSE_IDNUMBER}.</div><div id="filter_personalization_coursesummary">The course summary is {COURSE_SUMMARY}.</div><div id="filter_personalization_coursestart">The course starts {COURSE_STARTDATE}.</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1" in the "#filter_personalization_username" "css_element"
        And I should see "Welcome to Course 1 (C1)" in the "#filter_personalization_coursename" "css_element"
        And I should see "The ID Number of this course is idnc1" in the "#filter_personalization_courseidnumber" "css_element"
        And I should see "The course summary is This is a test course" in the "#filter_personalization_coursesummary" "css_element"
        And I should see "The course starts Sunday, 24 July 2016, 9:00 AM" in the "#filter_personalization_coursestart" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1" in the "#filter_personalization_username" "css_element"
        And I should see "Welcome to Course 1 (C1)" in the "#filter_personalization_coursename" "css_element"
        And I should see "The ID Number of this course is idnc1" in the "#filter_personalization_courseidnumber" "css_element"
        And I should see "The course summary is This is a test course" in the "#filter_personalization_coursesummary" "css_element"
        And I should see "The course starts Sunday, 24 July 2016, 9:00 AM" in the "#filter_personalization_coursestart" "css_element"

    @user_course_fields
    Scenario: User Course fields.
        Given the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | <div id="filter_personalization_username">Hello {USER_USERNAME}.</div><div id="filter_personalization_coursename">Welcome to {COURSE_FULLNAME} ({COURSE_SHORTNAME}).</div><div id="filter_personalization_enroldate">You were enrolled in this course on {COURSE_USER_ENROLDATE}.</div><div id="filter_personalization_grade">Your current grade is {COURSE_USER_GRADE}.</div><div id="filter_personalization_role">Your current role is {COURSE_USER_ROLE}.</div> |
        And I log in as "teacher1"
        And I am on site homepage
        And I follow "C1"
        And I click on "Grades" "text" in the "#nav-drawer" "css_element"
        And I click on "Setup" "text" in the ".grade-navigation" "css_element"
        And I press "Add grade item"
        And I set the following fields to these values:
            | Item name | Manual item 1 |
            | Minimum grade | 0 |
        And I press "Save changes"
        And I am on site homepage
        And I follow "C1"
        And I click on "Grades" "text" in the "#nav-drawer" "css_element"
        And I turn editing mode on
        And I give the grade "75.00" to the user "Janie Smith" for the grade item "Manual item 1"
        And I press "Save changes"
        And I log out
        And the enrolment date for "teacher1" in course "C1" is set to "February 3, 2016 9:00pm"
        And the enrolment date for "student1" in course "C1" is set to "February 4, 2016 10:00pm"
        And the enrolment date for "student2" in course "C1" is set to "February 4, 2016 10:00pm"
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1" in the "#filter_personalization_username" "css_element"
        And I should see "Welcome to Course 1 (C1)" in the "#filter_personalization_coursename" "css_element"
        And I should see "You were enrolled in this course on Wednesday, 3 February 2016, 9:00 PM." in the "#filter_personalization_enroldate" "css_element"
        And I should see "Your current grade is No grade." in the "#filter_personalization_grade" "css_element"
        And I should see "Your current role is editingteacher." in the "#filter_personalization_role" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1" in the "#filter_personalization_username" "css_element"
        And I should see "Welcome to Course 1 (C1)" in the "#filter_personalization_coursename" "css_element"
        And I should see "You were enrolled in this course on Thursday, 4 February 2016, 10:00 PM." in the "#filter_personalization_enroldate" "css_element"
        And I should see "Your current grade is 75." in the "#filter_personalization_grade" "css_element"
        And I should see "Your current role is student." in the "#filter_personalization_role" "css_element"
        When I log out
        And I log in as "student2"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student2" in the "#filter_personalization_username" "css_element"
        And I should see "Welcome to Course 1 (C1)" in the "#filter_personalization_coursename" "css_element"
        And I should see "You were enrolled in this course on Thursday, 4 February 2016, 10:00 PM." in the "#filter_personalization_enroldate" "css_element"
        And I should see "Your current grade is No grade." in the "#filter_personalization_grade" "css_element"
        And I should see "Your current role is student." in the "#filter_personalization_role" "css_element"

    Scenario: Role field should have multiple values if present.
        Given the following "course enrolments" exist:
            | user | course | role |
            | teacher1 | C1 | manager |
            | student1 | C1 | student |
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | <div id="filter_personalization_username">Hello {USER_USERNAME}.</div><div id="filter_personalization_role">Your role(s) in this course: {COURSE_USER_ROLE}</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1" in the "#filter_personalization_username" "css_element"
        And I should see "Your role(s) in this course: manager, editingteacher" in the "#filter_personalization_role" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1" in the "#filter_personalization_username" "css_element"
        And I should see "Your role(s) in this course: student" in the "#filter_personalization_role" "css_element"

    Scenario: Group and grouping fields.
        Given the following "groups" exist:
            | name | course | idnumber |
            | Test Group 1 | C1 | testgroup1 |
            | Test Group 2 | C1 | testgroup2 |
        And the following "group members" exist:
            | user | group |
            | teacher1 | testgroup1 |
            | student1 | testgroup1 |
            | teacher1 | testgroup2 |
        And the following "groupings" exist:
            | name | course | idnumber |
            | Test Grouping 1 | C1 | testgrouping1 |
            | Test Grouping 2 | C1 | testgrouping2 |
        And the following "grouping groups" exist:
            | grouping | group |
            | testgrouping1 | testgroup1 |
            | testgrouping2 | testgroup2 |
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | <div id="filter_personalization_username">Hello {USER_USERNAME}.</div><div id="filter_personalization_group">Your groups in this course are: {COURSE_USER_GROUP}.</div><div id="filter_personalization_grouping">Your groupings in this course are: {COURSE_USER_GROUPING}</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1" in the "#filter_personalization_username" "css_element"
        And I should see "Your groups in this course are: Test Group 1, Test Group 2" in the "#filter_personalization_group" "css_element"
        And I should see "Your groupings in this course are: Test Grouping 1, Test Grouping 2" in the "#filter_personalization_grouping" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1" in the "#filter_personalization_username" "css_element"
        And I should see "Your groups in this course are: Test Group 1" in the "#filter_personalization_group" "css_element"
        And I should see "Your groupings in this course are: Test Grouping 1" in the "#filter_personalization_grouping" "css_element"

    Scenario: User picture field.
        Given the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | Hello {USER_USERNAME}. Here is your picture: {USER_PICTURE}. |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1. Here is your picture:"
        And "img.userpicture" "css_element" should exist in the "#region-main" "css_element"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1. Here is your picture:"
        And "img.userpicture" "css_element" should exist in the "#region-main" "css_element"

    Scenario: User last login field.
        Given the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | Hello {USER_USERNAME}. You last logged in {USER_LASTLOGIN}. |
        When I log in as "teacher1"
        And I follow "C1"
        And the last login for user "teacher1" is set to "September 6, 2016 9:45am"
        And I follow "Test page 1"
        Then I should see "Hello teacher1. You last logged in Tuesday, 6 September 2016, 9:45 AM"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And the last login for user "student1" is set to "September 15, 2016 11:45am"
        And I follow "Test page 1"
        Then I should see "Hello student1. You last logged in Thursday, 15 September 2016, 11:45 AM"

    Scenario: User custom fields.
        Given the following user custom fields exist:
            | shortname | name | datatype | visible |
            | customfield1 | Test custom field 1 | text | 2 |
        And custom field "customfield1" for user "teacher1" is set to "This is a test custom field value"
        And custom field "customfield1" for user "student1" is set to "This is another test custom field value"
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | Hello {USER_USERNAME}. The custom field value is {USER_FIELD_customfield1}. |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello teacher1. The custom field value is This is a test custom field value"
        When I log out
        And I log in as "student1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Hello student1. The custom field value is This is another test custom field value"

    Scenario: Course teacher tokens.
        Given the following "users" exist:
            | username | firstname | lastname | idnumber | email | country |
            | manager1 | Jane | Murphy | idmanager1 | manager1@example.com | CA |
            | manager2 | Bob | Smith | idmanager2 | manager2@example.com | CA |
            | coursecreator1 | Jennifer | Brown | idcoursecreator1 | coursecreator1@example.com | CA |
            | editingteacher1 | Frank | Tremblay | editingteacher1 | editingteacher1@example.com | CA |
            | teacher2 | Michelle | Wilson | teacher2 | teacher2@example.com | CA |
        And the following "course enrolments" exist:
            | user | course | role |
            | manager1 | C1 | manager |
            | manager2 | C1 | manager |
            | coursecreator1 | C1 | coursecreator |
            | editingteacher1 | C1 | editingteacher |
            | teacher2 | C1 | teacher |
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | Hello {USER_USERNAME}. <div id="filter_personalization_manager_fullname">{COURSE_MANAGER_FULLNAME}</div><div id="filter_personalization_manager_email">{COURSE_MANAGER_EMAIL}</div><div id="filter_personalization_coursecreator_fullname">{COURSE_COURSECREATOR_FULLNAME}</div><div id="filter_personalization_coursecreator_email">{COURSE_COURSECREATOR_EMAIL}</div><div id="filter_personalization_editingteacher_fullname">{COURSE_EDITINGTEACHER_FULLNAME}</div><div id="filter_personalization_editingteacher_email">{COURSE_EDITINGTEACHER_EMAIL}</div><div id="filter_personalization_teacher_fullname">{COURSE_TEACHER_FULLNAME}</div><div id="filter_personalization_teacher_email">{COURSE_TEACHER_EMAIL}</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "Jane Murphy, Bob Smith" in the "#filter_personalization_manager_fullname" "css_element"
        And I should see "manager1@example.com, manager2@example.com" in the "#filter_personalization_manager_email" "css_element"
        And I should see "Jennifer Brown" in the "#filter_personalization_coursecreator_fullname" "css_element"
        And I should see "coursecreator1@example.com" in the "#filter_personalization_coursecreator_email" "css_element"
        And I should see "John Doe, Frank Tremblay" in the "#filter_personalization_editingteacher_fullname" "css_element"
        And I should see "teacher1@example.com, editingteacher1@example.com" in the "#filter_personalization_editingteacher_email" "css_element"
        And I should see "Michelle Wilson" in the "#filter_personalization_teacher_fullname" "css_element"
        And I should see "teacher2@example.com" in the "#filter_personalization_teacher_email" "css_element"

    Scenario: Course teacher tokens when no users exist.
        Given the following "users" exist:
            | username | firstname | lastname | idnumber | email | country |
        And the following "activities" exist:
            | activity | course | idnumber | name | intro | content |
            | page | C1 | testpage1 | Test page 1 | Test page 1 description | Hello {USER_USERNAME}. <div id="filter_personalization_manager_fullname">{COURSE_MANAGER_FULLNAME}</div><div id="filter_personalization_manager_email">{COURSE_MANAGER_EMAIL}</div><div id="filter_personalization_coursecreator_fullname">{COURSE_COURSECREATOR_FULLNAME}</div><div id="filter_personalization_coursecreator_email">{COURSE_COURSECREATOR_EMAIL}</div><div id="filter_personalization_editingteacher_fullname">{COURSE_EDITINGTEACHER_FULLNAME}</div><div id="filter_personalization_editingteacher_email">{COURSE_EDITINGTEACHER_EMAIL}</div><div id="filter_personalization_teacher_fullname">{COURSE_TEACHER_FULLNAME}</div><div id="filter_personalization_teacher_email">{COURSE_TEACHER_EMAIL}</div> |
        When I log in as "teacher1"
        And I follow "C1"
        And I follow "Test page 1"
        Then I should see "-" in the "#filter_personalization_manager_fullname" "css_element"
        And I should see "-" in the "#filter_personalization_manager_email" "css_element"
        And I should see "-" in the "#filter_personalization_coursecreator_fullname" "css_element"
        And I should see "-" in the "#filter_personalization_coursecreator_email" "css_element"
        And I should see "John Doe" in the "#filter_personalization_editingteacher_fullname" "css_element"
        And I should see "teacher1@example.com" in the "#filter_personalization_editingteacher_email" "css_element"
        And I should see "-" in the "#filter_personalization_teacher_fullname" "css_element"
        And I should see "-" in the "#filter_personalization_teacher_email" "css_element"

    Scenario: Guest can view site summary
       When I log in as "admin"
       And I am on site homepage
       And I turn editing mode on
       And I add the "Course/site summary" block
       And I am on site homepage
       And I navigate to "Edit settings" in current page administration
       And I set the following fields to these values:
       | summary | Last Name {USER_LASTNAME} First Name {USER_FIRSTNAME} Full Site Name {COURSE_FULLNAME} Short Site Name {COURSE_SHORTNAME}|
       And I press "Save changes"
       And I log out
       When I am on site homepage
       Then "Course/site summary" "block" should exist
       And I should not see "Course summary" in the "Course/site summary" "block"
       And I should see "Last Name Guest First Name Guest Full Site Name Acceptance test site Short Site Name Acceptance test site" in the "Course/site summary" "block"
