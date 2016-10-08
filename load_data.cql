LOAD CSV WITH HEADERS FROM "file:///people.csv" AS line WITH line
CREATE (:PERSON {
personId:toInt(line.id),
name:line.name,
house:line.house,
born:toInt(line.born),
died:toInt(line.died),
gender:line.gender
});

CREATE INDEX ON :PERSON(personId)

// Note that marriages may have an explicit end date. If they don't, calculate based off of the first death in the marriage
LOAD CSV WITH HEADERS FROM "file:///marriages.csv" AS line WITH line
MATCH (husband:PERSON {personId:toInt(line.husband_id)})
MATCH (wife:PERSON {personId:toInt(line.wife_id)})
MERGE (husband)-[:MARRIED {start_date:line.start_date}]->(wife);

LOAD CSV WITH HEADERS FROM "file:///parents.csv" AS line WITH line
MATCH (child:PERSON {personId:toInt(line.child_id)})
MATCH (parent:PERSON {personId:toInt(line.parent_id)})
MERGE (parent)-[pu:PARENT_OF]->(child)
