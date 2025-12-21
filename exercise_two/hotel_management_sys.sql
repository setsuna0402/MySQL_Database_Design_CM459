USE exercise_two_hotel_sys;

CREATE TABLE exercise_two_hotel_sys.Hotel (
    hotel_id       INT           AUTO_INCREMENT PRIMARY KEY,
    hotel_name     VARCHAR(500)  NOT NULL UNIQUE,
    hotel_location VARCHAR(1000) NOT NULL,
    rating         DECIMAL(2,1)
);

CREATE TABLE exercise_two_hotel_sys.Room (
	room_id     INT          AUTO_INCREMENT PRIMARY KEY,
    hotel_id    INT          NOT NULL,
    room_number INT          NOT NULL UNIQUE,
    room_type   VARCHAR(100) NOT NULL,
    room_price  DECIMAL(8,2) NOT NULL,
    room_status VARCHAR(500) NOT NULL,
    CONSTRAINT ck_room_price
		CHECK(room_price >= 0)
);

CREATE TABLE exercise_two_hotel_sys.Guest (
	guest_id      INT          AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    phone_number  VARCHAR(15)  UNIQUE,
    email_address VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE exercise_two_hotel_sys.Reservation (
	reservation_id     INT          AUTO_INCREMENT PRIMARY KEY,
    guest_id           INT          NOT NULL,
    room_id            INT          NOT NULL,
    check_in_date      TIMESTAMP    NOT NULL,
    check_out_date     TIMESTAMP    NOT NULL,
    reservation_status VARCHAR(500) NOT NULL,
    CONSTRAINT fk_reservation_guest_id
		FOREIGN KEY (guest_id)
        REFERENCES exercise_two_hotel_sys.Guest (guest_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_reservation_room_id
		FOREIGN KEY (room_id)
        REFERENCES exercise_two_hotel_sys.Room (room_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE exercise_two_hotel_sys.Staff (
	staff_id   INT          AUTO_INCREMENT PRIMARY KEY,
    hotel_id   INT          NOT NULL,
    first_name VARCHAR(50)  NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    position   VARCHAR(200) NOT NULL,
    salary     DECIMAL(8,2),
    CONSTRAINT fk_staff_hotel_id
		FOREIGN KEY (hotel_id)
        REFERENCES exercise_two_hotel_sys.Hotel (hotel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT ck_staff_salary
		CHECK(salary >= 0)
);

# Question one
CREATE TABLE exercise_two_hotel_sys.Service (
	service_id     INT          AUTO_INCREMENT PRIMARY KEY,
    service_name   VARCHAR(100) NOT NULL UNIQUE,
    service_price  DECIMAL(8,2) NOT NULL,
    CONSTRAINT ck_service_price 
		CHECK(service_price  >= 0)
);

CREATE TABLE exercise_two_hotel_sys.Reservation_Service (
	reservation_id   INT        NOT NULL,
    service_id       INT        NOT NULL,
    service_datetime TIMESTAMP  NOT NULL,

    CONSTRAINT fk_reservation_service_detail_reservation_id
		FOREIGN KEY (reservation_id)
        REFERENCES exercise_two_hotel_sys.Reservation (reservation_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_reservation_service_detail_service_id
		FOREIGN KEY (service_id)
        REFERENCES exercise_two_hotel_sys.Service (service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

# Question two
ALTER TABLE exercise_two_hotel_sys.Guest ADD wechatID VARCHAR(50);

# Question three
# Add a table to record the guest feedback
CREATE TABLE exercise_two_hotel_sys.Guest_Feedback (
	guest_id        INT          NOT NULL,
    staff_id        INT          NULL,
    service_id      INT          NULL,
    record_datetime TIMESTAMP    NOT NULL,
    rating          DECIMAL(2)   NOT NULL,
    feedback        VARCHAR(500),

    CONSTRAINT fk_Guest_Staff_feedback_guest_id
		FOREIGN KEY (guest_id)
        REFERENCES exercise_two_hotel_sys.Guest (guest_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_Guest_Staff_feedback_staff_id
		FOREIGN KEY (staff_id)
        REFERENCES exercise_two_hotel_sys.Staff (staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_Guest_Staff_feedback_service_id
		FOREIGN KEY (service_id)
        REFERENCES exercise_two_hotel_sys.Service (service_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

# Question four
# Add three columns to record the original_price, total_price and discount_amount and reservation_desc for recording general information
ALTER TABLE exercise_two_hotel_sys.Reservation ADD total_price      DECIMAL(8,2) NOT NULL;
ALTER TABLE exercise_two_hotel_sys.Reservation ADD original_price   DECIMAL(8,2) NOT NULL;
ALTER TABLE exercise_two_hotel_sys.Reservation ADD discount_amount  DECIMAL(8,2) NULL;
ALTER TABLE exercise_two_hotel_sys.Reservation ADD reservation_desc DECIMAL(8,2) NULL;

# Question five
ALTER TABLE exercise_two_hotel_sys.Staff MODIFY COLUMN first_name VARCHAR(100);

# Question Six
ALTER TABLE exercise_two_hotel_sys.Room
ADD CONSTRAINT fk_room_hotel_id
FOREIGN KEY (hotel_id)
REFERENCES exercise_two_hotel_sys.Hotel(hotel_id)
ON UPDATE CASCADE
ON DELETE CASCADE;