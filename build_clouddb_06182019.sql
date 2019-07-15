/* remove all tables for re-build */
SET FOREIGN_KEY_CHECKS = 0; /* allows deletion of tables that are foreign keys for other tables */

DROP TABLE IF EXISTS affiliationtypes;
DROP TABLE IF EXISTS assignmenttypes;
DROP TABLE IF EXISTS attendancetypes;
DROP TABLE 	IF EXISTS nationalcurricula;
DROP TABLE IF EXISTS devices;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS terms;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS schools;
DROP TABLE IF EXISTS sessiontypes;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS affiliations;
DROP TABLE IF EXISTS deviceloans;
DROP TABLE IF EXISTS librarybooks;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS librarybookloans;
DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS externalmarks;

SET FOREIGN_KEY_CHECKS=1;

/* create all tables */
CREATE TABLE IF NOT EXISTS affiliationtypes (
	affiliation_type VARCHAR(255) NOT NULL,
    description VARCHAR(255),
	PRIMARY KEY (affiliation_type)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS assignmenttypes (
	assignment_type VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (assignment_type)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS attendancetypes (
	attendance_type VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (attendance_type)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS nationalcurricula (
	curriculum_acronym VARCHAR(255) NOT NULL,
    curriculum_name VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (curriculum_acronym)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS devices (
	device_id INT AUTO_INCREMENT,
    owner VARCHAR(255), 		/* could be made a foreign key */
    device_type VARCHAR(255), 	/* could be made a foreign key */
    serial_number INT,
    label VARCHAR(255),
    functional_status VARCHAR(255),
    PRIMARY KEY (device_id)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS locations (
	location_name VARCHAR(255) NOT NULL,
    coordinates VARCHAR(255),
    is_school TINYINT,
    description VARCHAR(255),
    PRIMARY KEY (location_name)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS terms (
	term_startdate DATETIME NOT NULL,
    term_enddate DATE NOT NULL,
    term_number INT NOT NULL,
    PRIMARY KEY (term_startdate)
)	ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS programs (
	program_name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    PRIMARY KEY (program_name)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS schools (
	school_name VARCHAR(255) NOT NULL,
    coordinates VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (school_name)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS sessiontypes (
	session_type VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    is_mandatory TINYINT,
    PRIMARY KEY (session_type)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	gender VARCHAR(255),
	birth_date DATE,
	contact_phone INT,
	contact_email VARCHAR(255),
	postgrad_plans VARCHAR(255),
    PRIMARY KEY (student_id)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS subjects (
	subject_name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    school_affiliated TINYINT,
    axium_affiliated TINYINT,
    librarybook_affiliated TINYINT,
    PRIMARY KEY (subject_name)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS affiliations (
	affiliation_id INT AUTO_INCREMENT,
    student_id INT NOT NULL,
    term_startdate DATETIME NOT NULL,
    school_name VARCHAR(255) NOT NULL,
    affiliation_type VARCHAR(255) NOT NULL,
    program_name VARCHAR(255) NOT NULL,
	grade_level INT NOT NULL,
	left_axium TINYINT,
	reason_left_axium VARCHAR(255),
	graduated_axium TINYINT,
	left_school TINYINT,
	reason_left_school VARCHAR(255),
	switched_schools TINYINT,
	school_switched_to VARCHAR(255),
	graduated_matric TINYINT,
	repeat_grade TINYINT,
    comments VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (term_startdate) REFERENCES terms(term_startdate),
	FOREIGN KEY (school_name) REFERENCES schools(school_name),
	FOREIGN KEY (affiliation_type) REFERENCES affiliationtypes(affiliation_type),
	FOREIGN KEY (program_name) REFERENCES programs(program_name),
    FOREIGN KEY (school_switched_to) REFERENCES schools(school_name),
	PRIMARY KEY (affiliation_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS deviceloans(
	deviceloan_id INT AUTO_INCREMENT,
    device_id INT NOT NULL,
    student_id INT NOT NULL,
	checkout_date DATE NOT NULL,
    return_date DATE,
    assigned_by VARCHAR(255) NOT NULL,
    returned_to VARCHAR(255),
    deposit_paid INT NOT NULL,
    deposit_returned INT,
	FOREIGN KEY (device_id) REFERENCES devices(device_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
    PRIMARY KEY (deviceloan_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS librarybooks (
	librarybook_id VARCHAR(255) NOT NULL,
    curriculum_acronym VARCHAR(255),
    subject_name VARCHAR(255),
    fiction TINYINT,
    title VARCHAR(255) NOT NULL,
    authors VARCHAR(255),
	FOREIGN KEY (curriculum_acronym) REFERENCES nationalcurricula(curriculum_acronym),
    FOREIGN KEY (subject_name) REFERENCES subjects(subject_name),
    PRIMARY KEY (librarybook_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS sessions (
	session_id INT AUTO_INCREMENT,
    session_type VARCHAR(255) NOT NULL,
    term_startdate DATETIME NOT NULL,
    program_name VARCHAR(255) NOT NULL,
    subject_name VARCHAR(255),
    grade_level INT NOT NULL,
    location_name VARCHAR(255) NOT NULL,
	session_date DATE NOT NULL,
	teachers VARCHAR(255), 
	comments VARCHAR(255),
    FOREIGN KEY (session_type) REFERENCES sessiontypes(session_type),
    FOREIGN KEY (term_startdate) REFERENCES terms(term_startdate),
	FOREIGN KEY (program_name) REFERENCES programs(program_name),
	FOREIGN KEY (subject_name) REFERENCES subjects(subject_name),
	FOREIGN KEY (location_name) REFERENCES locations(location_name),
    PRIMARY KEY (session_id)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS assignments (
	assignment_id INT AUTO_INCREMENT,
	assignment_type VARCHAR(255) NOT NULL,
    session_id INT NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (assignment_type) REFERENCES assignmenttypes(assignment_type),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    PRIMARY KEY (assignment_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS attendance (
	attendance_id INT AUTO_INCREMENT,
	session_id INT NOT NULL,
    student_id INT NOT NULL,
    attendance_type VARCHAR(255) NOT NULL,
	warning_issued TINYINT,
	comments VARCHAR(255),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	FOREIGN KEY (attendance_type) REFERENCES attendancetypes(attendance_type),
    PRIMARY KEY (attendance_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS librarybookloans (
	librarybookloan_id INT AUTO_INCREMENT, 
	librarybook_id VARCHAR(255) NOT NULL,
    student_id INT NOT NULL,
	date_checkout DATE NOT NULL,
	date_return DATE,
    FOREIGN KEY (librarybook_id) REFERENCES librarybooks(librarybook_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	PRIMARY KEY (librarybookloan_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS marks (
	mark_id INT AUTO_INCREMENT,
    student_id INT NOT NULL,
    assignment_id INT NOT NULL,
    mark_type VARCHAR(255), /* might want to make this a foreign key */
    mark_includes VARCHAR(255), 
	mark_received INT NOT NULL,
    mark_possible INT NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(student_id),
	FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    PRIMARY KEY (mark_id)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS externalmarks (
	externalmark_id INT AUTO_INCREMENT,
    student_id INT NOT NULL,
	term_startdate DATETIME NOT NULL,
	school_name VARCHAR(255) NOT NULL,
    subject_name VARCHAR(255) NOT NULL,
	mark_type VARCHAR(255),
    mark_received INT NOT NULL,
    mark_possible INT NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (term_startdate) REFERENCES terms(term_startdate),
    FOREIGN KEY (school_name) REFERENCES schools(school_name),
    FOREIGN KEY (subject_name) REFERENCES subjects(subject_name),
    PRIMARY KEY (externalmark_id)
) ENGINE=INNODB;
