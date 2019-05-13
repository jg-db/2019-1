create table xx_course
(
 course_id NUMBER primary key, 
 course_name VARCHAR2(200),
 start_date DATE
);

create table xx_topics
(
topic_id NUMBER primary key,
course_id NUMBER,
description VARCHAR2(500),

CONSTRAINT kf_topic
  FOREIGN KEY (topic_id)
  REFERENCES xx_course (course_id)
);

insert into xx_topics values (1,1,'test');
