-- Spring security
ALTER TABLE Users ADD security varchar(128) default '';
ALTER TABLE Users ADD authtype varchar(32);
ALTER TABLE Users ALTER COLUMN password varchar(120) not null;

-- Support multiple profiles per user
ALTER TABLE UserGroups ADD profile varchar(32);
UPDATE UserGroups SET profile = (SELECT profile from users WHERE id = userid);
UPDATE UserGroups SET profile = 'RegisteredUser' WHERE profile IS null;

ALTER TABLE UserGroups ALTER COLUMN profile varchar(32) NOT NULL;

ALTER TABLE UserGroups DROP PRIMARY KEY;
ALTER TABLE UserGroups ADD PRIMARY KEY (userid, profile, groupid);

ALTER TABLE Metadata ALTER COLUMN harvestUri varchar(512);

ALTER TABLE HarvestHistory ADD elapsedTime int;

CREATE TABLE Services
  (
  
    id         int,
    name       varchar(64)   not null,
    class       varchar(1048)   not null,
    description       varchar(1048),
        
    primary key(id)
  );
  

CREATE TABLE ServiceParameters
  (
    id         int,
    service     int,
    name       varchar(64)   not null,
    value       varchar(1048)   not null,
    
    primary key(id)
  );


ALTER TABLE ServiceParameters ADD FOREIGN KEY (service) REFERENCES services (id);
