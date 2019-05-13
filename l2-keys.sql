create table topics
(
topic_id NUMBER primary key,
course_id NUMBER,
description VARCHAR2(500),

CONSTRAINT kf_topic
  FOREIGN KEY (topic_id)
  REFERENCES xx_course (course_id)
  );