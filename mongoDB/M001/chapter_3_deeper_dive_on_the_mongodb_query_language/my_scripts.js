db.shipwrecks.find({$or: [{watlev: {$eq: "always dry"}},
{depth: {$eq: 0}}]}).count()

db.data.find({sections: {$all: ["AG1", "MD1", "OA1"]}}).count()

// # Challenge problem
db.scores.find({}, {results: 1}).pretty()
db.scores.find({results: {$elemMatch: {$gte: 70, $lt: 80}}}).count()

// Final exam
// Question 4
db.trips.find(
    {$and: [
        {tripduration: null},
        {tripduration: {$exists: true}}
 ]
   }
).count()

// Quesiton 5
db.movieDetails.find({year: 1964}, 
{title: 1, _id: 0})

// Question 6
db.movies.find(
    {$and: [
        {cast: {$in: [
            "Jack Nicholson",
            "John Huston"
        ]}},
        {viewerRating: {$gt: 7}},
        {mpaaRating: "R"}
    ]}
).count()