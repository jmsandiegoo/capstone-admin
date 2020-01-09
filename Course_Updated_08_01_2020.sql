  /*======================================================*/
/*  Module: Capstone                                    */
/*  Database Script for setting up the MySQL database   */
/*  tables required for Open House Capstone Proj        */
/*  Creation Date: 10/25/2019.                         */
/*======================================================*/

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

/*******************************************************************************/
/***                         Delete tables before creating                   ***/
/*******************************************************************************/
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS PwdReset;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS ModuleJob;
DROP TABLE IF EXISTS CourseModule;
DROP TABLE IF EXISTS ElectiveModule;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Module;
DROP TABLE IF EXISTS Elective;
DROP TABLE IF EXISTS CourseJob; /*--DELETED--*/
DROP TABLE IF EXISTS CategoryJob;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Job1;
DROP TABLE IF EXISTS Job;/*--DELETED--*/
DROP TABLE IF EXISTS CourseReq;
DROP TABLE IF EXISTS Requirement;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS FAQ;
DROP TABLE IF EXISTS ModuleJob;
/*******************************************************************************/
/***                              Create the tables                          ***/
/*******************************************************************************/

CREATE TABLE Account (
  id INT(11) NOT NULL AUTO_INCREMENT,
  email TEXT NOT NULL,
  password VARCHAR(500) NOT NULL,
  is_admin TINYINT(1) NOT NULL,
  first_name VARCHAR(50) DEFAULT NULL,
  last_name VARCHAR(50) DEFAULT NULL,
  phone_number VARCHAR(50) DEFAULT NULL,
  CONSTRAINT pk_account PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE PwdReset (
  id int(11) NOT NULL AUTO_INCREMENT,
  reset_email TEXT NOT NULL,
  reset_selector TEXT NOT NULL,
  reset_token TEXT NOT NULL,
  reset_expires TEXT NOT NULL,
  CONSTRAINT pk_pwdreset PRIMARY KEY (id)
) ENGINE=InnoDB CHARSET=latin1;

CREATE TABLE Course 
(
  id INT(4) NOT NULL AUTO_INCREMENT,
  course_id VARCHAR(4) NOT NULL,
  course_name VARCHAR(50) NOT NULL,
  course_abbreviations VARCHAR(10) NOT NULL,
  course_short_description TEXT DEFAULT NULL,
  course_description TEXT DEFAULT NULL,
  course_year1_description TEXT DEFAULT NULL,
  course_year2_description TEXT DEFAULT NULL,
  course_year3_description TEXT DEFAULT NULL,
  course_elective_description TEXT DEFAULT NULL,
  course_requirements VARCHAR(500) DEFAULT NULL,
  course_intake INT(4) NOT NULL,
  CONSTRAINT pk_course PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Requirement
(
  req_id INT(4) NOT NULL,
  req_subject VARCHAR(500) NOT NULL,
  req_grade VARCHAR(10) NOT NULL,
  CONSTRAINT pk_coursereq PRIMARY KEY (req_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE CourseReq
(
  course_id INT(4) NOT NULL,
  req_id INT(4) NOT NULL,
  CONSTRAINT fk_coursereq_course_id FOREIGN KEY (course_id) REFERENCES Course(id),
  CONSTRAINT fk_coursereq_req_id FOREIGN KEY (req_id) REFERENCES Requirement(req_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Job 
(
  job_id INT(4) NOT NULL AUTO_INCREMENT,
  job_name VARCHAR(500) NOT NULL,
  CONSTRAINT pk_job PRIMARY KEY (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Job1 
(
  job1_id INT(4) NOT NULL AUTO_INCREMENT,
  job1_name VARCHAR(500) NOT NULL,
  CONSTRAINT pk_job PRIMARY KEY (job1_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Category
(
  category_id INT(4) NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(500) NOT NULL,
  categoryitem_path VARCHAR(512) NOT NULL,
  categoryitem_type VARCHAR(20) NOT NULL,
  CONSTRAINT pk_category PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE CategoryJob
(
  categoryjob_id INT(4) NOT NULL AUTO_INCREMENT,
  category_id INT(4) NOT NULL,
  job1_id INT(4) NOT NULL,
  id INT(4) NOT NULL,
  CONSTRAINT pk_categoryjob PRIMARY KEY (categoryjob_id),
  CONSTRAINT fk_categoryjob_category_category_id FOREIGN KEY (category_id) REFERENCES Category(category_id),
  CONSTRAINT fk_categoryjob_job1_job1_id FOREIGN KEY (job1_id) REFERENCES Job1(job1_id), 
  CONSTRAINT fk_categoryjob_course_id FOREIGN KEY (id) REFERENCES Course(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*DELETED*/
CREATE TABLE CourseJob
(
  id INT(4) NOT NULL,
  job_id INT(4) NOT NULL,
  CONSTRAINT pk_coursejob PRIMARY KEY (id, job_id),
  CONSTRAINT fk_coursejob_course_id FOREIGN KEY (id) REFERENCES Course(id),
  CONSTRAINT fk_coursejob_job_job_id FOREIGN KEY (job_id) REFERENCES Job(job_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Elective
(
  elective_id INT(4) NOT NULL AUTO_INCREMENT,
  elective_name VARCHAR(50) NOT NULL,
  CONSTRAINT pk_elective PRIMARY KEY (elective_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Module 
(
  module_id INT(4) NOT NULL AUTO_INCREMENT,
  module_name VARCHAR(50) NOT NULL,
  module_description TEXT DEFAULT NULL,
  CONSTRAINT pk_module PRIMARY KEY (module_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Project
(
  project_id INT(4) NOT NULL AUTO_INCREMENT,
  project_name VARCHAR(50) NOT NULL,
  project_desc TEXT DEFAULT NULL,
  module_id INT(4) NOT NULL,
  CONSTRAINT pk_project PRIMARY KEY (project_id),
  CONSTRAINT fk_project_module_id FOREIGN KEY (module_id) REFERENCES Module(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ElectiveModule
(
  module_id INT(4) NOT NULL,
  elective_id INT(4) NOT NULL,
  CONSTRAINT fk_electivemodule_module_module_id FOREIGN KEY (module_id) REFERENCES Module(module_id),
  CONSTRAINT fk_electivemodule_elective_elective_id FOREIGN KEY (elective_id) REFERENCES Elective(elective_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE CourseModule
(
  id INT(4) NOT NULL,
  module_id INT(4) NOT NULL,
  module_year VARCHAR(10) NOT NULL,
  CONSTRAINT fk_coursemodule_course_id FOREIGN KEY (id) REFERENCES Course(id),
  CONSTRAINT fk_coursemodule_module_module_id FOREIGN KEY (module_id) REFERENCES Module(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ModuleJob
(
  job_id INT(4) NOT NULL, 
  module_id INT(4) NOT NULL,
  CONSTRAINT fk_modulejob_job_job_id FOREIGN KEY (job_id) REFERENCES Job(job_id),
  CONSTRAINT fk_modulejob_module_module_id FOREIGN KEY (module_id) REFERENCES Module(module_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Item 
(
  item_id INT(4) NOT NULL AUTO_INCREMENT,
  item_path VARCHAR(512) NOT NULL,
  item_type VARCHAR(20) NOT NULL,
  module_id INT(4) DEFAULT NULL,
  course_id INT(4) DEFAULT NULL,
  project_id INT(4) DEFAULT NULL,
  CONSTRAINT pk_item PRIMARY KEY (item_id),
  CONSTRAINT fk_item_module_id FOREIGN KEY (module_id) REFERENCES Module(module_id),
  CONSTRAINT fk_item_course_id FOREIGN KEY (course_id) REFERENCES Course(id),
  CONSTRAINT fk_item_project_id FOREIGN KEY (project_id) REFERENCES Project(project_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*******************************************************************************/
/***                              TG Bot                          ***/
/*******************************************************************************/

CREATE TABLE Appointment
(
  appointment_id INT(4) NOT NULL AUTO_INCREMENT,
  user_id bigint NULL DEFAULT NULL COMMENT 'Unique user identifier',
  chat_id bigint NULL DEFAULT NULL COMMENT 'Unique user or chat identifier',
  is_general TINYINT(1) NOT NULL,
  appointment_name VARCHAR(100) NOT NULL,
  appointment_status ENUM('Pending', 'Now Serving', 'Finished', 'Cancelled') DEFAULT 'Pending' NOT NULL,
  appointment_createdate DATETIME NOT NULL,
  appointment_lastcalled DATETIME DEFAULT NULL,
  appointment_calls INT(4) DEFAULT 0 NOT NULL,
  course_id INT(4) DEFAULT NULL,
  phoneNumber varchar(20) DEFAULT NULL COMMENT 'User phone number',
  CONSTRAINT pk_appointment PRIMARY KEY (appointment_id),
  CONSTRAINT fk_appointment_course_id FOREIGN KEY (course_id) REFERENCES Course(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint COMMENT 'Unique identifier for this user or bot',
  `is_bot` tinyint(1) DEFAULT 0 COMMENT 'True, if this user is a bot',
  `first_name` CHAR(255) NOT NULL DEFAULT '' COMMENT 'User''s or bot''s first name',
  `last_name` CHAR(255) DEFAULT NULL COMMENT 'User''s or bot''s last name',
  `username` CHAR(191) DEFAULT NULL COMMENT 'User''s or bot''s username',
  `language_code` CHAR(10) DEFAULT NULL COMMENT 'IETF language tag of the user''s language',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',

  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `chat` (
  `id` bigint COMMENT 'Unique identifier for this chat',
  `type` ENUM('private', 'group', 'supergroup', 'channel') NOT NULL COMMENT 'Type of chat, can be either private, group, supergroup or channel',
  `title` CHAR(255) DEFAULT '' COMMENT 'Title, for supergroups, channels and group chats',
  `username` CHAR(255) DEFAULT NULL COMMENT 'Username, for private chats, supergroups and channels if available',
  `first_name` CHAR(255) DEFAULT NULL COMMENT 'First name of the other party in a private chat',
  `last_name` CHAR(255) DEFAULT NULL COMMENT 'Last name of the other party in a private chat',
  `all_members_are_administrators` tinyint(1) DEFAULT 0 COMMENT 'True if a all members of this group are admins',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',
  `old_id` bigint DEFAULT NULL COMMENT 'Unique chat identifier, this is filled when a group is converted to a supergroup',

  PRIMARY KEY (`id`),
  KEY `old_id` (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `user_chat` (
  `user_id` bigint COMMENT 'Unique user identifier',
  `chat_id` bigint COMMENT 'Unique user or chat identifier',

  PRIMARY KEY (`user_id`, `chat_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `inline_query` (
  `id` bigint UNSIGNED COMMENT 'Unique identifier for this query',
  `user_id` bigint NULL COMMENT 'Unique user identifier',
  `location` CHAR(255) NULL DEFAULT NULL COMMENT 'Location of the user',
  `query` TEXT NOT NULL COMMENT 'Text of the query',
  `offset` CHAR(255) NULL DEFAULT NULL COMMENT 'Offset of the result',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `chosen_inline_result` (
  `id` bigint UNSIGNED AUTO_INCREMENT COMMENT 'Unique identifier for this entry',
  `result_id` CHAR(255) NOT NULL DEFAULT '' COMMENT 'The unique identifier for the result that was chosen',
  `user_id` bigint NULL COMMENT 'The user that chose the result',
  `location` CHAR(255) NULL DEFAULT NULL COMMENT 'Sender location, only for bots that require user location',
  `inline_message_id` CHAR(255) NULL DEFAULT NULL COMMENT 'Identifier of the sent inline message',
  `query` TEXT NOT NULL COMMENT 'The query that was used to obtain the result',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `message` (
  `chat_id` bigint COMMENT 'Unique chat identifier',
  `id` bigint UNSIGNED COMMENT 'Unique message identifier',
  `user_id` bigint NULL COMMENT 'Unique user identifier',
  `date` timestamp NULL DEFAULT NULL COMMENT 'Date the message was sent in timestamp format',
  `forward_from` bigint NULL DEFAULT NULL COMMENT 'Unique user identifier, sender of the original message',
  `forward_from_chat` bigint NULL DEFAULT NULL COMMENT 'Unique chat identifier, chat the original message belongs to',
  `forward_from_message_id` bigint NULL DEFAULT NULL COMMENT 'Unique chat identifier of the original message in the channel',
  `forward_signature` TEXT NULL DEFAULT NULL COMMENT 'For messages forwarded from channels, signature of the post author if present',
  `forward_sender_name` TEXT NULL DEFAULT NULL COMMENT 'Sender''s name for messages forwarded from users who disallow adding a link to their account in forwarded messages',
  `forward_date` timestamp NULL DEFAULT NULL COMMENT 'date the original message was sent in timestamp format',
  `reply_to_chat` bigint NULL DEFAULT NULL COMMENT 'Unique chat identifier',
  `reply_to_message` bigint UNSIGNED DEFAULT NULL COMMENT 'Message that this message is reply to',
  `edit_date` bigint UNSIGNED DEFAULT NULL COMMENT 'Date the message was last edited in Unix time',
  `media_group_id` TEXT COMMENT 'The unique identifier of a media message group this message belongs to',
  `author_signature` TEXT COMMENT 'Signature of the post author for messages in channels',
  `text` TEXT COMMENT 'For text messages, the actual UTF-8 text of the message max message length 4096 char utf8mb4',
  `entities` TEXT COMMENT 'For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text',
  `caption_entities` TEXT COMMENT 'For messages with a caption, special entities like usernames, URLs, bot commands, etc. that appear in the caption',
  `audio` TEXT COMMENT 'Audio object. Message is an audio file, information about the file',
  `document` TEXT COMMENT 'Document object. Message is a general file, information about the file',
  `animation` TEXT COMMENT 'Message is an animation, information about the animation',
  `game` TEXT COMMENT 'Game object. Message is a game, information about the game',
  `photo` TEXT COMMENT 'Array of PhotoSize objects. Message is a photo, available sizes of the photo',
  `sticker` TEXT COMMENT 'Sticker object. Message is a sticker, information about the sticker',
  `video` TEXT COMMENT 'Video object. Message is a video, information about the video',
  `voice` TEXT COMMENT 'Voice Object. Message is a Voice, information about the Voice',
  `video_note` TEXT COMMENT 'VoiceNote Object. Message is a Video Note, information about the Video Note',
  `caption` TEXT COMMENT  'For message with caption, the actual UTF-8 text of the caption',
  `contact` TEXT COMMENT 'Contact object. Message is a shared contact, information about the contact',
  `location` TEXT COMMENT 'Location object. Message is a shared location, information about the location',
  `venue` TEXT COMMENT 'Venue object. Message is a Venue, information about the Venue',
  `poll` TEXT COMMENT 'Poll object. Message is a native poll, information about the poll',
  `new_chat_members` TEXT COMMENT 'List of unique user identifiers, new member(s) were added to the group, information about them (one of these members may be the bot itself)',
  `left_chat_member` bigint NULL DEFAULT NULL COMMENT 'Unique user identifier, a member was removed from the group, information about them (this member may be the bot itself)',
  `new_chat_title` CHAR(255) DEFAULT NULL COMMENT 'A chat title was changed to this value',
  `new_chat_photo` TEXT COMMENT 'Array of PhotoSize objects. A chat photo was change to this value',
  `delete_chat_photo` tinyint(1) DEFAULT 0 COMMENT 'Informs that the chat photo was deleted',
  `group_chat_created` tinyint(1) DEFAULT 0 COMMENT 'Informs that the group has been created',
  `supergroup_chat_created` tinyint(1) DEFAULT 0 COMMENT 'Informs that the supergroup has been created',
  `channel_chat_created` tinyint(1) DEFAULT 0 COMMENT 'Informs that the channel chat has been created',
  `migrate_to_chat_id` bigint NULL DEFAULT NULL COMMENT 'Migrate to chat identifier. The group has been migrated to a supergroup with the specified identifier',
  `migrate_from_chat_id` bigint NULL DEFAULT NULL COMMENT 'Migrate from chat identifier. The supergroup has been migrated from a group with the specified identifier',
  `pinned_message` TEXT NULL COMMENT 'Message object. Specified message was pinned',
  `invoice` TEXT NULL COMMENT 'Message is an invoice for a payment, information about the invoice',
  `successful_payment` TEXT NULL COMMENT 'Message is a service message about a successful payment, information about the payment',
  `connected_website` TEXT NULL COMMENT 'The domain name of the website on which the user has logged in.',
  `passport_data` TEXT NULL COMMENT 'Telegram Passport data',
  `reply_markup` TEXT NULL COMMENT 'Inline keyboard attached to the message',

  PRIMARY KEY (`chat_id`, `id`),
  KEY `user_id` (`user_id`),
  KEY `forward_from` (`forward_from`),
  KEY `forward_from_chat` (`forward_from_chat`),
  KEY `reply_to_chat` (`reply_to_chat`),
  KEY `reply_to_message` (`reply_to_message`),
  KEY `left_chat_member` (`left_chat_member`),
  KEY `migrate_from_chat_id` (`migrate_from_chat_id`),
  KEY `migrate_to_chat_id` (`migrate_to_chat_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  FOREIGN KEY (`forward_from_chat`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`reply_to_chat`, `reply_to_message`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`forward_from`) REFERENCES `user` (`id`),
  FOREIGN KEY (`left_chat_member`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `edited_message` (
  `id` bigint UNSIGNED AUTO_INCREMENT COMMENT 'Unique identifier for this entry',
  `chat_id` bigint COMMENT 'Unique chat identifier',
  `message_id` bigint UNSIGNED COMMENT 'Unique message identifier',
  `user_id` bigint NULL COMMENT 'Unique user identifier',
  `edit_date` timestamp NULL DEFAULT NULL COMMENT 'Date the message was edited in timestamp format',
  `text` TEXT COMMENT 'For text messages, the actual UTF-8 text of the message max message length 4096 char utf8',
  `entities` TEXT COMMENT 'For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text',
  `caption` TEXT COMMENT  'For message with caption, the actual UTF-8 text of the caption',

  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `message_id` (`message_id`),
  KEY `user_id` (`user_id`),

  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`),
  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `callback_query` (
  `id` bigint UNSIGNED COMMENT 'Unique identifier for this query',
  `user_id` bigint NULL COMMENT 'Unique user identifier',
  `chat_id` bigint NULL COMMENT 'Unique chat identifier',
  `message_id` bigint UNSIGNED COMMENT 'Unique message identifier',
  `inline_message_id` CHAR(255) NULL DEFAULT NULL COMMENT 'Identifier of the message sent via the bot in inline mode, that originated the query',
  `chat_instance` CHAR(255) NOT NULL DEFAULT '' COMMENT 'Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent',
  `data` CHAR(255) NOT NULL DEFAULT '' COMMENT 'Data associated with the callback button',
  `game_short_name` CHAR(255) NOT NULL DEFAULT '' COMMENT 'Short name of a Game to be returned, serves as the unique identifier for the game',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`),
  KEY `message_id` (`message_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `shipping_query` (
  `id` bigint UNSIGNED COMMENT 'Unique query identifier',
  `user_id` bigint COMMENT 'User who sent the query',
  `invoice_payload` CHAR(255) NOT NULL DEFAULT '' COMMENT 'Bot specified invoice payload',
  `shipping_address` CHAR(255) NOT NULL DEFAULT '' COMMENT 'User specified shipping address',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `pre_checkout_query` (
  `id` bigint UNSIGNED COMMENT 'Unique query identifier',
  `user_id` bigint COMMENT 'User who sent the query',
  `currency` CHAR(3) COMMENT 'Three-letter ISO 4217 currency code',
  `total_amount` bigint COMMENT 'Total price in the smallest units of the currency',
  `invoice_payload` CHAR(255) NOT NULL DEFAULT '' COMMENT 'Bot specified invoice payload',
  `shipping_option_id` CHAR(255) NULL COMMENT 'Identifier of the shipping option chosen by the user',
  `order_info` TEXT NULL COMMENT 'Order info provided by the user',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `poll` (
  `id` bigint UNSIGNED COMMENT 'Unique poll identifier',
  `question` char(255) NOT NULL COMMENT 'Poll question',
  `options` text NOT NULL COMMENT 'List of poll options',
  `is_closed` tinyint(1) DEFAULT 0 COMMENT 'True, if the poll is closed',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `telegram_update` (
  `id` bigint UNSIGNED COMMENT 'Update''s unique identifier',
  `chat_id` bigint NULL DEFAULT NULL COMMENT 'Unique chat identifier',
  `message_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming message of any kind - text, photo, sticker, etc.',
  `edited_message_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New version of a message that is known to the bot and was edited',
  `channel_post_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming channel post of any kind - text, photo, sticker, etc.',
  `edited_channel_post_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New version of a channel post that is known to the bot and was edited',
  `inline_query_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming inline query',
  `chosen_inline_result_id` bigint UNSIGNED DEFAULT NULL COMMENT 'The result of an inline query that was chosen by a user and sent to their chat partner',
  `callback_query_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming callback query',
  `shipping_query_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming shipping query. Only for invoices with flexible price',
  `pre_checkout_query_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New incoming pre-checkout query. Contains full information about checkout',
  `poll_id` bigint UNSIGNED DEFAULT NULL COMMENT 'New poll state. Bots receive only updates about polls, which are sent or stopped by the bot',

  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`),
  KEY `chat_message_id` (`chat_id`, `message_id`),
  KEY `edited_message_id` (`edited_message_id`),
  KEY `channel_post_id` (`channel_post_id`),
  KEY `edited_channel_post_id` (`edited_channel_post_id`),
  KEY `inline_query_id` (`inline_query_id`),
  KEY `chosen_inline_result_id` (`chosen_inline_result_id`),
  KEY `callback_query_id` (`callback_query_id`),
  KEY `shipping_query_id` (`shipping_query_id`),
  KEY `pre_checkout_query_id` (`pre_checkout_query_id`),
  KEY `poll_id` (`poll_id`),

  FOREIGN KEY (`chat_id`, `message_id`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`edited_message_id`) REFERENCES `edited_message` (`id`),
  FOREIGN KEY (`chat_id`, `channel_post_id`) REFERENCES `message` (`chat_id`, `id`),
  FOREIGN KEY (`edited_channel_post_id`) REFERENCES `edited_message` (`id`),
  FOREIGN KEY (`inline_query_id`) REFERENCES `inline_query` (`id`),
  FOREIGN KEY (`chosen_inline_result_id`) REFERENCES `chosen_inline_result` (`id`),
  FOREIGN KEY (`callback_query_id`) REFERENCES `callback_query` (`id`),
  FOREIGN KEY (`shipping_query_id`) REFERENCES `shipping_query` (`id`),
  FOREIGN KEY (`pre_checkout_query_id`) REFERENCES `pre_checkout_query` (`id`),
  FOREIGN KEY (`poll_id`) REFERENCES `poll` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `conversation` (
  `id` bigint(20) unsigned AUTO_INCREMENT COMMENT 'Unique identifier for this entry',
  `user_id` bigint NULL DEFAULT NULL COMMENT 'Unique user identifier',
  `chat_id` bigint NULL DEFAULT NULL COMMENT 'Unique user or chat identifier',
  `status` ENUM('active', 'cancelled', 'stopped') NOT NULL DEFAULT 'active' COMMENT 'Conversation state',
  `command` varchar(160) DEFAULT '' COMMENT 'Default command to execute',
  `notes` text DEFAULT NULL COMMENT 'Data stored from command',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date update',

  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`),
  KEY `status` (`status`),

  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  FOREIGN KEY (`chat_id`) REFERENCES `chat` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE IF NOT EXISTS `request_limiter` (
  `id` bigint UNSIGNED AUTO_INCREMENT COMMENT 'Unique identifier for this entry',
  `chat_id` char(255) NULL DEFAULT NULL COMMENT 'Unique chat identifier',
  `inline_message_id` char(255) NULL DEFAULT NULL COMMENT 'Identifier of the sent inline message',
  `method` char(255) DEFAULT NULL COMMENT 'Request method',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Entry date creation',

  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

CREATE TABLE FAQ 
(
  faq_id INT(4) NOT NULL,
  CONSTRAINT pk_faq PRIMARY KEY (faq_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*******************************************************************************/
/***                              Add data to table                          ***/
/*******************************************************************************/

/*------ Account -------*/
INSERT INTO Account(id, email, password, is_admin, first_name, last_name, phone_number) VALUES
(1, 's10180780@connect.np.edu.sg', '$2y$10$hber0w8mVVSfzC8F8vCSjeRwqXwQEwt2cnnkgljeRjBl9/Mu4ZXya', 1, 'John Michael', 'San Diego', '69696969'),
(2, 'rongk4ii@gmail.com', 'alibaba123', 1, 'John Cena', 'California', '61262916');

/*------ Course -------*/
INSERT INTO Course(id, course_id, course_name, course_abbreviations,course_short_description, course_description, course_year1_description, course_year2_description, course_year3_description ,course_elective_description, course_requirements, course_intake) VALUES
(1, 'N54', 'Information Technology','IT','Be an All-Rounded Tech Pro', 'Develop innovative IT solutions that increases business competitiveness, enhance the quality of life, or even start your very own online business. We follow a "Learn by Doing" Experiential Learning pedagogy. We let students have a Self-directed approach to acquire real-world skills that meet industry needs, have Exciting internships with industry leaders like Microsoft and IBM, give students Opportunities to develop IT business ideas and apps at ICT technology hubs and also let students have the Freedom to build your portfolio from seven areas of interest.', 'Build a solid foundation in IT, programming, computing mathematics and cyber security during the first semester. Develop your understanding in core computing skills such as databases as well as operating systems and networking fundamentals.' , 'Choose from a variety of electives that suit your interest and passions. Research IT-related topics to develop your digital portfolio.', 'Go on a six-month local or overseas internship, develop your own IT business and ideas, and work on a capstone project.','Select a wide range of modules that suits your interests, offered to you as elective during your study here!' ,'5 - 10', 75),
(2, 'N81', 'Financial Informatics','FI', 'Bank on Fintech', 'Get a strong foundation in IT training, reinforced with exciting modules from these three areas: Financial analytics, banking & finance and enterprise computing. Financial analytics is an increasingly important tool to financial institutions as it helps them stay competitive, identify new business opportunities and detect frauds. In banking & finance, financial technology is also a growth area. We encourage the "Learn by Doing" Experiential Learning pedagogy, and also put a strong focus on IT competency to meet industry needs. There will be exciting internships with industry leaders like DBS, OCBC, SAP, Salesforce and MAS, or with FinTech start-ups, accelerators and incubators during the final year of your course.', 'Build a solid foundation in IT, programming, computing mathematics and cyber security during the first semester. You''ll also get to conduct independent research on IT or fintech-related topics right from your first year.' , 'Develop applications for the banking and finance industry, and understand business strategies used in organisations while implementing business processes. Learn how to analyse financial data, and design business processes and applications.' , 'Get an overview of business processes and transaction workflows in banking and financial institutions. Sharpen your analytical skills through industry-based projects and internship. Plus, you''ll get to choose to either work on a capstone project to solve real-world challenges or take up two elective modules offered by the school.' ,'Select a wide range of modules that suits your interests, offered to you as elective during your study here!' ,'4 - 10', 50),
(3, 'N55', 'Immersive Media','IM', 'Create Awesome User Experiences', 'Augmented, Virtual and Mixed Realities[AR/VR/MR] are just some technologies that enable the creation of engaging content to transport users to other worlds beyond the confines of their flat screens. Learn how to create experiences with this exciting form of media and contribute to the way we communicate, work and play in the future, through the Diploma in Immersive Media. We put a strong focus on designing immersive user experiences.You can get trained in sought-after areas such as User Experience and User Interface (UX/UI) design that open doors to exciting career pathways. Industry-standard graduation portfolio to beef up your resume. Broaden your skills with a wide variety of electives offered by the School.', 'Receive strong fundamental training in design and programming through modules such as Applied Design, Interactive Development and Programming 1.' , 'Learn about spatial concepts and how to design interactive media content and applications on different platforms.', 'Put your skills to the test by going for a six-month internship and working on your capstone project.' ,'Select a wide range of modules that suits your interests, offered to you as elective during your study here!' ,'7 - 13', 0),
(4, 'N94', 'Cybersecurity & Digital Forensics','CDF', 'Fight Cybercrime', 'Mitigate cyber threats Singapore faces in our quest to be a smart nation. IT security professionals are in high demand to help Singapore succeed in this quest. With rapid growth in the area of Financial Technology, information security will be even more critical to protect our financial institutions. 
You will get the most comprehensive training & curriculum in secure software development and go for exciting internships with IT Security leaders. You will also perform penetration tests and work on projects in our cutting-edge CSF labs, and get to attend masterclasses by information security professionals and attain highly sought-after CompTIA Security+ professional certifications.', 'Build a solid foundation in IT, programming, computing mathematics and cyber security during the first semester. You''ll also get to learn about cryptography, databases and front-end development.', 'Develop skills in the areas of network security, software security and digital forensics. Learn to set up computer networks, develop secure software applications and conduct malware analysis.' , 'Perform penetration tests on software, systems and networks, and get in-depth knowledge on network security. You''ll also get to work on industry-driven project, a technopreneurship project or an IT-related project with a local or overseas organisation.','Select a wide range of modules that suits your interests, offered to you as elective during your study here!' , '4 - 8', 50),
(5, 'N95', 'Common ICT Programme','CICT', 'Explore Infocomm Frontiers', 'Interested in the world of IT but unsure about which course to choose? With the Common ICT Programme (CICTP), you will have more time to explore different disciplines before making a more informed choice. You will gain an introduction to the field of IT by understanding the roles, practices and career paths of IT professionals. You will also learn the fundamentals of programming and cyber security, as well as an overview of enterprise information systems that use data analytics for decision making. You will get to choose your preferred discipline at the end of your first semester: Cybersecurity & Digital Forensics, Financial Informatics or Information Technology.', 'Get an introduction to the field of IT by understanding the roles, practices and career paths of IT professionals. Learn the fundamentals of programming and cyber security, as well as an overview of enterprise information systems that use data analytics for decision making. Choose your preferred discipline at the end of your first semester.' , 'Pursue modules from one of the four diplomas - Information Technology, Financial Informatics, Cybersecurity & Digital Forensics or Immersive Media.', 'Deepen your skills and knowledge in one of the four diplomas you''ve chosen - Information Technology, Financial Informatics, Cybersecurity & Digital Forensics and Immersive Media.','Select a wide range of modules that suits your interests, offered to you as elective during your study here!' , '5 - 13', 100)
;

/*------ Requirement -------*/
INSERT INTO Requirement VALUES
(1, 'English Language as First Language', '1 - 7'),
(2, 'Mathematics', '1 - 6'),
(3, 'Any two other subjects', '1 - 6')
;

/*------ CourseReq -------*/
INSERT INTO CourseReq VALUES
(1, 1),(1, 2),(1, 3),
(2, 1),(2, 2),(2, 3),
(3, 1),(3, 2),(3, 3),
(4, 1),(4, 2),(4, 3),
(5, 1),(5, 2),(5, 3);

/*------ Job (Deleted) -------*/
INSERT INTO Job(job_id, job_name) VALUES
(1,'IT Solutions Providers'),(2,'IT consulting Companies'),(3,'IT Security Product Companies'),(4,'Security Software Development'),(5,'IT Security Divisions'),(6,'Security Analyst/Engineer'),
(7,'Digital Forensics Investigator'),(8,'Security Software Developer'),(9,'Penetration Tester'),(10,'Malware Analyst'),

(11,'Game Designer'),(12,'Level Designer'),(13,'Game Interface Designer'),(14,'Visual Designer'),(15,'Web Designer'),(16,'Multimedia Designer'),(17,'Producer'),(18,'User Experience Designer'),(19,'Interactive Experience Designer / Developer'),

(20,'Applications Developer'),(21,'UI/UX designer'),(22,'Database Administrator'),(23,'Pre-/post-Sales Consultant'),(24,'Sales Executive'),(25,'Channel Sales Executive'),(26,'Customer Experience Manager'),(27,'Data Analyst'),(28,'Data Engineer'),
(29,'Infrastructure Executive'),(30,'Cloud Engineer'),(31,'Software Engineer'),(32,'Systems Consultant'),(33,'Analyst Programmer'),(34,'Web & Software Developer'),(35,'Network Administrator'),

(36,'System Analyst'),(37,'Applications Developer'),(38,'IT Consulting analyst'),(39,'Associate Business Analyst'),(40,'Banking Operations'),(41,'Business Consultant'),(42,'Business Intelligence Analyst'),(43,'Application Consultant'),
(44,'Solutions Architect'),(45,'Project Manager')

;


/*------ Job -------*/
INSERT INTO Job1(job1_id, job1_name) VALUES
/*--IT--*/
(1,'Application Developer'),(2,'Software Architect'),(3,'Front End Developer'),

(4,'Customer Support Administrator'),(5,'Desktop Support Manager'),(6,'Help Desk Specialist'),

(7,'Cloud Engineer'),(8,'Cloud Services Developer'),(9,'Cloud Software & Network Engineer'),(10,'Cloud System Administrator'),

(11,'Cyber Security Specialist'),(12,'IT Security Consultant'),(13,'IT Security Officer'),

/*--IM--*/
(14, 'Interaction Designer'), (15, 'UX Designer'), (16,'Usability Analyst'), (17,'Visual Designer'), (18,'Information Architect'), (19,'User Research'),

(20,'Game Designer'),(21,'Game Interface Designer'), (22,'Game Animator'),(23,'Game Audio Engineer'),

(24,'3D Artist'),(25,'Interactive 3D/VR Artists'),(26,'Cartoonist'),

(27,'Producer'),(28,'Level Designer'),(29,'Junior Programmer'),

/*--FI--*/
(30,'Accountant Technician'), (31, 'Brand Consultant'), (32,'Bank Manager'),

(33,'Data Architect '), (34, 'Business Intelligence'), (35, 'Application Architect'),

(36,'Customer Due Diligence Manager'), (37,'Customer Service Order Manager'),

(38,'Project Manager'), (39,'Business Consultant'), (40,'IT Business Analyst'),

/*--CSF--*/

(41,'Security Architect'), (42,'Security Engineer'), (43,'Security Manager'), (44,'Security Consultant'),

(45,'Security Software Developer'), (46,'Security Software Engineer'),

(47, 'Security Penetration Tester'), (48, 'Cybersecurity Penetration Test Specialist'), (49, 'Web Application Security Tester'), 

(50,'Cyber Risk Analyst'), (51,'Incident Response Programme Management Specialist'), (52,'Risk Control Specialist'), (53, 'Risk Consultant'), 

(54,'Incident/Forensic/Threat Investigator'), (55, 'Cyber Forensic Analyst'), (56, 'Private Investigators'), (57, 'Corporate IT Security Personal'), (58,'Law Enforcer');

/*------ Category -------*/
INSERT INTO Category(category_id, category_name, categoryitem_path, categoryitem_type) VALUES
/*--IT--*/
(1, 'Coding', 'assets/img/category/coding.png', 'Image'), 
(2, 'Computer Support', 'assets/img/category/support.png', 'Image'), 
(3, 'Cloud Computing Engineers', 'assets/img/category/cloud.png', 'Image'), 
(4, 'Information Security Specialist', 'assets/img/category/security.png', 'Image'), 

/*--IM--*/
(5, 'UX', 'assets/img/category/interactivemedia.png', 'Image'), 
(6, 'Game Designer', 'assets/img/category/gamedesigner.png', 'Image'), 
(7, '3D/Sketch', 'assets/img/category/3d.png', 'Image'), 
(8, 'Digital', 'assets/img/category/digital.png', 'Image'),

/*--FI--*/
(9, 'Banking & Finance', 'assets/img/category/banking.png', 'Image'), 
(10, 'Data Science', 'assets/img/category/data.png', 'Image'),
(11, 'Customer Service', 'assets/img/category/customer.png', 'Image'), 
(12, 'Enterprise Computing','assets/img/category/enterprise.png', 'Image'),

/*--CSF--*/
(13, 'Security Analyst [Network/Server]', 'assets/img/category/Infrastructure.png', 'Image'), 
(14, 'Software Security', 'assets/img/category/softwaresecurity.png', 'Image'), 
(15, 'Penetration  Tester', 'assets/img/category/qa.png', 'Image'), 
(16, 'Security Risk Management', 'assets/img/category/risk.png', 'Image'), 
(17, 'Forensics', 'assets/img/category/forensic.png', 'Image');

/*--CategoryJob--*/
INSERT INTO CategoryJob(categoryjob_id, category_id, job1_id, id) VALUES
/*--Coding--*/
(1, 1, 1, 1), (2, 1, 2, 1), (3, 1, 3, 1),

/*--Customer Support--*/
(4, 2, 4, 1), (5, 2, 5, 1), (6, 2, 6, 1), 

/*--Cloud Computing Engineers--*/
(7, 3, 7, 1), (8, 3, 8, 1), (9, 3, 9, 1), (10, 3, 10, 1), 

/*--Information Security Specialist--*/
(11, 4, 11, 1), (12, 4, 12, 1), (13, 4, 13, 1), 

/*--UX--*/
(14, 5, 14, 3), (15, 5, 15, 3), (16, 5, 16, 3), (17, 5, 17, 3), (18, 5, 18, 3), (19, 5, 19, 3),

/*--Game Designer--*/
(20, 6, 20, 3), (21, 6, 21, 3), (22, 6, 22, 3), (23, 6, 23, 3),

/*--3D/Sketch--*/
(24, 7, 24, 3), (25, 7, 25, 3), (26, 7, 26, 3),

/*--'Digital'--*/
(27, 8, 27, 3), (28, 8, 28, 3), (29, 8, 29, 3), 

/*--Banking & Finance--*/
(30, 9, 30, 2), (31, 9, 31, 2), (32, 9, 32, 2), 

/*--Data Science--*/
(33, 10, 33, 2), (34, 10, 34, 2), (35, 10, 35, 2),

/*--Customer Service--*/
(36, 11, 36, 2), (37, 11, 37, 2), 

/*--Enterprise--*/
(38, 12, 38, 2), (39, 12, 39, 2), (40, 12, 40, 2), 

/*--Security Analyst [Network/Server] --*/
(41, 13, 41, 4), (42, 13, 42, 4), (43, 13, 43, 4),

/*--Software Security--*/
(44, 14, 44, 4), (45, 14, 45, 4), (46, 14, 46, 4), 

/*--Penetration Tester--*/
(47, 15, 47, 4), (48, 15, 48, 4), (49, 15, 49, 4),

/*--Security Risk Management--*/
(50, 16, 50, 4), (51, 16, 51, 4), (52, 16, 52, 4), (53, 16, 53, 4), 

/*--Forensics--*/
(54, 17, 54, 4), (55, 17, 55, 4), (56, 17, 56, 4), (57, 17, 57, 4), (58, 17, 58, 4);

/*------ CourseJob -------*/
INSERT INTO CourseJob(id, job_id) VALUES
/*------ Common ICT Programme -------*/
(5,2),(5,4),(5,6),(5,9),(5,10),(5,14),(5,19),(5,20),(5,24),
(5,27),(5,36),(5,39),(5,44),
/*------ Cybersecurity & Digital Forensics -------*/
(4, 1),(4,2),(4,3),(4,4),(4,5),(4,6),(4,7),(4,8),(4,9),(4,10),
/*------ Immersive Media -------*/
(3,11),(3,12),(3,13),(3,14),(3,15),(3,16),(3,17),(3,18),(3,19),
/*------ Information Technology -------*/
(1,20),(1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),
(1,29),(1,30),(1,31),(1,32),(1,33),(1,34),(1,35),
/*------ Financial Informatics -------*/
(2,36),(2,37),(2,38),(2,39),(2,40),(2,41),(2,42),(2,43),(2,44),
(2,45)
;
/*------ Electives -------*/
INSERT INTO Elective(elective_id, elective_name) VALUES
(1, 'Banking and Finance'),
(2, 'Financial Analytics'),
(3, 'Enterprise Computing'),
(4, 'Business & Data Analytics'),
(5, 'Cloud Computing'),
(6, 'Enterprise Solutioning'),
(7, 'Game Programming'),
(8, 'Infocomm Sales & Marketing'),
(9, 'Mobile Business Applications'),
(10, 'Solution Architect'),
(13, 'Common Electives'),
(14, 'General IT Electives')
;
/*------ Module -------*/
INSERT INTO Module(module_id, module_name, module_description) VALUES
(1,'3D Character Creation','This module introduces students to character creation for real-time media workflow. Students will practice character digital sculpting, low-poly retopology, texturing, auto-rigging, and mo-cap animation re-mapping for interactive character integration for immersive media.'),
(2,'3D Environments','This module introduces students to advanced real-time environment design workflow. Students will practice modular organic 3D asset production workflow integrating basic real-time tech art, effects, lighting, and post processing with focus on exterior spatial layout design for immersive media.'),
(3,'3D for Real-time','This module introduces students to basic real-time environment design workflow. Students will practice modular hard-surface modelling integrating real-time engine graphics optimization techniques with focus on interior spatial layout design & lighting for immersive media.'),
(4,'3D Fundamentals ','This module introduces students to basic digital 3D production workflow to create assets for interactive projects. Students will practice basic modeling, UV unwrapping, digital sculpting, high-poly detail onto low-poly mapping, texturing, rigging, animation, real-time lighting and rendering. Students will learn to produce hard-surface virtual objects for real-time engine.'),
(5,'3D Prototyping','This module introduces the aspects of rapid prototyping by allowing students to partake in designing 3D models and implementing them into a physical 3D product. Students are exposed to various prototyping methods and covers product design and using 3D printing as an enabling technology.'),
(6,'Accounting','This module introduces the basic theory and concepts of accounting through the introduction of Business Structures and Financial Institutions. Basic accounting concepts and principles form the foundation of the module and students will be taught the complete accounting cycle; setting up the chart of accounts, balancing the trial balance and preparing financial statements. It also introduces risk and controls and accounting standards and regulations governing the financial services industry. Students will also learn about the differences between financial and management accounting as well as funding methods and financial ratios for business and banks'),
(7,'Applied Analytics','This module provides students with an introduction to unsupervised machine learning methods such as Clustering. Students are taught how these methods are used to segment customers for targeted cross-sell, up-sell and pricing. The module also introduces students to supervised machine learning methods such as Decision Trees and how these methods are used to predict customer churn, credit risk etc. Open-source tools like R and/or Python will be used for data analysis and modelling. Students will also be exposed to enterprise analytics tools for interactive data visualization and data wrangling. Data from various domains (Retail, Banking & Finance, Telcos etc) will be used to provide students with an introduction to domain-specific analytics.'),
(8,'Applied Design','This module introduces students to design application through digital props and environment concept illustration. Students will practice perspective drawing, constructive drawing, color rendering, and compositional design. Students will learn to produce visual plans essential in real-time immersive production workflow.'),
(9,'Artificial Intelligence for Games','This module introduces the various approaches for injecting intelligence into games. Topics covered include AI architecture (e.g. rule-based systems, finite state machines), movement, pathfinding and planning (both strategic and tactical). AI-related game design issues such as realistic non-player character behaviour and game difficulty will also be taught.'),
(10,'Banking and Financial Products','For banks and financial institutions to gain an edge over their competitors, many are providing consumers and corporates with a wide range of products and services. Many are harnessing information technology in their day- today operations to provide multiple channels and greater efficiency and effectiveness in banking and financial services to enhance overall customer experience. This module provides a macro overview of the financial services industry, including financial intermediaries and allows students to understand the operational structure and the roles and responsibilities of different departments in banks at a high level. Subsequently, a myriad of banking and financial products that are widely available in commercial and investment banks and insurance companies would be discussed. Students will learn about the fundamentals of retail, wholesale and investment products as well as risk associated with them and the mitigating controls that banks put in place to manage the risks. The role of Information Technology is intertwined into the module, allowing students to appreciate the use of IT to increase operational efficiency and effectiveness in financial institutions'),
(11,'Banking Applications and Processes','This module aims to provide students with an overview of the business processes and transaction workflows in banking and financial institutions. The module begins with a look at the various organizational structures within different types of banking and financial institutions, and the roles and responsibilities of key front office and back office functions across various business lines. Students will subsequently explore the end-to-end workflow processes for banking and financial transactions, and their supporting IT applications and systems.'),
(12,'Banking Technologies and Operations',''),
(13,'Big Data','This introductory module covers the fundamentals of elements of Big Data: volume, velocity and variety. Students will learn various technologies & tools used to create a big data ecosystem which is able to handle storing, indexing & search. This module also covers the whole technology stack of Big Data: infrastructure, data management and analytics. Tools such as Hadoop, HDFS, and MapReduce will be taught in this module'),
(14,'Business Process Modelling & Development','This module equips students with the skills for eliciting, documenting, modelling and analysing business processes within an organisation. Processes in sales, purchasing, inventory management and finance will be discussed and investigated. Students will learn to use a Business Process Management tool to model and develop solutions that improve process efficiency and quality.'),
(15,'Capstone Project','In this module, students are required to complete a substantial project that is the culmination of their education in the School of InfoComm Technology. The project can be a real-world problem proposed by a client, or it can be proposed by the student in pursuit of their personal interests.'),
(16,'Cloud Architecture & Technologies','This module gives insight into the key concepts and technologies of cloud computing which include cloud characteristics, service models (SaaS, PaaS, and IaaS), deployment models (Public cloud, Private cloud, Community cloud, and Hybrid cloud), and the features of cloud computing technologies. It also covers the cloud computing architecture, emerging trends and issues such as clouds for mobile applications, cloud portability and interoperability, scalability, manageability, and service delivery in terms of design and implementation issues. The module discusses the benefits and challenges of cloud computing, standards of cloud computing service delivery, and Service Level Agreement (SLAs) for cloud services. Hands-on activities are included to expose students to various cloud computing services offered by major cloud computing providers such as Amazon Web Services (AWS), Google App Engine (GAE), and Microsoft Windows Azure.'),
(17,'Communication Essentials',''),
(18,'Computing Mathematics','This module introduces the basic concepts of relations and functions, matrices and methods of statistics and their applications relevant to IT professionals. The main emphasis in this module is to develop students'' ability in solving quantitative problems in computing mathematics, probability and statistics. Topics covered include fundamentals of statistics and probability, discrete and continuous probability distributions.'),
(19,'Cryptography','This module covers the essential concepts of Cryptography, including Public Key Infrastructure (PKI), Digital Signature and Certificate, and the various encryption/decryption algorithms. Students will understand how Symmetric and Asymmetric (Public- Key) cryptographic techniques are used to support different security implementations, and the encryption/ decryption algorithms used in these techniques. The role of the Certificate Authority, how the digital certificates are generated, managed and distributed will also be covered in detail.'),
(20,'Customer Decision Making & Negotiation Skills','Students will be introduced to soft skills in understanding customer biases and concerns, building rapport, handling objections, identifying informal and formal decision makers, selling functions/features/ benefits, negotiating and closing sales techniques. They will also learn about reference selling and proofs of concept as well as pick up presentation and communication skills. The module offers opportunities to role play and develop value proposition in sales calls within the context of ICT.'),
(21,'Customer Experience Management','With SMAC (Social, Mobility, Analytics and Cloud) technologies resulting in a new competitive environment, the control has shifted from the seller to buyer. This module provides students with the knowledge and understanding of Customer Experience Management (CXM) as a business strategy in this new environment. The buyer’s experience is not limited to a single transaction but includes the sum of all experiences across all touch points and channels between a buyer and a seller over the duration of their relationship. This strategy aims to achieve a sustainable competitive advantage to help sellers manage the buyer’s experience that is both collaborative and personalized. Students will have an opportunity to have hands-on experience with customer management systems used by sellers that collect and create customer data, segment that data into manageable data sets, make sense of the data and make it available for timely delivery. This allows companies to deliver consistent customer experiences that delight customers or achieve other organisational goals'),
(22,'Cyber Security Fundamentals','This module provides an overview of the various domains of cyber security. It helps develop an understanding of the importance of cyber security in today’s digital world. It aims to provide an appreciation of cyber security from an endto-end perspective. It covers fundamental security concepts, tools and techniques in domains such as data, end-user, software, system, network, physical, organisation, and digital forensics. It also helps develop knowledge and skills in identifying common cyber threats and vulnerabilities, and to apply techniques to tackle these issues. In this module, students are assessed by coursework only.'),
(23,'Data Structures & Algorithms','This module aims to provide students with the knowledge and skills to analyse, design, implement, test and document programmes involving data structures. It teaches basic data structures and algorithms within the conceptual framework of abstract data types. The emphasis here is to use the class feature of an Object-Oriented language platform to give the concrete implementation of various abstract data types.'),
(24,'Data Visualisation','This module covers the techniques and tools for creating effective visualisations based on principles from graphic design, perceptual psychology and cognitive science. Students will learn how to process large volumes of data to create interactive visualisations for ease of exploration. Topics that are covered include visualising patterns, proportions, relationships, spatial and temporal elements, and multi-dimensional visualisations.'),
(25,'Databases','Today’s business organisations depend on information systems in virtually all aspects of their businesses. Corporate databases are set up to hold the voluminous business transactions generated by these information systems. This module introduces students to the underlying concepts of database systems and how to model and design database systems that reflect business requirements. Students will be taught how to analyse data needs, model the relationships amongst the data entities, apply normalisation process to relations and create the physical database. Skills to be taught include data modelling technique, transformation of data model to relations, normalisation technique and SQL (Structured Query Language).'),
(26,'Descriptive Analytics','Descriptive Analytics refers to a discipline used by many companies to analyse their data for improved decision making. Descriptive Analytics describes what happened in the past. It can include various forms of reports, queries and dashboards. This module aims to teach students the descriptive analytics lifecycle. Students will learn to ask the appropriate analytics questions, identify and aggregate data sources and create data models. They will apply techniques to analyse the data captured in these models. They will also create appropriate visualisation components to gain insights from the data. These visualisation components will be synthesized into dashboards that add value and can be readily consumed by business users.'),
(27,'Design Principles','This module introduces students to basic elements and principles of design. Students will practice visual communication and self-branding through aesthetic use of line, shape, form, color, texture, typography, scale, contrast, rhythm and balance. Students will be trained in the usage of digital design tools and application of modern industrial practices to communicate the concepts, designs and solutions.'),
(28,'Designing & Managing Cloud Databases','This module covers analysis, design, and implementation of cloud database models, data management life cycle, and data governance to manage master data. Students will be introduced to query languages for cloud database development and best practices for implementing the extract, transform and load (ETL) process cycle. The module provides insight into cloud storage components, and data transformation and integration methodologies for data migration into cloud databases. It will further explore laws and regulations governing data access, usage, storage and transmission. The module will also introduce the concepts and technologies of Distributed and Parallel Databases which include their design, structures, theories, algorithms and implementation. Examples of distributed and parallel platforms and frameworks for processing Big Data, such as MapReduce and Hadoop, will be also be discussed.'),
(29,'Designing User Experience','This module aims to equip students with skills and techniques to fulfil the various stages of the UX design process, leading to optimum user-centric digital products. Exposure to various problem statements will aid students in developing critical, analytical perspectives for framing their approaches in problem-solving. Other major topics includes: Research methods, Inclusive Design, Interaction Design, Rapid Prototyping, Measuring User Experience and Usability Testing. Students are also guided on how to compile a proper UX portfolio.'),
(30,'Developing Cloud Applications','This module covers the analysis of business and technical requirements of a cloud-based system, implementation of a cloud strategy with appropriate programming tools, deployment, and testing and debugging the cloud application. Analysis of business requirements to determine how they can be mapped into a cloud environment is discussed in this module. The module extends its discussion to cloud computing design patterns, best practices, cloud migration issues and considerations. Students are exposed to a cloud computing platform such as Windows Azure to get extensive hands-on practice to build, migrate, host and scale web applications and services through the vendor’s data centres.'),
(31,'Developing Dynamic Applications','This module aims to broaden the students’ skillsets by introducing server-side development to create a digital product. This module covers various client-server architectural concepts that involves rich client, application server and database. Students will hone their programming skills by learning server-side programming, object-oriented programming, database design and development. In addition, students will experience the development production process and workflow.'),
(32,'Digital Audio Design','This module introduces the production techniques of audio and sound effect, ambient sounds, background music and dialogue to enhance the user experience and/or to advance a story and create mood, place, and emphasis. It covers its associated technologies, the equipment used, the procedures and explores the manipulations of various envelopes on amplitude, filter and modulation and the use of low frequency oscillator and noise in designing sound. It also covers subtractive synthesising and studies the processing and reactions of sounds in an interactive environment.'),
(33,'Digital Forensics','This module gives an insight into the process of forensics investigation. It covers the various types of computer related crimes, techniques of gathering electronic evidence, and the recovering of deleted, damaged or encrypted data. Students will also make use of advanced forensic tools to perform forensic investigation. Besides the tools and techniques of investigation, students will be taught sound forensic investigation methodology and the proper handling of evidence. The module will also cover aspects of law and policies applicable to digital forensics.'),
(34,'Digital Video & Audio','This module introduces basic digital shorts production. Students will first learn audio-video production theory followed by practical production in labs and on location in the field. Production know-how, processes, cameras, microphone systems, audio-video editing software, and lights will be provided. Inclass practical audio, camera and editing exercises followed by continuous assessments, two assignments and a test are all designed to reinforce student learning.'),
(35,'eCommerce Applications Development','This module aims to provide students with the technical skills as well as an appreciation of the business perspective on electronic commerce (eCommerce). The main focus will be on building a Business-to Consumer (B2C) eCommerce website. Students will be taught the building blocks and enabling technologies for building eCommerce applications, the processes of eCommerce transactions and some business issues on eCommerce. The module will also provide hands-on experiences for students to build a simple B2C eCommerce website on their own'),
(36,'Economics',''),
(37,'Emerging Trends in IT','The revolution in computing and communications has spurred the rapid advancement of IT in modern societies, and there is little to suggest that its proliferation will slow down in the near future. In light of this trend, this module is designed to help students keep abreast of the latest IT developments to stay current and relevant in the fast moving industry. To achieve this objective, the syllabus for this module will be guided by technology research and feedback from industry partners, and both seminar-style and hands- on workshop teaching approaches may be adopted depending on the nature of the topic covered.'),
(38,'English Language Express',''),
(39,'Enterprise Business Processes','Business processes are a set of activities that are designed to produce a specific output for an organisation. Processes can be cross-functional or even spanning across organisations. For today’s businesses, especially for large and complex organisations with complex products and services, they very much rely on the efficiency and effectiveness of their business operations to compete with competitors, often with the help of IT systems. However, these business processes need to be agile and flexible in order to adapt to changes in business needs. Organisations which are unable to do this will be at a disadvantage. The study of enterprise business processes will illustrate to students the key business processes in typical organisations. Students will learn about the business strategies used in organisations while implementing business processes, the typical deliverables for a business process that each organisation adopts, the importance of integration of information across different departments or organisations and the relationship between the banks and organisations for all payments with customer and vendors. In addition, students are expected to draw detailed activity diagrams for the major business processes. At the end of the module, students will be able to appreciate the complexity of business processes, how IT can help organisations to be more competitive and gain basic management skills required to manage business processes in an organisation.'),
(40,'Enterprise Business Solutions','This module educates students on the importance of backend cloud-based enterprise business systems and the role it plays in helping organisations increase productivity, enable collaboration and improve overall effectiveness. Students will learn to use cloud-based enterprise business systems to drive workflows and gather insights from analytics dashboards. Students will also be exposed to the next generation of enterprise business solutions that hinges on the interoperability of various backend enterprise systems with frontend Internet of Things (IoT) devices. With such holistic exposure, students will be better prepared to support the Smart Nation initiatives and gain hands on experience on information technologies/concepts such as IoT, programming, cloud computing, analytics and enterprise computing.'),
(41,'Enterprise Information Systems','Companies today are adopting the use of technology not just to assist them in their day-to-day operations but also gaining an advantage over their competitors. Many of them are implementing enterprise-wide information systems that provide them with platforms to integrate and coordinate their business processes. The use of enterprise information systems has become a necessity in multi-national companies (MNCs) as well as small and medium enterprises (SMEs). Within an enterprise information system, there is an intricate relationship between business strategy, organizational structure, business processes and technology resulting in challenges and issues during implementation. This module introduces students to the different components that build up an enterprise information system. Different types of information systems are used for business processes, from communication and order processing to data analysis for decision making, and in almost all business functions ranging from marketing, sales, procurement, and human resource, to product development and manufacturing, accounting and finance'),
(42,'Enterprise Resource Planning ',''),
(43,'Enterprise Systems Design and Development','This module trains students to view information systems from the perspective of business needs and participate in the design of IT solutions to solve the identified business problems. Students will be exposed to work processes such as Design Thinking that facilitates problem identification to prototyping. This module also allows students to work in teams to experience a real-life application development cycle. Elements of project management, automated testing and source version controls will be introduced in relevant phases of the application development cycle. Students will be exposed to current development methodology such as Agile.'),
(44,'Ethical Hacking','This module aims to develop Penetration Testers for the information security industry. They will be taught to follow a process model to locate and establish targets, find vulnerabilities, and exploit the flaws to determine potential impact and business risk with the goal of helping the owner improve security practices. Students will learn the techniques hackers use to hack a system, and the steps to secure it. Students will have hands- on practice on actual pen-testing that involves reconnaissance to map out IT infrastructure, scanning vulnerable systems, and developing attack vectors to exploit loopholes in a system. Students will also be taught the necessary countermeasures to mitigate risks of exploitation through system hardening, intrusion detection and prevention.'),
(45,'Experiential Design','This module exposes and introduce students to designing media content and applications for various platforms. It covers the concept of designing extended reality (XR) products with heavy emphasis on the User Experience (UX) for the respective platforms. Students will be tested on their observational, research and problem-solving skills to seek out current/future technological advancements, and to come up with proposals and prototypes for actual implementation.'),
(46,'Financial Analysis & Modelling',''),
(47,'Financial Ecosystem','This module provides a macro overview of the network of organisations involved in the delivery of financial services through both competition and cooperation. Students will be introduced to the various participants in the financial ecosystem, which includes financial intermediaries, regulators, market operators, industry associations and customers. Subsequently, students would also learn about the market microstructures, interactions and interdependencies underlying the relationships intertwining these participants. Additionally, students would learn about the on-going digital evolution in the financial sector and its future implications for all participants.'),
(48,'Financial Spreadsheet Engineering','The spreadsheet is an indispensable tool for professionals, especially in the banking and finance industry, to solve business problems and make better informed decisions. This module will introduce students to the use of spreadsheets as a reporting and modelling tool in the areas of business and finance. Through hands-on Excel practical sessions in class, students will explore various spreadsheet functions and simple macros used for analysing, formatting and presenting data. Students will also be equipped with an understanding of best practices in spreadsheet usage and design.'),
(49,'Front-End Development','This module teaches the fundamental skills required to develop responsive websites that are optimised for mobile and desktop viewing. The students would attain skills and knowledge in programming languages such as HTML, CSS, JavaScript, jQuery, and AJAX which are used to develop interactive websites. This allows students to develop a website with interactive elements, providing them with a tangible product that they can develop into an interactive resume application and e-Portfolio website.'),
(50,'Full-Stack Development','This module uses the knowledge and skills acquired in the Programming (PRG1 & PRG2), Web Application Development (WEB) and Databases (DB) modules. It aims to provide opportunities for students to be part of a software development team working on both back-end and front-end technologies. The approach is based on Agile methodology. The module may cover source version control, backups, code documentation, refactoring and code reviews. Other key topics include test driven development and automated processes.'),
(51,'Fundamentals for IT Professionals I','This module provides a broad introduction to the field of IT by exploring the roles, professional practice, ethical expectations and career development paths of IT professionals. Through a guided inculcation of interpersonal and team work skills with strong team bonding spirit, the module aims to deepen students’ commitment to the sector that the course prepares them for. In addition, students will be required to begin charting their career path in the IT industry by considering crucial aspects such as personal preferences and aptitude, job roles and responsibilities, skills needed and further education.'),
(52,'Fundamentals for IT Professionals II','This module gives a course-based experience in which students can engage with the local community and industry. This includes participation in community service events or in Service-Learning projects that leverage students’ discipline knowledge and skills to meet identified needs. Through iterative and guided reflection on the service experience, students gain a broader appreciation of their discipline and an enhanced sense of personal voice, empathy and civic responsibility. Industry talks and seminars are organised to keep students up-to-date on emerging trends so as to build up their interpersonal, team and networking skills with the community and industry.'),
(53,'Fundamentals for IT Professionals III','This module provides a stepping stone to the students in their IT career. Students are given an insight into the infocomm industries and are kept updated with the latest skill sets required in their IT career path. They also have the opportunity to be exposed to various institutes of higher learning to further acquire their skill sets.'),
(54,'Game Interactivity','This module introduces game interactivity and the various game interaction devices to the students. Topics include current and experimental game devices, console usability, player profiling and psychology, measuring playability and testing techniques. Students will be required to research and develop a game prototype demonstrating their understanding of game interactivity'),
(55,'Game Production','This module provides an overview of the game development process and introduces game design. Key concepts of game design such as storytelling, game mechanics and level design will be covered. Students will have the opportunity to design and prototype a game using an industry standard game creation system.'),
(56,'Gameplay Programming','This module presents fundamental concepts of game implementation and architecture, such as the game loop, gamesystem component separation, the game state manager, input/output handling and frame rate control. Basic concepts in computer graphics, such as collision detection and back buffering, will also be introduced. Consequently, students will have the opportunity to develop a game prototype without the use of a game engine.'),
(57,'Gamification Concepts','This module studies the game mechanics – the rules intended to produce an enjoyable gameplay and introduces the principles and methodologies behind the rules and play of games. Once students have mastered the basics of game-design elements and game principles, they will learn to apply them in nongame contexts to improve user engagement, organizational productivity and learning.'),
(58,'Governance & Data Protection','This module examines the relevant frameworks to ensure that information assets are protected within an organisation. It includes the processes and policies for administering and managing a company’s IT systems that follow the compliance framework. Concepts on risk management process, risk analysis and mitigation will also be introduced. Students will learn to evaluate risks against the company’s critical assets and deploy safeguards to mitigate them. Control frameworks such as PCI (Payment Card Industry), ISO 17799/27002, and COBIT will be covered.'),
(59,'Immersive Technology Development','This module provides an overview of emerging technologies with emphasis in interactive and immersive technologies, and the impact they have on the users. It is designed to help students keep abreast of the latest immersive experiences or technology developments to stay current and relevant in the fast-moving industry. To achieve this objective, the syllabus for this module will be guided by technology research and feedback from industry partners, and both seminar-style and hands-on workshop teaching approaches may be adopted depending on the nature of the topic covered.'),
(60,'Infocomm Sales & Marketing Strategies','This module will introduce students to the concept of market segmentation and the development of sales and marketing strategies for each segment. They will acquire an understanding of industry and customer segmentation from corporate, small and medium businesses to consumers. They will also delve into the different go-to-market strategies and selling techniques required in the context of ICT (such as consultative selling, major account selling and management, territory selling and management, partner management and consumer marketing).'),
(61,'Infocomm Sales Life Cycle Management','This module introduces students to a customer’s ICT purchase decision making process and sales life cycle management. Students will also pick up some fundamental concepts in interpreting customer annual reports, financial ratios, industry analysis and competitive strategies so that they can recognise customer needs and wants. They will follow the sales life cycle from prospecting, qualifying, developing solutions, negotiating and closing the sales to post-sale support and services, up-selling and cross-selling.'),
(62,'Innovation Made Possible',''),
(63,'Interactive 3D Experience','This module continues to develop students’ ability to design and author highly interactive experience applications. The programming focuses on interactivity authoring through the eyes of designers for animation, visual effects, multimedia and games. It covers advanced authoring, digital storytelling techniques, user experience design, and project management techniques. Additionally, students will utilise a real-time engine and create prototypes for.'),
(64,'Interactive Development','This module widens students’ programming knowledge by covering programming concepts through the creation of interactive media applications. Students refine their knowledge of programming by decomposing their programs into classes and objects. Students learn to understand, design and build modern interfaces, moving on to create interactive elements. The focus of this module is to incorporate interaction design and methodology to build interactive applications around it.'),
(65,'Internship or Project','This module provides students with the opportunity to apply the knowledge and skills gained to develop an IT solution to solve a practical problem. Students may undertake an in-house industry-driven project or a real- life IT project in a local or overseas organisation. These projects may include problem definition, requirements analysis, design, development and testing, delivery and presentation of the solution. Through the project, students will learn to appreciate the finer points of project planning and control issues relating to IT project development.'),
(66,'IT Outsourcing',''),
(67,'Malware Analysis Tools and Techniques','This module teaches a repeatable malware analysis methodology, which includes static analysis, code analysis, and behavioural analysis. Students are taught how to write a malware analysis report on a target malware. Students will be able to determine the malware’s indicators of compromise needed to perform incident response triage. This module trains students to efficiently use network and system monitoring tools to examine how malware interacts with the file system, registry, network, and other processes in an OS environment. Students are also trained to decrypt and analyse malicious script components of web pages, identify and examine the behaviour of malicious documents, and apply memory forensics techniques to analyse complex malware and rootkit infections. This module carries a pre-requisite: Reverse Engineering Malware (REM).'),
(68,'Mathematics for Games','This module provides an in-depth examination of the various mathematical concepts that are relevant to games programming. Topics covered may include vector geometry (e.g., vector arithmetic, dot product, cross product), linear transformations (e.g., rotations, reflections), matrices, trigonometry (e.g., trajectory) and physics (e.g., acceleration/deceleration, gravity).'),
(69,'Mobile Applications Development','This module focuses on the design and development of applications for mobile devices like hand phones, personal digital assistants (PDAs) and handheld computers. Due to the nature of these handheld devices, issues such as memory storage, user interface and data input methods require more careful consideration and planning. At the end of this module, students will be able to develop applications that can run on mobile devices and interact wirelessly with serverside programmes.'),
(70,'Mobile Applications Development II','This module builds upon the skills and knowledge that students have acquired from the Mobile Applications Development module. It will focus on the development of advanced applications and emerging mobile operating systems. For example, students could develop applications for industries such as entertainment, games and healthcare. They will learn to develop applications for emerging operating systems such as the iPhone OS and Android.'),
(71,'Mobile Device Security & Forensics','This module covers techniques and tools in the context of a forensic methodology to extract and utilise digital evidence on mobile devices. Students will learn how to use current forensic tools to preserve, acquire and examine data stored in a mobile device. The module covers basic SIM Card examination and cell phone forensics on multiple platforms such as iPhone, Android and Windows Mobile. The module takes a practice- oriented approach to performing forensics investigation on mobile phones.'),
(72,'Motion Graphics & Effects','This module inducts students into the world of digital effects. Aimed at value-adding to the storytelling experience, students are first introduced to the impact of visual effects on storytelling in films, followed by the principles and elements of motion design. Exercises, assessments and assignments are aimed at developing research, conceptualization and storytelling skills for the creation of compelling and exciting time-based media.'),
(73,'Network Forensics','Network equipment, such as web proxies, firewalls, IDS, routers, and even switches, contain evidence that can make or break a case. This module provides students with the knowledge and skills to recover evidence from network-based devices. It will begin with an introduction of different network devices and the type of data that are useful from a forensic point of view. It then moves on to the most common and fundamental network protocols that the forensic investigators will likely face during an investigation. These include the Dynamic Host Configuration Protocol (DHCP), Network Time Protocol (NTP) and Microsoft Remote Procedure Call (RPC) protocol. The students will learn a variety of techniques and tools to perform sniffing and log analysis on the network. Commercial and Open Source tools will be used to perform deep packet analysis while SIEM tools such as Splunk will be used to perform log analysis on network devices.'),
(74,'Network Security','This module provides an in-depth knowledge on network security in a defensive view. It covers various types of firewall technologies, Virtual Private Networks (VPNs), and Intrusion Detection/Prevention Systems (IDS/IPS). Students will have a chance to configure and deploy state-of-the-art networking devices in a typical computer network. Students will be taught skills to identify the internal and external threats against a network and to propose appropriate security policies that will protect an organisation’s information. Students will also learn how to implement successful security policies and firewall strategies in this module.'),
(75,'Networking Infrastructure','This module covers basic Local Area Network (LAN) and Wide Area Network (WAN) infrastructures including physical cabling systems used for an enterprise network, and how hardware platforms such as switches, routers and servers are deployed in typical networks. The module also introduces students to major networking protocols such as Ethernet, RIP, PPP, OSPF and HDLC, network operating systems and applications that run on LANs/WANs. Students will learn to configure switches and routers, and will be taught the techniques to configure and troubleshoot LANs and WANs.'),
(76,'Object-Oriented Analysis & Design','This module leverages the skills acquired in Object- Oriented Programming to introduce software design and requirements analysis, so that students experience the full cycle of software development. An overview of various Software Development Life Cycles as well as an in-depth look at software development methodologies will be provided. In particular, students will learn about requirements gathering techniques and the primary artefacts of system design. They will be able to specify, design and document simple software systems using appropriate modelling tools.'),
(77,'Operating Systems & Networking Fundamentals','This module focuses on the fundamentals and principles of operating systems. It explains what general operating systems are and what they do. The module teaches concepts that are applicable to a variety of operating systems such as Windows and Linux. Students will learn about the different number and character representation methods such as binary, hexadecimal and ASCII. Concepts including processes, physical and virtual memory, files and directories, file systems, shell and OS commands will be covered. The module also covers the terminology and technologies in current networking environments and provides a general overview of the field of networking as a basis for subsequent related modules in the course. Topics relating to types of networks, network topologies, network technologies and layered protocol architectures will be taught. In addition, the students will also learn the OSI model to understand data networks and understand commonly used network systems such as Ethernet. As TCP/IP is deployed in most of today’s network architecture, the topic will be discussed in detail. An overview of internetworking will also be presented to allow students to have a global picture of how local area and wide area networks are interconnected in the real world.'),
(78,'Portfolio I','This module provides students with the opportunity to apply the knowledge and skills gained from the various modules in the course to date, and explore topics in IT that they have a personal interest. Students may choose to undertake a real- life IT project, a competition- based project or a research and development project. The chosen project should result in the subsequent deliverable of artefacts that are suitable for their personal portfolios. Through the project, students have opportunities to work in teams, work on real-world problems, and build up their personal portfolios.'),
(79,'Portfolio II','This module builds on the previous module Portfolio I (P1). Like for Portfolio I, students may choose to undertake a real- life IT project, a competition-based project or a research and development project. The chosen project should ideally include problem definition, requirements gathering, analysis and design, development and testing and the subsequent deliverable of artefacts that are suitable for their personal portfolios. The project may be a continuation of their previous project in Portfolio 1.'),
(80,'Predictive Analytics','This module introduces students to the statistical techniques used to make predictions about future trends in business or financial services. Students are taught the assessment techniques that are used to identify risks and opportunities patterns found in historical and transactional data, and to make intelligent decisions by evaluating the prediction models developed using software tools. Topics covered include data mining methods, such as association, classification and cluster analysis, forecasting methods and prediction models.'),
(81,'Procedural Modeling & Simulation','This module introduces the concepts of procedural modelling. Students will learn to create models and environments from a set of rules using industry standards software and use the procedural generated content in immersive projects and simulations.'),
(82,'Production Management','This module introduces the interactive digital media & game industry, the production pipeline, and various professional roles and career paths, and exposes students to various document required in the production of interactive experience & games. It examines the roles of different participants in the development process and how the technical development and the artistic development proceed in tandem.'),
(83,'Programming I','This module introduces the fundamentals of programming and how to develop programs using appropriate problemsolving techniques in a modular style. In this practice-oriented module, students are taught how to apply problemsolving skills using a top- down structured programming methodology and given ample practice in translating solutions into computer programs, then test and debug the programs. Topics include data types, variables, expressions, statements, selection structures, loops, simple computation and algorithms, and the use of libraries. Students will also practise the use of pseudocodes, best practices of programming, debugging techniques with the help of tools, development of test cases, and suitable program documentation. In addition, they will study various areas where application software plays a prominent part in helping organisations solve problems. Students will be given ample opportunity for independent and self- directed learning. Students will learn about the organisations and mapping the business processes to draw the activity diagram flows. It is essential for students to understand how information systems are used to help organisations and they are expected to suggest solutions and new uses of information systems to solve business problems. This will enhance their IT and business processes knowledge to prepare them for future modules, future employment or even future entrepreneurship.'),
(84,'Programming II','This module builds upon the knowledge and skills acquired in Programming 1 (PRG1). It aims to provide opportunities for the students to develop medium- scale applications based on the Object-Oriented (OO) approach. A suitable objectoriented high-level programming language will be used for students to continuously apply their problem-solving skills. The main concepts of OO and the implementation of applications using the OO approach will be taught in this module. The module may also cover the concepts of Abstract Data Types (ADTs) and the implementation of some selected ADTs using the OO approach. Suitable sorting and search algorithms and the use of Application Protocol Interface (API) will be introduced when required. Other key topics include the introduction of system design concepts such as the class diagram. Software robustness and correctness, and good programming practices will be emphasised throughout the module. Independent and self-directed learning will also be encouraged.'),
(85,'Project ID: Connecting the Dots',''),
(86,'Quantitative Analysis','This module aims to introduce students to the statistical concepts and methods that are used to analyse and interpret business or financial data. Students will be equipped with the technical know-how to formulate statistical models, and make informed decisions by evaluating the statistical models using software tools. Topics covered include frequency distribution, probability distribution, quantitative modelling, correlation analysis and linear regression analysis'),
(87,'Reverse Engineering Malware','This module trains students in reverse engineering malicious software using system and network monitoring tools, a disassembler, and a debugger. The module focuses on teaching students the essential assembly language concepts, along with the use of an assembly language emulator, a disassembler, and a debugger. These assembly language concepts and tools are needed to examine malicious code and understand its execution flow, identify common assembly-level patterns in malicious code, identify suspicious API calls, and to bypass defensive mechanisms of the malware.'),
(88,'Risk Management',''),
(89,'Secure Software Development','This module provides students with the knowledge of the secure software development lifecycle. It trains students to incorporate security throughout the entire process of software development. With the knowledge gained from this module, students would be able to design, code, test and deploy software with a security mindset. The module begins with training students on how to identify, gather and record security requirements for a software. Students will learn secure software design, where various security frameworks, considerations and methodologies are taught. Students will understand how software vulnerabilities can be exploited and how to address the risks. Students are trained to write secure code that is resilient against critical web application attacks. Finally, students are trained in secure software testing and how to securely deploy software.'),
(90,'Serious Games & Simulations','This module focuses on designing games that aim to change human’s behaviours, knowledge, and attitudes as well as the way people work, and businesses compete in diverse areas including education, training, marketing and advertising. It examines the process of creating an engaging learning situation and making learning fun and entertaining through game-based thinking and game mechanics, from the perspectives of pedagogies and persuasive aspects.'),
(91,'Server & Cloud Security','This module aims to teach students the concepts and knowledge related to securing web servers and cloud models. It covers topics such as how a web server is installed and optimized securely, the various methods of attacking web servers and the appropriate countermeasures. The specific tools used to test for vulnerabilities in web servers, their applications and databases will also be covered. Cloud security topics will cover introduction to the various delivery models of cloud computing ranging from Software as a Service (SaaS) to Infrastructure as a Service (IaaS). Each of these delivery models presents an entirely separate set of security conditions to consider. An overview of security issues within each of these models will be covered with in-depth discussions of risks to consider.'),
(92,'Service Management',''),
(93,'Social Media & Branding','This module introduces students to creative sections in advertorial, communications and media. Students broaden their knowledge in designing for various aspects of visual communications. Students apply creative thinking skills and expand their creative mindsets through questioning and reasoning data.'),
(94,'Software Engineering','This module covers the design artifacts and analysis techniques required to model, document and design complex software systems. Students will learn how to model system states and apply design patterns when developing software. Students will also learn design principles for maintainable and extensible software, as well as appropriate testing and deployment methodologies in relation to the best practices that the industry recommends. This module leverages on the core analysis and design skills acquired in Object Oriented Analysis & Design (OOAD) to introduce complex design artifacts and relevant methodologies, enabling the student to appreciate the design, deployment and management of complex software systems.'),
(95,'Spatial Theory & Level Design','This module introduces the fundamental spatial concepts and how to leverage on it to create spaces and flow for an immersive experience. It covers the design of environments and levels from the start at a conceptual beginning and arrives at a polished end to build multiple levels and engaging flow for the users in an immersive simulated environment for training and simulation.'),
(96,'Technopreneurship','The rapid emergence of new infocomm technologies is empowering new capabilities as well as opportunities for creativity and entrepreneurship. This module focuses on the processes and mechanisms by which new ideas and inventions can be commercialised in the market. Students will examine case studies of real- world examples of technopreneurship. They will also learn about the issues and challenges of transforming a technological innovation into a successful product or service in the market place'),
(97,'User Experience','This module focuses on the principles and techniques for designing good user experience in software applications and other products such as ATMs, kiosks, etc. Students will learn to apply business requirement gathering techniques as well as the analysis, design and validation phases of the user experience design life cycle, with emphasis on building empathy with users. They learn to communicate designs through deliverables such as personas, sitemaps and wireframes. Practical hands-on design activities will be guided by concepts such as information architecture, content strategy, formulation of user needs, and the application of design principles in interface, navigation, interaction and usability. The student will apply these concepts and techniques to design and prototype a web/ mobile application, and to present and critique design decisions.'),
(98,'Virtualisation & Data Centre Management','This module introduces the foundations of virtualisation, and creating and managing virtual machines for cost efficiency and agility in delivering IT services. Hands-on sessions are included to give students practical experience in virtualisation tools such as Windows Server and VMWare. It will also explore the impact of virtualisation technologies on cloud database development. The module will then proceed to provide an understanding of basic data centre design principles, and physical infrastructure, and a framework for managing a data centre using appropriate tools. Tools and methods for usage metering and billing in a cloud environment are also covered in this module.'),
(99,'Web Application Development','This module provides students with the knowledge and skills needed to develop web applications and web application protocol interface (API). Students will be introduced to an integrated development environment that will enable them to design and develop web applications and web API over the Internet. They will learn how to make use of web development technologies such as ASP.NET framework, jQuery for rich internet applications, data interchange formats such as JSON AJAX, source code version control systems such as GIT or SVN to develop effective web applications, and web API targeting both mobile web and unified web experience. This module aims to provide students with a good understanding of the web development architecture and service layer as well as the various issues related to Web Application Development.'),
(100,'Web Application Pen-Testing','This module provides a thorough understanding of major web application vulnerabilities and their potential impact on people and organisations. The module teaches a repeatable web pen-testing methodology, which includes reconnaissance, mapping, discovery, and exploitation of web application vulnerabilities and flaws. Students are taught how to write a web application pen-test report. The module teaches students the pen-tester’s perspective of web applications. It trains students on building a profile of the machines that host the target web application and come up with a map of the web application’s pages and features. Students are also trained in web application attack tools and interception proxies that are used to discover and exploit key web application vulnerabilities.'),
(101,'World Issues: A Singapore Perspective','This module develops a student’s ability to think critically on world issues. Students will discuss a wide range of social, political and cultural issues from the Singapore perspective. It also looks at how city-state Singapore defied the odds and witnessed close to half a century of rapid economic growth, strong political ties and social harmony.'),
(102,'Technologies for Financial Industry','') 
;

/*------ Project -------*/
INSERT INTO Project(project_id, project_name, project_desc, module_id) VALUES
(1, "Test Project", "Project Testing", 1);

/*------ ElectiveModule -------*/
INSERT INTO ElectiveModule(elective_id,module_id) VALUES
(1,36),(1,88),(1,89),(1,12),(1,46),(1,102),
(2,13),(2,26),(2,80),(2,86),
(3,42),(3,21),(3,92),(3,66),(3,97),
(4,13),(4,24),(4,26),(4,80),(4,86),
(5,16),(5,28),(5,30),(5,98),
(6,14),(6,21),(6,40),
(7,9),(7,54),(7,55),(7,56),(7,68),
(8,20),(8,60),(8,61),
(9,69),(9,70),(9,71),
(10,94),(10,23),(10,35),(10,89),
(13,101),(13,65),(13,15),
(14,37),(14,96);

/*------ CourseModule -------*/
INSERT INTO CourseModule(id, module_id, module_year) VALUES
/*------ Information Technology -------*/
(1, 18,'1'),(1, 22,'1'),(1, 41,'1'),(1, 51,'1'),(1, 83,'1'),(1, 25,'1'),(1, 49,'1'),(1, 77,'1'),(1, 78,'1'),(1, 84,'1'),(1, 52,'2'),(1, 76,'2'),(1, 99,'2'),(1, 50,'2'),(1, 53,'2'),
(1, 79,'2'),(1, 97,'2'),(1, 13,'Elective'),(1, 24,'Elective'),(1, 26,'Elective'),(1, 80,'Elective'),(1, 9,'Elective'),(1, 14,'Elective'),(1, 15,'Elective'),(1, 16,'Elective'),(1, 20,'Elective'),(1, 21,'Elective'),(1, 23,'Elective'),(1, 28,'Elective'),(1, 35,'Elective'),(1, 101,'3'),
(1, 40,'Elective'),(1, 54,'Elective'),(1, 55,'Elective'),(1, 56,'Elective'),(1, 60,'Elective'),(1, 61,'Elective'),(1, 65,'3'),(1, 68,'Elective'),(1, 69,'Elective'),(1, 70,'Elective'),(1, 71,'Elective'),(1, 86,'Elective'),(1, 89,'Elective'),(1, 96,'Elective'),(1, 98,'Elective'),(1, 37,'Elective'),
/*------ Financial Informatics -------*/
(2, 6,'1'),(2,15,'Elective'),(2,7,'3'),(2,10,'2'),(2,11,'3'),(2,12,'Elective'),(2,13,'Elective'),(2,17,'Elective'),(2,18,'1'),(2,21,'Elective'),(2,22,'1'),(2,24,'2'),(2,25,'1'),(2,26,'Elective'),(2,36,'Elective'),(2,38,'Elective'),(2,39,'2'),
(2,41,'1'),(2,42,'Elective'),(2,43,'2'),(2,46,'Elective'),(2,47,'Elective'),(2,48,'2'),(2,51,'1'),(2,52,'2'),(2,53,'3'),(2,62,'Elective'),(2,65,'3'),(2,66,'Elective'),(2,77,'1'),(2,78,'1'),(2,79,'2'),(2,80,'Elective'),(2,83,'1'),
(2,84,'1'),(2,85,'Elective'),(2,86,'Elective'),(2,88,'Elective'),(2,89,'Elective'),(2,92,'Elective'),(2,97,'Elective'),(2,99,'2'),(2,101,'3'),(2,102,'Elective'),
/*------ Immersive Media -------*/
(3,1,'Elective'),(3,2,'2'),(3,3,'2'),(3,4,'1'),(3,5,'Elective'),(3,8,'1'),(3,15,'3'),(3,18,'Elective'),(3,22,'1'),(3,27,'1'),(3,29,'2'),(3,31,'2'),(3,32,'Elective'),(3,34,'Elective'),(3,41,'1'),(3,45,'2'),(3,51,'1'),
(3,52,'2'),(3,53,'3'),(3,57,'1'),(3,59,'2'),(3,63,'2'),(3,64,'1'),(3,72,'Elective'),(3,81,'Elective'),(3,82,'1'),(3,83,'1'),(3,90,'Elective'),(3,93,'Elective'),(3,95,'2'),
/*------ Cybersecurity & Digital Forensics -------*/
(4,18,'1'),(4,19,'1'),(4,22,'1'),(4,23,'2'),(4,25,'1'),(4,33,'2'),(4,41,'1'),(4,44,'3'),(4,49,'1'),(4,51,'1'),(4,52,'2'),(4,53,'3'),(4,58,'Elective'),(4,67,'2'),(4,71,'Elective'),(4,73,'Elective'),(4,74,'3'),
(4,75,'2'),(4,77,'1'),(4,83,'1'),(4,84,'1'),(4,87,'2'),(4,89,'2'),(4,91,'2'),(4,99,'2'),(4,100,'2'),(4,101,'Elective'),(4,15,'Elective'),(4,65,'3'),
/*------ Common ICT Programme -------*/
(5,1,'Elective'),(5,2,'Elective'),(5,3,'Elective'),(5,4,'Elective'),(5,5,'Elective'),(5,6,'Elective'),(5,7,'Elective'),(5,8,'Elective'),(5,9,'Elective'),(5,10,'Elective'),(5,11,'Elective'),(5,12,'Elective'),(5,13,'Elective'),(5,14,'Elective'),(5,15,'Elective'),(5,16,'Elective'),(5,17,'Elective'),(5,18,'1'),
(5,19,'Elective'),(5,20,'Elective'),(5,21,'Elective'),(5,22,'1'),(5,23,'Elective'),(5,24,'Elective'),(5,25,'Elective'),(5,26,'Elective'),(5,27,'Elective'),(5,28,'Elective'),(5,29,'Elective'),(5,30,'Elective'),(5,31,'Elective'),(5,32,'Elective'),(5,33,'Elective'),(5,34,'Elective'),(5,35,'Elective'),(5,36,'Elective'),
(5,37,'Elective'),(5,38,'Elective'),(5,39,'Elective'),(5,40,'Elective'),(5,41,'1'),(5,42,'Elective'),(5,43,'Elective'),(5,44,'Elective'),(5,45,'Elective'),(5,46,'Elective'),(5,47,'Elective'),(5,48,'Elective'),(5,49,'Elective'),(5,50,'Elective'),(5,51,'1'),(5,52,'Elective'),(5,53,'Elective'),(5,54,'Elective'),
(5,55,'Elective'),(5,56,'Elective'),(5,57,'Elective'),(5,58,'Elective'),(5,59,'Elective'),(5,60,'Elective'),(5,61,'Elective'),(5,62,'Elective'),(5,63,'Elective'),(5,64,'Elective'),(5,65,'Elective'),(5,66,'Elective'),(5,67,'Elective'),(5,68,'Elective'),(5,69,'Elective'),(5,70,'Elective'),(5,71,'Elective'),(5,72,'Elective'),
(5,73,'Elective'),(5,74,'Elective'),(5,75,'Elective'),(5,76,'Elective'),(5,77,'Elective'),(5,78,'Elective'),(5,79,'Elective'),(5,80,'Elective'),(5,81,'Elective'),(5,82,'Elective'),(5,83,'1'),(5,84,'Elective'),(5,85,'Elective'),(5,86,'Elective'),(5,87,'Elective'),(5,88,'Elective'),(5,89,'Elective'),(5,90,'Elective'),
(5,91,'Elective'),(5,92,'Elective'),(5,93,'Elective'),(5,94,'Elective'),(5,95,'Elective'),(5,96,'Elective'),(5,97,'Elective'),(5,98,'Elective'),(5,99,'Elective'),(5,100,'Elective'),(5,101,'Elective')
;

/*------ Item (Courses) -------*/
INSERT INTO Item(item_id, item_path, item_type, course_id) VALUES
(1, 'assets/img/FI/BG_1.jpg', 'Image', '2'),
(2, 'assets/img/CIT/BG_1.jpg', 'Image', '5'),
(3, 'assets/img/IT/BG_1.jpg', 'Image', '1'),
(4, 'assets/img/IM/BG_1.jpg', 'Image', '3'),
(5, 'assets/img/CDF/BG_1.jpg', 'Image', '4'),
(6, 'assets/img/FI/BG_Card.png', 'Image', '2'),
(7, 'assets/img/CIT/BG_Card.png', 'Image', '5'),
(8, 'assets/img/IT/BG_Card.png', 'Image', '1'),
(9, 'assets/img/IM/BG_Card.png', 'Image', '3'),
(10, 'assets/img/CDF/BG_Card.png', 'Image', '4');



/*------ Item (Modules) -------*/
INSERT INTO Item(item_id, item_path, item_type, module_id) VALUES
(11,'assets/img/modules/3CC_icon.png','Image','1'),
(12,'assets/img/modules/3E_icon.png','Image','2'),
(13,'assets/img/modules/3R_icon.png','Image','3'),
(14,'assets/img/modules/3F_icon.png','Image','4'),
(15,'assets/img/modules/3P_icon.png','Image','5'),
(16,'assets/img/modules/Accounting_icon.png','Image','6'),
(17,'assets/img/modules/AA_icon.png','Image','7'),
(18,'assets/img/modules/AD_icon.png','Image','8'),
(19,'assets/img/modules/AIG_icon.png','Image','9'),
(20,'assets/img/modules/BFP_icon.png','Image','10'),
(21,'assets/img/modules/BAP_icon.png','Image','11'),
(22,'assets/img/modules/BTO_icon.png','Image','12'),
(23,'assets/img/modules/BD_icon.png','Image','13'),
(24,'assets/img/modules/BPMD_icon.png','Image','14'),
(25,'assets/img/modules/CP_icon.png','Image','15'),
(26,'assets/img/modules/CAT_icon.png','Image','16'),
(27,'assets/img/modules/CE_icon.png','Image','17'),
(28,'assets/img/modules/CM_icon.png','Image','18'),
(29,'assets/img/modules/Cryptography_icon.png','Image','19'),
(30,'assets/img/modules/CDMNS_icon.png','Image','20'),
(31,'assets/img/modules/CEM_icon.png','Image','21'),
(32,'assets/img/modules/CSF_icon.png','Image','22'),
(33,'assets/img/modules/DSA_icon.png','Image','23'),
(34,'assets/img/modules/DV_icon.png','Image','24'),
(35,'assets/img/modules/Databases_icon.png','Image','25'),
(36,'assets/img/modules/DA_icon.png','Image','26'),
(37,'assets/img/modules/DP_icon.png','Image','27'),
(38,'assets/img/modules/DMCD_icon.png','Image','28'),
(39,'assets/img/modules/DUX_icon.png','Image','29'),
(40,'assets/img/modules/DCA_icon.png','Image','30'),
(41,'assets/img/modules/DDA_icon.png','Image','31'),
(42,'assets/img/modules/DAD_icon.png','Image','32'),
(43,'assets/img/modules/DF_icon.png','Image','33'),
(44,'assets/img/modules/DVA_icon.png','Image','34'),
(45,'assets/img/modules/ECAD_icon.png','Image','35'),
(46,'assets/img/modules/Economics_icon.png','Image','36'),
(47,'assets/img/modules/ETI_icon.png','Image','37'),
(48,'assets/img/modules/ELE_icon.png','Image','38'),
(49,'assets/img/modules/EBP_icon.png','Image','39'),
(50,'assets/img/modules/EBS_icon.png','Image','40'),
(51,'assets/img/modules/EIS_icon.png','Image','41'),
(52,'assets/img/modules/ERP_icon.png','Image','42'),
(53,'assets/img/modules/ESDD_icon.png','Image','43'),
(54,'assets/img/modules/EH_icon.png','Image','44'),
(55,'assets/img/modules/ED_icon.png','Image','45'),
(56,'assets/img/modules/FAM_icon.png','Image','46'),
(57,'assets/img/modules/FE_icon.png','Image','47'),
(58,'assets/img/modules/FSE_icon.png','Image','48'),
(59,'assets/img/modules/FED_icon.png','Image','49'),
(60,'assets/img/modules/FSD_icon.png','Image','50'),
(61,'assets/img/modules/FIP1_icon.png','Image','51'),
(62,'assets/img/modules/FIP2_icon.png','Image','52'),
(63,'assets/img/modules/FIP3_icon.png','Image','53'),
(64,'assets/img/modules/GI_icon.png','Image','54'),
(65,'assets/img/modules/GP_icon.png','Image','55'),
(66,'assets/img/modules/GPP_icon.png','Image','56'),
(67,'assets/img/modules/GC_icon.png','Image','57'),
(68,'assets/img/modules/GDP_icon.png','Image','58'),
(69,'assets/img/modules/ITD_icon.png','Image','59'),
(70,'assets/img/modules/ISMS_icon.png','Image','60'),
(71,'assets/img/modules/ISLCM_icon.png','Image','61'),
(72,'assets/img/modules/IMP_icon.png','Image','62'),
(73,'assets/img/modules/I3E_icon.png','Image','63'),
(74,'assets/img/modules/ID_icon.png','Image','64'),
(75,'assets/img/modules/IP_icon.png','Image','65'),
(76,'assets/img/modules/IO_icon.png','Image','66'),
(77,'assets/img/modules/MATT_icon.png','Image','67'),
(78,'assets/img/modules/MG_icon.png','Image','68'),
(79,'assets/img/modules/MAD1_icon.png','Image','69'),
(80,'assets/img/modules/MAD2_icon.png','Image','70'),
(81,'assets/img/modules/MDSF_icon.png','Image','71'),
(82,'assets/img/modules/MGE_icon.png','Image','72'),
(83,'assets/img/modules/NF_icon.png','Image','73'),
(84,'assets/img/modules/NS_icon.png','Image','74'),
(85,'assets/img/modules/NI_icon.png','Image','75'),
(86,'assets/img/modules/OOAD_icon.png','Image','76'),
(87,'assets/img/modules/OSNF_icon.png','Image','77'),
(88,'assets/img/modules/P1_icon.png','Image','78'),
(89,'assets/img/modules/P2_icon.png','Image','79'),
(90,'assets/img/modules/PA_icon.png','Image','80'),
(91,'assets/img/modules/PMS_icon.png','Image','81'),
(92,'assets/img/modules/PM_icon.png','Image','82'),
(93,'assets/img/modules/PRG1_icon.png','Image','83'),
(94,'assets/img/modules/PRG2_icon.png','Image','84'),
(95,'assets/img/modules/PICD_icon.png','Image','85'),
(96,'assets/img/modules/QA_icon.png','Image','86'),
(97,'assets/img/modules/REM_icon.png','Image','87'),
(98,'assets/img/modules/RM_icon.png','Image','88'),
(99,'assets/img/modules/SSD_icon.png','Image','89'),
(100,'assets/img/modules/SGS_icon.png','Image','90'),
(101,'assets/img/modules/SCS_icon.png','Image','91'),
(102,'assets/img/modules/SM_icon.png','Image','92'),
(103,'assets/img/modules/SMB_icon.png','Image','93'),
(104,'assets/img/modules/SE_icon.png','Image','94'),
(105,'assets/img/modules/STLD_icon.png','Image','95'),
(106,'assets/img/modules/Technopreneurship_icon.png','Image','96'),
(107,'assets/img/modules/UE_icon.png','Image','97'),
(108,'assets/img/modules/VDCM_icon.png','Image','98'),
(109,'assets/img/modules/WAD_icon.png','Image','99'),
(110,'assets/img/modules/WAPT_icon.png','Image','100'),
(111,'assets/img/modules/WISP_icon.png','Image','101'),
(112,'assets/img/modules/TFI_icon.png','Image','102');

/*------ Item (Project) -------*/
INSERT INTO Item(item_id, item_path, item_type, Project_id) VALUES 
(113, '/', 'Image', 1);


/*------ Modules with Jobs-------*/
INSERT INTO ModuleJob(job_id, module_id) VALUES
/*------ Information Technology-------*/
(20,83), (20,49), (20,84), (20,99), (20,35), (20,54), (20,55), (20,56), (20,69), (20,70), (20,9),
(21,97), (21,49), 
(22,25), (22,13), (22,24), (22,23), (22,28), (22,98),
(23,20), (23,21), (23,60), (23,61),
(24,20), (24,21), (24,60), (24,61),
(25,20), (25,21), (25,60), (25,61),
(26,20), (26,21),
(27,25), (27,24), (27,26), (27,80), (27,28), (27,23), (27,98),
(28,25), (28,24), (28,26), (28,80), (28,28), (28,23), (28,98), (28,13),
(29,77), (29,16), 
(30,16), (30,28),
(31,83), (31,25), (31,78), (31,76), (31,99), (31,50), (31,79), (31,23), (31,69), (31,70), (31,89), (31,35), (31,99),
(32,77), (32,16), (32,98), (32,40), 
(33,18), (33,83), (33,84), (33,73), (33,99), (33,50), (33,79), (33,25), (33,14), (33,15), (33,23), (33,89), (33,37),
(34,18), (34,83), (34,49), (34,84), (34,76), (34,25), (34,99), (34,5), (34,79), (34,35), (34,69), (34,70), (34,89),
(35,77), 

/*------ Financial Information-------*/
(36, 77), (36, 41), (36, 39), (36, 43), (36, 42), (36, 12), (36, 92),
(37, 18), (37, 25), (37, 83), (37, 84), (37, 99), (37, 89),
(38, 77), (38, 88), (38, 41),
(39, 39), (39, 43), (39, 42),
(40, 12),
(41, 39),
(42, 25), (42, 7), (42, 26), (42, 46), (42, 80), (42, 86),
(43, 83), (43, 84), (43, 10), (43, 99), (43, 11),
(44, 83), (44, 84), (44, 99), (44, 89),
(45, 41), (45, 39), (45, 42),

/*------ Immersive Media-------*/
(11, 27), (11, 57), (11, 2), (11, 1), (11, 90), (11, 8), 
(12, 27), (12, 57), (12, 2), (12, 1), (12, 90), (12, 95), (12, 8),
(13, 27), (13, 57), (13, 2), (13, 1), (13, 90), (13, 8), (13, 63), 
(14, 8), (14, 27), (14, 64), (14, 29), (14, 72), 
(15, 8), (15, 27), (15, 29), 
(16, 93), (16, 32), (16, 34), (16, 72), (16, 2),
(17, 82), (17, 32), (17, 34),
(18, 29),
(19, 64), (19, 63),

/*------ Cybersecurity & Digital Forensics-------*/
(1, 77), (1, 75), (1, 74),
(2, 19), (2, 22), (2, 25), (2, 41), (2, 77), (2, 33), (2, 67), (2, 87), (2, 89), (2, 91), (2, 100), (2, 74), (2, 58), (2, 73),
(3, 19), (3, 22), (3, 77), (3, 33), (3, 67), (3, 75), (3, 87), (3, 89), (3, 91), (3, 100), (3, 44), (3, 74), (3, 58), (3, 73), (3, 73), 
(5, 19), (5, 22), (5, 77), (5, 33), (5, 67), (5, 75), (5, 87), (5, 89), (5, 91), (5, 100), (5, 44), (5, 74), (5, 58), (5, 71), (5, 73),
(6, 19), (6, 77), (6, 33), (6, 67), (6, 91), (6, 44), (6, 74), (6, 58), (6, 71), (6, 73),
(7, 19), (7,22), (7, 33), (7, 67), (7, 91), (7, 44), (7, 74), (7, 58), (7, 71), (7, 73),
(8, 18), (8, 25), (8, 49), (8, 83), (8, 84), (8, 89), (8, 99), 
(9, 19), (9, 25), (9, 44), (9, 99), (9, 100), (9, 77), (9, 33), (9, 75), (9, 89), (9, 91), (9, 74), (9, 73),
(10, 22), (10, 25), (10, 77), (10, 33), (10, 67), (10, 75), (10, 87), (10, 89), (10, 91), (10, 74), (10, 71), (10, 73),

/*------ Common ICT-------*/
(20, 83), (20, 49), (20, 84), (20, 99), (20, 35), (20, 45), (20, 55), (20, 56), (20, 69), (20, 70), (20, 9),
(41, 39),
(15, 8), (15, 27), (15, 29), 
(1, 77), (1, 75), (1, 74)
;
