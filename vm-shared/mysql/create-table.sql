CREATE TABLE activity_trail (
	user_id BIGINT,
	target_url VARCHAR(5000)
);

CREATE TABLE mahout_preference (
	user_id BIGINT,
	item_id BIGINT,
	preference FLOAT
);