<?php
// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Behat step definitions for filter_personalization.
 *
 * @package filter_personalization
 * @copyright 2017 James McQuillan <james.mcquillan@remote-learner.net>
 * @license http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

require_once(__DIR__.'/../../../../lib/behat/behat_base.php');

use Behat\Gherkin\Node\TableNode as TableNode;

/**
 * Step definitions class
 */
class behat_filter_personalization extends \behat_base {
    /**
     * @Given the :arg1 filter is enabled
     */
    public function the_filter_is_enabled($arg1) {
        global $DB;
        $filterrec = $DB->get_record('filter_active', ['filter' => $arg1]);
        if (!empty($filterrec)) {
            $filterrec->active = 1;
            $DB->update_record('filter_active', $filterrec);
        } else {
            $systemcontext = \context_system::instance();
            $newrec = new \stdClass;
            $newrec->filter = 'personalization';
            $newrec->contextid = $systemcontext->id;
            $newrec->active = 1;
            $newrec->sortorder = 9999;
            $DB->insert_record('filter_active', $newrec);
        }
    }

    /**
     * @Given the course start date for :arg1 is set to :arg2
     */
    public function the_course_start_date_for_is_set_to($arg1, $arg2) {
        global $DB;
        $course = $DB->get_record('course', ['shortname' => $arg1], '*', MUST_EXIST);

        $timestamp = strtotime($arg2);
        if (empty($timestamp)) {
            throw new \Exception('Could not parse timestamp');
        }

        $course->startdate = $timestamp;
        $DB->update_record('course', $course);
    }

    /**
     * @Given the enrolment date for :arg1 in course :arg2 is set to :arg3
     */
    public function the_enrolment_date_for_in_course_is_set_to($arg1, $arg2, $arg3) {
        global $DB;
        $course = $DB->get_record('course', ['shortname' => $arg2], '*', MUST_EXIST);
        $user = $DB->get_record('user', ['username' => $arg1], '*', MUST_EXIST);
        $sql = 'SELECT ue.*
                  FROM {user_enrolments} ue
                  JOIN {enrol} e ON e.id = ue.enrolid AND e.courseid = ?
                 WHERE ue.userid = ?';
        $params = [$course->id, $user->id];
        $enrolrec = $DB->get_record_sql($sql, $params, IGNORE_MULTIPLE);
        $timestamp = strtotime($arg3);
        if (empty($timestamp)) {
            throw new \Exception('Could not parse intended enrol date.');
        }
        $enrolrec->timecreated = $timestamp;
        $DB->update_record('user_enrolments', $enrolrec);
    }

    /**
     * @Given the last login for user :arg1 is set to :arg2
     */
    public function the_last_login_for_user_is_set_to($arg1, $arg2) {
        global $DB;
        $user = $DB->get_record('user', ['username' => $arg1], '*', MUST_EXIST);
        $timestamp = strtotime($arg2);
        if (empty($timestamp)) {
            throw new \Exception('Could not parse intended last login time');
        }

        $user->lastlogin = $timestamp;
        $DB->update_record('user', $user);
    }

    /**
     * @Given the following user custom fields exist:
     */
    public function the_following_user_custom_fields_exist(TableNode $table) {
        global $DB;

        $categories = $DB->get_records('user_info_category');
        if (empty($categories)) {
            $category = new \stdClass;
            $category->name = 'Other fields';
            $category->sortorder = 1;
            $category->id = $DB->insert_record('user_info_category', $category);
        } else {
            $category = array_shift($categories);
        }

        $tablehash = $table->getHash();
        foreach ($tablehash as $row) {
            $row = (object)$row;
            $row->categoryid = $category->id;
            $DB->insert_record('user_info_field', $row);
        }
    }

    /**
     * @Given custom field :arg1 for user :arg2 is set to :arg3
     */
    public function custom_field_for_user_is_set_to($arg1, $arg2, $arg3) {
        global $DB;
        $field = $DB->get_record('user_info_field', ['shortname' => $arg1], '*', MUST_EXIST);
        $user = $DB->get_record('user', ['username' => $arg2], '*', MUST_EXIST);
        $data = $DB->get_record('user_info_data', ['userid' => $user->id, 'fieldid' => $field->id]);
        if (empty($data)) {
            $data = new \stdClass;
            $data->userid = $user->id;
            $data->fieldid = $field->id;
            $data->data = $arg3;
            $DB->insert_record('user_info_data', $data);
        } else {
            $data->data = $arg3;
            $DB->update_record('user_info_data', $data);
        }
    }
}
