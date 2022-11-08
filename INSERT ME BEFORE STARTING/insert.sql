-- add badge_photo to users table default nil longtext
ALTER TABLE users ADD COLUMN badge_photo MEDIUMTEXT DEFAULT NULL;
INSERT INTO items (name, label) VALUES ('pdbadge', 'PD Badge');