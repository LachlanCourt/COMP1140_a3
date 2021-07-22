/*drop database SCSResource;

create database SCSResource;
go
use SCSResource;*/

DROP TABLE loan
DROP TABLE reservation
DROP TABLE resourceRequired
DROP TABLE acquisitionRequest
DROP TABLE studentReceivesCourseOffering
DROP TABLE courseOfferingGrantsPrivilege
DROP TABLE staffMember
DROP TABLE studentMember
DROP TABLE privilege
DROP TABLE courseOffering
DROP TABLE semesterDetails
DROP TABLE movableResource
DROP TABLE immovableResource
DROP TABLE category
DROP TABLE resourceDetails
DROP TABLE location
go

CREATE TABLE resourceDetails (
	modelID			char(10) NOT NULL,
	model			varchar(30),
	make			varchar(30),
	manufacturer	varchar(30),
	description		varchar(400),
	name			varchar(30) DEFAULT 'New Resource',
	year			int,
	assetValue		smallmoney,
	PRIMARY KEY (modelID)
	);
go

CREATE TABLE category (
    categoryID		char(10) NOT NULL,
	name			varchar(30) DEFAULT 'New category',
    Description		varchar(400),
	maxBorrowTime   int,
	PRIMARY KEY		(categoryID),
	);
go

CREATE TABLE location (
	locationID		char(10) NOT NULL,
	roomNumber		varchar(30),
	building		varchar(30),
	campus			varchar(30),
	PRIMARY KEY (locationID)
	);
go

CREATE TABLE movableResource (
	movableResourceID	char(10) NOT NULL,
	categoryID			char(10),
	modelID				char(10),
	locationID			char(10),
	presentStatus		varchar(12),
	PRIMARY KEY			(movableResourceID),
	FOREIGN KEY (categoryID) REFERENCES category ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (modelID) REFERENCES resourceDetails ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (locationID) REFERENCES location ON UPDATE CASCADE ON DELETE NO ACTION
	);
go

CREATE TABLE immovableResource (
	immovableResourceID		char(10) NOT NULL,
	categoryID				char(10),
	locationID				char(10),
	presentStatus			varchar(12),
	description				varchar(400) DEFAULT 'New resource',
	capacity				tinyint,
	facilities				varchar(400),
	PRIMARY KEY (immovableResourceID),
	FOREIGN KEY (categoryID) REFERENCES category ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (locationID) REFERENCES location ON UPDATE CASCADE ON DELETE NO ACTION
	);
go


CREATE TABLE semesterDetails (
	semesterOffered		tinyint NOT NULL,
	courseStartDate		date,
	courseEndDate		date,
	PRIMARY KEY (semesterOffered),
	);
go

CREATE TABLE courseOffering (
	offeringID			char(10) NOT NULL,
	semesterOffered		tinyint,
	courseID			varchar(10),
	courseName			varchar(50) DEFAULT 'New course',
	yearOffered			int,
	PRIMARY KEY (offeringID),
	FOREIGN KEY (semesterOffered) REFERENCES semesterDetails ON UPDATE CASCADE ON DELETE NO ACTION
	);
go

CREATE TABLE privilege (
	privilegeID			char(10) NOT NULL,
	name				varchar(30) DEFAULT 'New privilege',
	description			varchar(400),
	resourceCategory	varchar(30),
	maxLoans			int,
	PRIMARY KEY (privilegeID)
	);
go

CREATE TABLE studentMember (
	studentID		char(10) NOT NULL,
	name			varchar(30) DEFAULT 'New student',
	address			varchar(100),
	phoneNumber		varchar(12),
	email			varchar(50),
	status			bit DEFAULT 1,
	comments		VARCHAR(400),
	demeritPoints	tinyint,
	PRIMARY KEY (studentID)
	);
go

CREATE TABLE staffMember (
	staffID			char(10) NOT NULL,
	name			varchar(30) DEFAULT 'New staff', 
	address			varchar(100), 
	phoneNumber		varchar(12), 
	email			varchar(50), 
	status			bit DEFAULT 1, 
	comments		varchar(400), 
	role			varchar(30)
	PRIMARY KEY (staffID)
	);
go

CREATE TABLE courseOfferingGrantsPrivilege (
	offeringID		char(10) NOT NULL,
	privilegeID		char(10) NOT NULL,
	PRIMARY KEY (offeringID, privilegeID),
	FOREIGN KEY (offeringID) REFERENCES courseOffering ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (privilegeID) REFERENCES privilege ON UPDATE CASCADE ON DELETE  NO ACTION
	);
go

CREATE TABLE studentReceivesCourseOffering (
	studentOfferingID	char(10) NOT NULL,
	courseOfferingID	char(10) NOT NULL,
	PRIMARY KEY (studentOfferingID, courseOfferingID),
	FOREIGN KEY (studentOfferingID) REFERENCES studentMember(studentID) ON UPDATE CASCADE ON DELETE NO ACTION,
	FOREIGN KEY (courseOfferingID) REFERENCES courseOffering(offeringID) ON UPDATE CASCADE ON DELETE NO ACTION
	);
go

CREATE TABLE acquisitionRequest (
	acquisitionID	char(10) NOT NULL,
	urgency			tinyint,
	status			varchar(12),
	fundCode		varchar(30),
	vendorCode		varchar(30),
	notes			varchar(400),
	studentID		char(10),
	staffID			char(10),
	modelID			char(10),
	PRIMARY KEY (acquisitionID),
	FOREIGN KEY (studentID) REFERENCES studentMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (staffID) REFERENCES staffMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (modelID) REFERENCES resourceDetails ON UPDATE CASCADE ON DELETE CASCADE
	);
go

CREATE TABLE resourceRequired (
	resourceRequiredID		char(10) NOT NULL, 
	dueDateTime				datetime, 
	movableResourceID		char(10), 
	immovableResourceID		char(10),
	PRIMARY KEY (resourceRequiredID),
	FOREIGN KEY (movableResourceID) REFERENCES movableResource ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY (immovableResourceID) REFERENCES immovableResource ON UPDATE NO ACTION ON DELETE NO ACTION
	);
go

CREATE TABLE reservation (
	reservationID			char(10) NOT NULL, 
	reserveDateTime			datetime, 
	studentID				char(10), 
	staffID					char(10), 
	resourceRequiredID		char(10) NOT NULL,
	PRIMARY KEY (reservationID),
	FOREIGN KEY (studentID) REFERENCES studentMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (staffID) REFERENCES staffMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (resourceRequiredID) REFERENCES resourceRequired ON UPDATE CASCADE ON DELETE CASCADE
	);
go

CREATE TABLE loan (
	loanID					char(10) NOT NULL, 
	loanedDateTime			datetime, 
	returnedDateTime		datetime, 
	studentID				char(10), 
	staffID					char(10), 
	resourceRequiredID		char(10),
	PRIMARY KEY (loanID),
	FOREIGN KEY (studentID) REFERENCES studentMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (staffID) REFERENCES staffMember ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (resourceRequiredID) REFERENCES resourceRequired ON UPDATE CASCADE ON DELETE CASCADE
	);
go

-- Insert Data --

INSERT INTO resourceDetails(modelID, model, make, manufacturer, description, name, year, assetValue) VALUES
	('5346932653','RG400','3', 'Camera co', 'Good for long range shots', 'Video camera', 2018, 300),
	('8734219425','PX320','2', 'CarmerasRus', 'Good for short range shots', 'Camera', 2017, 250),
	('9532153057','RG400','4', 'CamerasRus', 'Good for close up shots', 'Camera', 2018, 225),
	('1623456242', null, null, null, 'Book on Cosmology', 'A Brief History Of Time', 1988, 50)
go

INSERT INTO category(categoryID, name, description, maxBorrowTime) VALUES
	('6473442890', 'Cameras', 'Any camera that can take still or video', 6),
	('2376453278', 'Microphones', 'Microphones that can record audio', 6),
	('5412386354', 'Textbooks', 'Textbooks for an actively running course', 2),
	('6523456321', 'Computer lab', 'Lab of computers', 2),
	('1421432321', 'Books', 'Factual books', 48),
	('1234859321', 'Speakers', 'Can playback audio', 4)
go

INSERT INTO location(locationID, roomNumber, building, campus) VALUES
	('3746234563', '14', 'SG', 'Callaghan'),
	('7432134567', '102', 'ES', 'Callaghan'),
	('6485936612', '109', 'HG', 'Callaghan')
go

INSERT INTO movableResource(movableResourceID, categoryID, modelID, locationID, presentStatus) VALUES
	('1245657854', '6473442890', '5346932653', '3746234563', 'Loaned'),
	('9532754642', '6473442890', '8734219425', '7432134567', 'Reserved'),
	('5412763128', '6473442890', '9532153057', '6485936612', 'Loaned'),
	('2345234543', '1421432321', '1623456242', '6485936612', 'Loaned')
go

INSERT INTO immovableResource(immovableResourceID, categoryID, locationID, presentStatus, description, capacity, facilities) VALUES
	('6543231234', '6523456321', '3746234563', 'Available', 'Computer lab', 30, '30 Computers, Projector'),
	('7639847864', '6523456321', '7432134567', 'Available', 'Computer lab', 26, '26 MAC Computers, Projector'),
	('7654321234', '6523456321', '6485936612', 'Booked', 'Computer lab', 32, '32 Computers')
go

INSERT INTO semesterDetails(semesterOffered, courseStartDate, courseEndDate) VALUES
	('1', '2021-02-22', '2021-06-04'),
	('2', '2020-08-03', '2020-11-13')
go

INSERT INTO courseOffering (offeringID, semesterOffered, courseID, courseName, yearOffered) VALUES
	('1300459835', 2, 'SENG1120', 'Data Structures', 2020),
	('1932456382', 2, 'COMP1140', 'Databases and Information Management', 2020),
	('3748554321', 2, 'SENG1050', 'Web technologies', 2020),
	('2345342343', 2, 'DESN6350', 'Design for Digital Media', 2020)
go

INSERT INTO privilege (privilegeID, name, description, resourceCategory, maxLoans) VALUES
	('3473212345', 'Borrowing', 'Basic borrowing privileges', 'Books', 6),
	('3827445023', 'Lab booking', 'Allows to book a computer lab', 'Computer lab', 1), 
	('2338439212', 'Camera loan', 'Allows to borrow a camera', 'Cameras', 1),
	('2355345345', 'Speaker loan', 'Allows to borrow a speaker', 'Speakers', 3)
go

INSERT INTO studentMember (studentID, name, address, phoneNumber, email, status, comments, demeritPoints) VALUES
	('1274838475', 'Sam Waters', '3 McArthur Place', '0412345678', 'sam.waters@gmail.com', 1, '', 12),
	('7433234456', 'Peter Stevenson', '13 Ingall St', '0423485123', 'peter.stevenson@hotmail.com', 1, '', 11),
	('8433212345', 'Carol Barnard', '12 Waker Way', '0458673321', 'carol.barnard98@gmail.com', 1, '', 12)
go

INSERT INTO staffMember (staffID, name, address, phoneNumber, email, status, comments, role) VALUES
	('7323458129', 'Asha Perington', '42 Wallaby Way', '0483833764', 'asha.asha@gmail.com', 1, '', 'Demonstrator'),
	('8237923467', 'Larissa Sanders', '10 Appleseed Road', '0473995431', 'sanders.larissa@hotmail.com', 1, '', 'Lecturer'),
	('9235678345', 'Sarah Walker', '200 Cumberland Highway', '0437221234', 'sarah.walker@gmail.com', 1, '', 'Tutor')
go

INSERT INTO courseOfferingGrantsPrivilege (offeringID, privilegeID) VALUES
	('1300459835', '3473212345'),
	('1932456382', '3473212345'),
	('3748554321', '3473212345'),
	('1300459835', '3827445023'),
	('2345342343', '2355345345')
go

INSERT INTO studentReceivesCourseOffering (studentOfferingID, courseOfferingID) VALUES
	('1274838475', '1932456382'),
	('1274838475', '1300459835'),
	('7433234456', '1932456382'),
	('8433212345', '1932456382'),
	('8433212345', '2345342343')
go

INSERT INTO acquisitionRequest (acquisitionID, urgency, status, fundCode, vendorCode, notes, studentID, staffID, modelID) VALUES
	('1284756432', 6, 'acquiring', '123', '2345', '', '1274838475', NULL, '1623456242'),
	('3774213453', 2, 'investigate', '111', '5467', '', NULL, '7323458129', '9532153057'),
	('2838473834', 3, 'acquired', '456', '1233', '', '7433234456', NULL, '8734219425'),
	('1124323143', 3, 'acquired', '456', '1233', '', NULL, '7323458129', '8734219425')
go

INSERT INTO resourceRequired (resourceRequiredID, dueDateTime, movableResourceID, immovableResourceID) VALUES
	('3844371632', '2020-11-06 12:00:00', '1245657854', NULL),
	('7234627342', '2020-11-06 16:00:00', NULL, '7654321234'),
	('0987957324', '2020-11-06 12:00:00', '5412763128', NULL),
	('1234821245', '2020-11-04 12:00:00', NULL, '7654321234'),
	('1241245343', '2020-11-04 12:00:00', NULL, '7654321234'),
	('1243543234', '2020-11-04 13:00:00', '1245657854', NULL),--Camera
	('1243323454', '2020-11-05 13:00:00', '1245657854', NULL),--Camera
	('1243242132', '2020-11-04 13:00:00', '2345234543', NULL)--Book
go

INSERT INTO reservation (reservationID, reserveDateTime, studentID, staffID, resourceRequiredID) VALUES
	('1237347332', '2020-05-01 14:00:00', NULL, '7323458129', '7234627342'),
	('8238748347', '2020-06-05 10:00:00', '8433212345', NULL, '1234821245'),
	('1947823147', '2020-09-19 10:00:00', NULL, '9235678345', '1241245343'),
	('1242343432', '2020-09-19 12:00:00', NULL, '9235678345', '1241245343'),
	('2432343212', '2020-09-20 12:00:00', NULL, '9235678345', '1241245343'),
	('1242342413', '2019-09-19 12:00:00', NULL, '7323458129', '1241245343')
go

INSERT INTO loan (loanID, loanedDateTime, returnedDateTime, studentID, staffID, resourceRequiredID) VALUES
	('1237583774', '2020-11-02 12:00:00', '2020-11-04 12:14:01', '1274838475', NULL, '1243543234'),
	('3534542323', '2020-11-03 12:00:00', '2020-11-05 12:15:32', '7433234456', NULL, '1243323454'),
	('2435345321', '2020-11-02 12:00:00', '2020-11-04 12:43:01', '8433212345', NULL, '1243242132')
go

/*
select * from resourceDetails
select * from category
select * from location
select * from movableResource
select * from immovableResource
select * from semesterDetails
select * from courseOffering
select * from privilege
select * from studentMember
select * from staffMember
select * from courseOfferingGrantsPrivilege
select * from studentReceivesCourseOffering
select * from acquisitionRequest
select * from resourceRequired
select * from reservation
select * from loan
*/

-- Question 1 -- Print the name of student(s) who has/have enrolled in the course with course id COMP1140.
SELECT s.name AS [Names of Students enrolled in COMP1140]
FROM studentMember s, courseOffering c,	studentReceivesCourseOffering sc
where s.studentID = sc.studentOfferingID and sc.courseOfferingID = c.offeringID and c.courseID = 'COMP1140'

-- Question 2 -- Print the maximal number of speakers that the student with name Carol Barnard can borrow. The student is enrolled in the course with course id DESN6350. Note: speaker is a category
SELECT p.maxLoans AS [Maximal number of speakers that can be loaned]
FROM studentMember s, studentReceivesCourseOffering sc, courseOfferingGrantsPrivilege cp, privilege p, courseOffering co
where s.name = 'Carol Barnard' and s.studentID = sc.studentOfferingID and sc.courseOfferingID = cp.offeringID and cp.privilegeID = p.privilegeID and p.resourceCategory = 'Speakers' and cp.offeringID = co.offeringID and co.courseID = 'DESN6350'

-- Question 3 -- For a staff member with id number 7323458129, print his/her name and phone number, the total number of acquisition requests and the total number of reservations that the staff had made in 2019.
SELECT s.name, s.phoneNumber, COUNT(distinct a.acquisitionID) as [Number of Acquisitions], COUNT(distinct r.reservationID) as [Number of Reservations]
FROM staffMember s, acquisitionRequest a, reservation r
where s.staffID = a.staffID and (s.staffID = r.staffID and convert(varchar(20), r.reserveDateTime, 126) like '2019%')
group by s.name, s.phoneNumber

-- Question 4 -- Print the name(s) of the student member(s) who has/have borrowed the category with the name of camera, of which the model is RG400, in this year. Note: camera is a category, and model attribute must be in movable table.
SELECT s.name
FROM studentMember s, loan l, movableResource mr, resourceRequired rr, category c, resourceDetails rd
WHERE s.studentID = l.studentID and l.resourceRequiredID = rr.resourceRequiredID and rr.movableResourceID = mr.movableResourceID and mr.categoryID = c.categoryID and c.name = 'Cameras' and mr.modelID = rd.modelID and rd.model = 'RG400' and l.loanedDateTime LIKE '%2020%'

-- Question 5 -- Find the moveable resource that is the mostly loaned in the current month. Print the resource id and resource name. 
SELECT rd.modelID, rd.name
FROM movableResource mr, resourceDetails rd, loan l, resourceRequired rq
WHERE l.resourceRequiredID = rq.resourceRequiredID and rq.movableResourceID = mr.movableResourceID and mr.modelID = rd.modelID and convert(varchar(20), l.loanedDateTime, 126) like '2020-11-%'
GROUP BY rd.modelID, rd.name
HAVING count(l.loanID) > all
	(SELECT count(l2.loanID)
	FROM movableResource mr2, resourceDetails rd2, loan l2, resourceRequired rq2
	WHERE l2.resourceRequiredID = rq2.resourceRequiredID and rq2.movableResourceID = mr2.movableResourceID and mr2.modelID = rd2.modelID and rd2.modelID = rd.modelID and convert(varchar(20), l2.loanedDateTime, 126) like '%-11-%'
	GROUP BY l2.loanID
	);

-- Question 6 -- For each of the three days, including May 1, 2020, June 5, 2020 and September 19, 2020, print the date, the name of the room with name 109, and the total number of reservations made for the room on each day
SELECT convert(varchar(10), r.reserveDateTime, 126) AS [Date], l.roomNumber, count(reservationID) as [Number of reservations]
FROM reservation r, resourceRequired rr, immovableResource ir, location l
where r.resourceRequiredID = rr.resourceRequiredID and rr.immovableResourceID = ir.immovableResourceID and ir.locationID = l.locationID and l.roomNumber = '109' and (convert(varchar(20), r.reserveDateTime, 126) like '2020-05-01%' or  convert(varchar(20), r.reserveDateTime, 126) like '2020-06-05%' or convert(varchar(20), r.reserveDateTime, 126) like '2020-09-19%')
group by convert(varchar(10), r.reserveDateTime, 126), l.roomNumber