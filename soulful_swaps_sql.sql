/*
CS 4278 - Soulful Swaps project code
*/

-- **************************************************************** --
-- Part 1 - Database Creation
-- **************************************************************** --

-- 1a: this statement creates the actual database
DROP DATABASE IF EXISTS soulful_swaps;
CREATE DATABASE IF NOT EXISTS soulful_swaps;
USE soulful_swaps;

-- Part 1b: Create table statement for the MegaTable

DROP TABLE IF EXISTS Users;
CREATE TABLE IF NOT EXISTS Users (
	user_id INT(10) UNSIGNED ZEROFILL AUTO_INCREMENT NOT NULL,  -- user's 10-digit ID
	username VARCHAR(20),				   			 			-- unique username, alphanumeric and underscore
    pass VARCHAR(20),			    							-- password, alphanumeric and special characters
    email VARCHAR(100),			    							-- email address
    college VARCHAR(50),			    						-- college user attends
    city VARCHAR(50),			    							-- city college is in
    phone_number INT(12),				    					-- phone number with area code
    number_of_items_exchanged INT(200),			    			-- number of clothing items user has exchanged thus far
    reliability_rating DECIMAL(2,1)	CHECK(reliability_rating >= 0 AND reliability_rating <= 5),	  -- reliability rating of the user as determined by other users
    CONSTRAINT pk_forusers
	PRIMARY KEY(user_id)
);

DROP TABLE IF EXISTS Closet;
CREATE TABLE IF NOT EXISTS Closet (
	user_id INT(10) UNSIGNED NOT NULL,  -- user's 10-digit ID
    number_of_items INT(20),			-- number of items in closet
    avg_item_value DECIMAL(2,1)	CHECK(reliability_rating >= 0 AND reliability_rating <= 5), -- average value of the items in the closet
	CONSTRAINT pk_closet
	PRIMARY KEY(user_id),
	CONSTRAINT fk_closet
	FOREIGN KEY (user_id)
		REFERENCES Users (user_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Items;
CREATE TABLE IF NOT EXISTS Items (
	user_id INT(10) UNSIGNED NOT NULL,  -- user's 10-digit ID
    item_id INT(10) UNSIGNED ZEROFILL AUTO_INCREMENT NOT NULL,  -- item's 10-digit ID
    size VARCHAR(10), -- size of clothing item. Can be a word size (i.e Medium) or a number (i.e. size 6)
    brand VARCHAR(100), -- clothing brand
    use_and_wear VARCHAR(30), -- description of how worn the item is (i.e. never worn, slightly worn, etc.)
    point_value DECIMAL(2,1)	CHECK(reliability_rating >= 0 AND reliability_rating <= 5), -- average value of the items in the closet
    rarity TEXT(7) CHECK(rarity IN ('very rare', 'somewhat rare', 'somewhat common', 'very common')), -- rarity of the item's occurrence on the app
	CONSTRAINT pk_items
	PRIMARY KEY(item_id, user_id),
	CONSTRAINT fk_items
	FOREIGN KEY (user_id)
		REFERENCES Users (user_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);
