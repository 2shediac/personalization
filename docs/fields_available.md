# Summary 
The personalization filter is a plugin that filters text and replaces it with user-specific information. This will allow administrators and instructors to enter personalized text into courses. 


# Example:
Hello {USER_FIRSTNAME}! Welcome to {COURSE_FULLNAME}! 
This course starts on {COURSE_STARTDATE}.
After the course ends, your grade will be sent to {USER_MANAGER}.

Would become:
Hello Bob! Welcome to Moodle development 101!
This course starts on November 1st, 2016.
After the course ends, your grade will be sent to John Smith.

## Usage
Fields
The following is the list of available fields. 

Fields will be entered using the upper-case value in the first column, surrounded by curly-brackets. Ex. {USER_USERNAME}.

### User Fields
These fields apply to the user viewing the page.

Field | Replacement Value
------------ | -------------
USER_USERNAME | The user's username.
USER_IDNUMBER | The user's ID number.
USER_EMAIL | The user's email address.
USER_FIRSTNAME | The user's first name.
USER_LASTNAME | The user's last name.
USER_FULLNAME | The user's full name.
USER_PHONE1 | The user's phone number (1).
USER_PHONE2 | The user's phone number (2).
USER_ADDRESS | The user's address.
USER_CITY | The user's city.
USER_COUNTRY | The user's country.
USER_LASTLOGIN | The date and time the user last logged in.
USER_PICTURE | The user's picture (HTML)
USER_FIELD_[field shortname] | A custom field.


### Course Fields
These fields apply to the current course being viewed.

Field | Replacement Value
------------ | -------------
COURSE_FULLNAME | The course fullname.
COURSE_SHORTNAME | The course shortname.
COURSE_IDNUMBER | The course ID number.
COURSE_SUMMARY | The course summary.
COURSE_STARTDATE | The date and time the course starts.
COURSE_USER_ENROLDATE | The date and time the current user was enrolled in the course.
COURSE_USER_GRADE | The current user's current course grade.
COURSE_USER_GROUP | The current user's course group. Comma-separated if multiple.
COURSE_USER_GROUPING | The current user's course grouping. Comma-separated if multiple.
COURSE_USER_ROLE | The current user's role in the course. Comma-separated if multiple.


