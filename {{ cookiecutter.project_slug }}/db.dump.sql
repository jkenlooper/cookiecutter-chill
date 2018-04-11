PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Chill (
    version integer
);
CREATE TABLE Query (
    id integer primary key,
    name varchar(255) not null
);
INSERT INTO "Query" VALUES(1,'select_link_node_from_node.sql');
CREATE TABLE Template (
    id integer primary key,
    name varchar(255) unique not null
);
INSERT INTO "Template" VALUES(1,'homepage.html');
CREATE TABLE Node (
    id integer primary key,
    name varchar(255),
    value text,
    template integer,
    query integer,
    foreign key ( template ) references Template ( id ) on delete set null,
    foreign key ( query ) references Query ( id ) on delete set null
    );
INSERT INTO "Node" VALUES(1,'homepage',NULL,1,1);
INSERT INTO "Node" VALUES(2,'homepage_content','Cascading, Highly Irrelevant, Lost Llamas',NULL,NULL);
CREATE TABLE Node_Node (
    node_id integer,
    target_node_id integer,
    foreign key ( node_id ) references Node ( id ) on delete cascade,
    foreign key ( target_node_id ) references Node ( id ) on delete cascade
);
INSERT INTO "Node_Node" VALUES(1,2);
CREATE TABLE Route (
    id integer primary key,
    path text not null,
    node_id integer,
    weight integer default 0,
    method varchar(10) default 'GET',
    foreign key ( node_id ) references Node ( id ) on delete set null
);
INSERT INTO "Route" VALUES(1,'/',1,NULL,'GET');
COMMIT;
