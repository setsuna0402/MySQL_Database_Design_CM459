USE exercise_three_membership_gaming_credit_sys;

CREATE TABLE exercise_three_membership_gaming_credit_sys.Countries (
	country_code VARCHAR(4)   PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);


CREATE TABLE exercise_three_membership_gaming_credit_sys.Membership_card_status (
	membercard_status_id  INT           AUTO_INCREMENT PRIMARY KEY,
    membercard_status     VARCHAR(100)  NOT NULL UNIQUE # activate etc
);

# With a propert coding method, Staff_Card_Status can describe not only the card status (activate or inactive, etc) 
# but also security control, like door access.
CREATE TABLE exercise_three_membership_gaming_credit_sys.Staff_Card_Status (
	staff_card_status_id INT           PRIMARY KEY,
    staff_card_status    INT           NOT NULL, 
    status_description   VARCHAR(500)  NOT NULL
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Staff_Positions (
	position_id    INT          AUTO_INCREMENT PRIMARY KEY,
    position       VARCHAR(100) NOT NULL UNIQUE,
    position_level TINYINT      UNSIGNED NOT NULL # total 256 levels, more than enough for a position level system
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Work_Shift_Schedule (
	shift_status_id INT          AUTO_INCREMENT PRIMARY KEY,
    assigned_shift  VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Game_Classes (
	game_class_id     INT           AUTO_INCREMENT PRIMARY KEY,
    class_name        VARCHAR(100)  NOT NULL UNIQUE,
    class_description VARCHAR(500) NOT NULL
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Games (
	game_id	         INT	        AUTO_INCREMENT PRIMARY KEY,
	game_name        VARCHAR(300)   NOT NULL UNIQUE,
	betting_odds     DECIMAL(12, 2) NOT NULL,
	game_description VARCHAR(500)  NOT NULL,
    game_class_id	 INT		    NOT NULL,
    minimum_amount   DECIMAL(12, 2) NOT NULL,
    CONSTRAINT fk_game_game_class_id
		FOREIGN KEY (game_class_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Game_Classes (game_class_id)
        ON UPDATE CASCADE
        # cancelling a game class doesn't mean to cancel the games belonged to it. 
        # here I choose to enforcing the adminstration to do arrangment. 
        ON DELETE RESTRICT  
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Gifts (
	gift_id          INT	        AUTO_INCREMENT PRIMARY KEY,
	gift_name        VARCHAR(100)   NOT NULL UNIQUE,
	gift_value       DECIMAL(12, 2) NOT NULL,
	gift_description VARCHAR(500),
    required_point   INT            NOT NULL,
    stock            INT            UNSIGNED NOT NULL,
    start_datetime	 TIMESTAMP		NOT NULL,
    end_datetime	 TIMESTAMP		NOT NULL,
    gift_status	     ENUM("redeemable", "all reserved", "out of stock", "suspending") DEFAULT "suspending" NOT NULL
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Member_Information (
	customer_id	     INT          AUTO_INCREMENT	PRIMARY KEY,
	first_name	     VARCHAR(100) NOT NULL,
    last_name	     VARCHAR(100) NOT NULL,
    contact_number   VARCHAR(15),  # Ususally, phone number is not required for membership 
	resident_address VARCHAR(500),		
	nationality_code VARCHAR(4)   NOT NULL, # For finacial inspection
    birthday         DATE         NOT NULL, # For age check
    email_address	 VARCHAR(50)  NOT NULL UNIQUE, # Since we don't require phone number, email address is set to mandatory
    CONSTRAINT fk_member_nationality_country_code
		FOREIGN KEY (nationality_code)
        REFERENCES exercise_three_membership_gaming_credit_sys.Countries (country_code)
        ON UPDATE CASCADE  # In case, the country name and code are changed
        ON DELETE RESTRICT #  disappearance of a country is rare. Require manual operation
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Staff_Information (
	staff_id	     INT          AUTO_INCREMENT	PRIMARY KEY,
	first_name	     VARCHAR(100) NOT NULL,
    last_name	     VARCHAR(100) NOT NULL,
    contact_number   VARCHAR(15)  NOT NULL UNIQUE,  # A unique contact phone number for each staff
	resident_address VARCHAR(500) NOT NULL,		
	nationality_code VARCHAR(4)   NOT NULL, 
    birthday         DATE         NOT NULL, 
    email_address	 VARCHAR(50)  NOT NULL UNIQUE, # A unique email address for each staff
    start_date       DATE         NOT NULL,
    end_date         DATE         DEFAULT NULL, 
    position_id      INT          NOT NULL,
    shift_status_id  INT          NULL,
    role_duty	     VARCHAR(500),
    CONSTRAINT fk_staff_nationality_country_code
		FOREIGN KEY (nationality_code)
        REFERENCES exercise_three_membership_gaming_credit_sys.Countries (country_code)
        ON UPDATE CASCADE  # In case, the country name and code are changed
        ON DELETE RESTRICT, #  disappearance of a country is rare. Require manual operation
	CONSTRAINT fk_staff_position_id
		FOREIGN KEY (position_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Positions (position_id)
        ON UPDATE CASCADE  # In case, the position name and level are changed
        # Cancelling a position doesn't mean to fire all the active staffs in that position
        ON DELETE RESTRICT, # In fact, the information of the resigned staffs should be kept in book.  
	CONSTRAINT fk_staff_shift_status_id
		FOREIGN KEY (shift_status_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Work_Shift_Schedule (shift_status_id)
        ON UPDATE CASCADE 
        # Cancelling a shift doesn't mean to fire all the active staffs in that period
        ON DELETE SET NULL
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Membership_Cards (
	member_card_id	     INT       AUTO_INCREMENT PRIMARY KEY,
	customer_id	         INT       NOT NULL,
    issue_date	         TIMESTAMP NOT NULL DEFAULT NOW(),
    expiry_date	         TIMESTAMP NOT NULL,
	point_balance        INT       UNSIGNED NOT NULL,
    membercard_status_id INT       NOT NULL,
    CONSTRAINT fk_membership_card_membership_status_id
		FOREIGN KEY (membercard_status_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Membership_card_status (membercard_status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_membership_card_member_information
		FOREIGN KEY (customer_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Member_Information (customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE # If the member leaves from system, cancel and delete his/her card.
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Staff_Cards (
	staff_card_id	     INT       AUTO_INCREMENT PRIMARY KEY,
	staff_id	         INT       NOT NULL,
    issue_date	         TIMESTAMP NOT NULL DEFAULT NOW(),
    expiry_date	         TIMESTAMP NOT NULL,
    staff_card_status_id INT       DEFAULT NULL, # use null to represent inactivate 
    CONSTRAINT fk_staff_card_staff_information
		FOREIGN KEY (staff_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Information (staff_id)
        ON UPDATE CASCADE
        # Again, even a staff leaves from company, we should keep his/her information in system
        ON DELETE RESTRICT, # here, I choose to ensure the staff card needs to be manuelly deleted beforing deleting the staff record 
	CONSTRAINT fk_staff_card_member_staff_card_status_id
		FOREIGN KEY (staff_card_status_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Card_Status (staff_card_status_id)
        ON UPDATE CASCADE
        # I tried to set default as inactivate, but mysql doesn't support SET DEFAULT. So, I use null here representing inactivate
        ON DELETE SET NULL 
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Pit_Information (
	pit_id         INT          AUTO_INCREMENT PRIMARY KEY,
    location	   VARCHAR(100)	NOT NULL,
    manager_id     INT          NOT NULL,
    capacity       INT          UNSIGNED NOT NULL,
    open_datetime  TIMESTAMP    NOT NULL,
    close_datetime TIMESTAMP    NOT NULL,
    pit_status	   ENUM("operating", "maintaining", "suspending", "terminated") DEFAULT "maintaining" NOT NULL,
    CONSTRAINT fk_pit_manager_id
		FOREIGN KEY (manager_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Information (staff_id)
        ON UPDATE CASCADE
        # Ensuring a manager is assigned to this pit
        ON DELETE RESTRICT 
	# Can add a Check Constraint to ensure the staff monitoring this pit is a manager. Here, I leave the front-end side to complete this function.
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Betting_Orders (
	betting_order_id     INT            AUTO_INCREMENT PRIMARY KEY,
    betting_datetime     TIMESTAMP      NOT NULL DEFAULT NOW(),
    member_card_id       INT            NOT NULL,
    total_wager_amount   DECIMAL(12, 2) NOT NULL,
    rewarded_point       INT            DEFAULT 0,
    #  A better way: set a fk to a "result table".
	betting_result	     VARCHAR(100)	NOT NULL,  # Honestly, I'm not familiar with betting results. No idea how duplicated they are.
    betting_order_status ENUM("pending", "settled", "cancelled")	DEFAULT "pending"	NOT NULL,
    dealer_id	         INT            NOT NULL,
    supervisor_id	     INT            NOT NULL,
    pit_id	             INT, # Allow null here since the corresponding pit is possible to be removed after the completion of the order
    remark	             VARCHAR(500),
    CONSTRAINT fk_betting_order_memebercard_id
		FOREIGN KEY (member_card_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Membership_Cards (member_card_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, # Disallow automatically delete the order records, even the membership no longer exists.
	CONSTRAINT fk_betting_order_dealer_id
		FOREIGN KEY (dealer_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Information (staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, #In my design, staff records remain after their resignation. 
	CONSTRAINT fk_betting_order_supervisor_id
		FOREIGN KEY (supervisor_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Staff_Information (staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,  #In my design, staff records remain after their resignation. 
	CONSTRAINT fk_betting_order_pit_id
		FOREIGN KEY (pit_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Pit_Information (pit_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL # Allow null here since the corresponding pit is possible to be removed after the completion of the order
	# Can add Check Constraints to ensure the assignments of staffs are correct. Here, I leave the front-end side to complete this function.
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Betting_Order_Details (
	betting_order_id INT            NOT NULL,
    game_id          INT            NOT NULL,
    wager_amount     DECIMAL(12, 2)	NOT NULL,
    betting_odds     DECIMAL(12, 2)	NOT NULL, 
    PRIMARY KEY (betting_order_id, game_id), # Composite primary key, ensuring a game involves only once in a betting order.

    CONSTRAINT fk_betting_order_detail_betting_order_id
		FOREIGN KEY (betting_order_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Betting_Orders (betting_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, # Delete the betting order delete if the betting order is deleted.
	CONSTRAINT fk_betting_order_detail_game_id
		FOREIGN KEY (game_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Games (game_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT # We should not remove a game which had been deployed from the record. So I enforce adminstration to manually handle the data, if it happens.
);


CREATE TABLE exercise_three_membership_gaming_credit_sys.Point_Reward_Records (
	reward_record_id INT       AUTO_INCREMENT PRIMARY KEY,
    reward_date      TIMESTAMP NOT NULL DEFAULT NOW(),
    member_card_id   INT       NOT NULL,
    reward_point     INT       UNSIGNED  NOT NULL,
	betting_order_id INT       NOT NULL,
    CONSTRAINT fk_point_reward_record_member_card_id
		FOREIGN KEY (member_card_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Membership_Cards (member_card_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE, # Clear out rewarded points if the membership no longer exists.
	CONSTRAINT fk_point_reward_record_betting_order_id
		FOREIGN KEY (betting_order_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Betting_Orders (betting_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE # Clear out rewarded points if the betting_order no longer exists.
);

CREATE TABLE exercise_three_membership_gaming_credit_sys.Gift_Redeem_Records (
	redeem_record_id INT           AUTO_INCREMENT PRIMARY KEY,
    redeem_date      TIMESTAMP     NOT NULL DEFAULT NOW(),
    member_card_id   INT           NOT NULL,
    redeem_point     INT           UNSIGNED  NOT NULL,
	gift_id          INT           NOT NULL,
    quantity         INT           UNSIGNED  NOT NULL,
    remark	         VARCHAR(500),
    redeem_status	 ENUM("pending", "completed", "cancelled")	DEFAULT "pending"	NOT NULL,
    CONSTRAINT fk_gift_redeem_record_member_card_id
		FOREIGN KEY (member_card_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Membership_Cards (member_card_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, # Avoid automatically delete an completed redemption, even the membership becomes non-valid
	CONSTRAINT fk_point_redeem_record_gift_id
		FOREIGN KEY (gift_id)
        REFERENCES exercise_three_membership_gaming_credit_sys.Gifts (gift_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT # Again, removing a gift from the record is very rare. A better way is to mark it as terminated.
        # Unless in a abnormal situation, we don't want to lose the redeemed records. If so, enforcing manual operation.
);
