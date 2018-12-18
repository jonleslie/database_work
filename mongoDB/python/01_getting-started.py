from pymongo import MongoClient

client = MongoClient("mongodb://jleslie17:stringer01!@cluster0-shard-00-00-n0cyn.mongodb.net:27017,cluster0-shard-00-01-n0cyn.mongodb.net:27017,cluster0-shard-00-02-n0cyn.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin")
db = client.test

db.inventory.insert_many([
   # MongoDB adds the _id field with an ObjectId if _id is not present
   { "item": "journal", "qty": 25, "status": "A",
       "size": { "h": 14, "w": 21, "uom": "cm" }, "tags": [ "blank", "red" ] },
   { "item": "notebook", "qty": 50, "status": "A",
       "size": { "h": 8.5, "w": 11, "uom": "in" }, "tags": [ "red", "blank" ] },
   { "item": "paper", "qty": 100, "status": "D",
       "size": { "h": 8.5, "w": 11, "uom": "in" }, "tags": [ "red", "blank", "plain" ] },
   { "item": "planner", "qty": 75, "status": "D",
       "size": { "h": 22.85, "w": 30, "uom": "cm" }, "tags": [ "blank", "red" ] },
   { "item": "postcard", "qty": 45, "status": "A",
       "size": { "h": 10, "w": 15.25, "uom": "cm" }, "tags": [ "blue" ] }
])

cursor = db.inventory.find({})


# client = MongoClient("mongodb://user123:p455w0rd@gettingstarted-shard-00-00-hyjsm.mongodb.net:27017,gettingstarted-shard-00-01-hyjsm.mongodb.net:27017,gettingstarted-shard-00-02-hyjsm.mongodb.net:27017/test?ssl=true&replicaSet=GettingStarted-shard-0&authSource=admin")
# db = client.test



# Paste the following examples here

cursor = db.inventory.find({"status": "D"})

print(cursor)