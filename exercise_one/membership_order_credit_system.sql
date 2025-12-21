USE exercise_one_membership_sys;

CREATE TABLE exercise_one_membership_sys.Countries (
	country_code VARCHAR(4)   PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE exercise_one_membership_sys.Allergies (
	allergy_code VARCHAR(4)    PRIMARY KEY,
    allergy_desc VARCHAR(1000) NOT NULL
);

CREATE TABLE exercise_one_membership_sys.Membership_status (
	status_id   INT          AUTO_INCREMENT PRIMARY KEY,
    status_desc VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE exercise_one_membership_sys.Payment_Methods (
	payment_method_id INT          AUTO_INCREMENT PRIMARY KEY,
    payment_method    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE exercise_one_membership_sys.Transaction_Types (
	transaction_type_id INT          AUTO_INCREMENT PRIMARY KEY,
    transaction_type    VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE exercise_one_membership_sys.Food_Products (
	food_product_id	INT	          AUTO_INCREMENT PRIMARY KEY,
	product_name    VARCHAR(100)  NOT NULL UNIQUE,
	price           DECIMAL(6, 2) NOT NULL,
	food_desc       VARCHAR(500),
    allergy_code    VARCHAR(4),
    CONSTRAINT fk_food_allergy_code
		FOREIGN KEY (allergy_code)
        REFERENCES exercise_one_membership_sys.Allergies (allergy_code)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE exercise_one_membership_sys.Retail_Products (
	retail_product_id INT	        AUTO_INCREMENT PRIMARY KEY,
	product_name      VARCHAR(100)  NOT NULL UNIQUE,
	price             DECIMAL(6, 2) NOT NULL,
	product_desc      VARCHAR(500)
);

CREATE TABLE exercise_one_membership_sys.Member_Information (
	customer_id	     INT          AUTO_INCREMENT	PRIMARY KEY,
	customer_name	 VARCHAR(100) NOT NULL,
    contact_number   VARCHAR(50)  NOT NULL,
	resident_address VARCHAR(500),		
	nationality_code VARCHAR(4),	
    CONSTRAINT fk_nationality_country_code
		FOREIGN KEY (nationality_code)
        REFERENCES exercise_one_membership_sys.Countries (country_code)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE exercise_one_membership_sys.Membership_cards (
	card_id	      INT       AUTO_INCREMENT PRIMARY KEY,
	customer_id	  INT       NOT NULL,
    issue_date	  TIMESTAMP NOT NULL DEFAULT NOW(),
	point_balance INT       UNSIGNED NOT NULL,
    status_id	  INT       NOT NULL,
    CONSTRAINT fk_card_status_membership_status
		FOREIGN KEY (status_id)
        REFERENCES exercise_one_membership_sys.Membership_status (status_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_card_member_information
		FOREIGN KEY (customer_id)
        REFERENCES exercise_one_membership_sys.Member_Information (customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE exercise_one_membership_sys.Food_Orders (
	food_order_id       INT           AUTO_INCREMENT PRIMARY KEY,
    transaction_date    TIMESTAMP     NOT NULL DEFAULT NOW(),
    payment_method_id   INT           NOT NULL,
    card_id             INT           NOT NULL,
    total_amount        DECIMAL(8, 2) NOT NULL,
    rewarded_point      INT           DEFAULT 0,
	transaction_type_id INT	          NOT NULL,
    CONSTRAINT fk_food_order_payment_method_id
		FOREIGN KEY (payment_method_id)
        REFERENCES exercise_one_membership_sys.Payment_Methods (payment_method_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_food_order_card_id
		FOREIGN KEY (card_id)
        REFERENCES exercise_one_membership_sys.Membership_cards (card_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_food_order_transaction_type_id
		FOREIGN KEY (transaction_type_id)
        REFERENCES exercise_one_membership_sys.Transaction_Types (transaction_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE exercise_one_membership_sys.Retail_Orders (
	retail_order_id     INT           AUTO_INCREMENT PRIMARY KEY,
    transaction_date    TIMESTAMP     NOT NULL DEFAULT NOW(),
    payment_method_id   INT           NOT NULL,
    card_id             INT           NOT NULL,
    total_amount        DECIMAL(8, 2) NOT NULL,
    rewarded_point      INT           DEFAULT 0,
	transaction_type_id INT	          NOT NULL,
    CONSTRAINT fk_retail_order_payment_method_id
		FOREIGN KEY (payment_method_id)
        REFERENCES exercise_one_membership_sys.Payment_Methods (payment_method_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_retail_order_card_id
		FOREIGN KEY (card_id)
        REFERENCES exercise_one_membership_sys.Membership_cards (card_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_retail_order_transaction_type_id
		FOREIGN KEY (transaction_type_id)
        REFERENCES exercise_one_membership_sys.Transaction_Types (transaction_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE exercise_one_membership_sys.Food_Order_Details (
	food_order_id   INT NOT NULL,
    food_product_id INT NOT NULL,
    quantity        INT UNSIGNED NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (food_order_id, food_product_id),

    CONSTRAINT fk_food_order_detail_food_order_id
		FOREIGN KEY (food_order_id)
        REFERENCES exercise_one_membership_sys.Food_Orders (food_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_food_order_detail_food_product_id
		FOREIGN KEY (food_product_id)
        REFERENCES exercise_one_membership_sys.Food_Products (food_product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE exercise_one_membership_sys.Retail_Order_Details (
	retail_order_id   INT NOT NULL,
    retail_product_id INT NOT NULL,
    quantity          INT UNSIGNED NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (retail_order_id, retail_product_id),

    CONSTRAINT fk_retail_order_detail_retail_order_id
		FOREIGN KEY (retail_order_id)
        REFERENCES exercise_one_membership_sys.Retail_Orders (retail_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_retail_order_detail_retail_product_id
		FOREIGN KEY (retail_product_id)
        REFERENCES exercise_one_membership_sys.Retail_Products (retail_product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE exercise_one_membership_sys.Point_Reward_Records (
	reward_record_id INT           AUTO_INCREMENT PRIMARY KEY,
    reward_date      TIMESTAMP     NOT NULL DEFAULT NOW(),
    card_id          INT           NOT NULL,
    reward_points    INT UNSIGNED  NOT NULL,
	food_order_id    INT,
    retail_order_id  INT,
    CONSTRAINT fk_point_reward_record_food_order_id
		FOREIGN KEY (food_order_id)
        REFERENCES exercise_one_membership_sys.Food_Orders (food_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_point_reward_record_retail_order_id
		FOREIGN KEY (retail_order_id)
        REFERENCES exercise_one_membership_sys.Retail_Orders (retail_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_point_reward_record_card_id
		FOREIGN KEY (card_id)
        REFERENCES exercise_one_membership_sys.Membership_cards (card_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
	#CHECK((food_order_id IS NOT NULL) + (retail_order_id IS NOT NULL) = 1)
);

CREATE TABLE exercise_one_membership_sys.Point_Redeem_Records (
	redeem_record_id INT           AUTO_INCREMENT PRIMARY KEY,
    redeem_date      TIMESTAMP     NOT NULL DEFAULT NOW(),
    card_id          INT           NOT NULL,
    redeem_points    INT UNSIGNED  NOT NULL,
	food_order_id    INT,
    retail_order_id  INT,
    CONSTRAINT fk_point_redeem_record_food_order_id
		FOREIGN KEY (food_order_id)
        REFERENCES exercise_one_membership_sys.Food_Orders (food_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_point_redeem_record_retail_order_id
		FOREIGN KEY (retail_order_id)
        REFERENCES exercise_one_membership_sys.Retail_Orders (retail_order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_point_redeem_record_card_id
		FOREIGN KEY (card_id)
        REFERENCES exercise_one_membership_sys.Membership_cards (card_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
	#CHECK((food_order_id IS NOT NULL) + (retail_order_id IS NOT NULL) = 1)
);
