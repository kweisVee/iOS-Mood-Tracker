import express from 'express';
import mongoose from 'mongoose';
import session from 'express-session';
import { router } from "./Routes/routes.js";
// import { authentication } from './basicAuth.js';

const PORT = process.env.PORT || 3001;
const app = express();


app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`);
  });
app.use(express.json())
app.use(session({
    secret: 'secret',
    resave: true, 
    saveUninitialized: true
}));
app.use('/user', router);




mongoose.connect('mongodb+srv://chrissy_mood_tracker:V52pUw1dvBYbNtJf@cluster0.ljgglpy.mongodb.net/?retryWrites=true&w=majority', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log("Successfully connected to mongoDB")
}).catch(() => {
  console.log("Could not connect to the database. Will attempt to reconnect later...")
})

// // ENTRIES
// //TAGS
// app.get("/user/:userId/tags", async (req, res) => {
//     const id = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     // User.findById(id, (err, user) => {
//     //     if (err) {
//     //         res.status(500).send(err); 
//     //     } else {
//     //         res.status(200).send(user.tags)
//     //     }
//     // }).populate('tags');

//     User.aggregate([
//         {
//             $match: {
//                 $expr: {
//                     $eq: ['$_id', id]
//                 }
//             }
//         }, 
//         {
//             $lookup: {
//                 from: 'tags',
//                 localField: 'tags', 
//                 foreignField: '_id', 
//                 as: 'tag'
//             }
//         }, {
//             $unwind: "$tag"
//         }, {
//             $project: {tag: 1, _id: 0}
//         }
//     ], (err, list) => {
//         if (err) {
//             res.status(400).send(err);
//         } else {
//             res.status(200).send(list); 
//         }
//     });
// });

// app.post("/user/:userId/tags", jsonParser, async (req, res) => {
//     const userId = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     const tagSchema = new Tag(req.body);
//     try {
//         await tagSchema.save()
//         await User.updateOne({_id: userId}, {$push: {tags: tagSchema}})
//         res.status(201).send(tagSchema);
//     } catch (error) {
//         res.status(500).send(error);
//     }
// });

// app.get("/user/:userId/tags/:tagId", async (req, res) => {
//     const userId = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     const tagId = mongoose.Types.ObjectId(req.params.tagId.substring(1));
//     // User.findById(userId, (err, user) => {
//     //     if (err) {
//     //         res.status(500).send(err); 
//     //     } else {
//     //         res.status(200).send(user.tags)
//     //     }
//     // }).populate({
//     //     path: 'tags', 
//     //     match: { _id: tagId }
//     // });
//     User.aggregate([
//         {
//             $match: {
//                 $expr: {
//                     $eq: ['$_id', userId]
//                 }
//             }
//         }, 
//         {
//             $lookup: {
//                 from: 'tags',
//                 localField: 'tags', 
//                 foreignField: '_id', 
//                 as: 'tag'
//             }
//         }, {
//             $unwind: "$tag"
//         }, {
//             $project: {tag: 1, _id: 0}
//         }, {
//             $match: {
//                 $expr: {
//                     $eq: ['$tag._id', tagId]
//                 }
//             }
//         }
//     ], (err, tag) => {
//         if (err) {
//             res.status(400).send(err);
//         } else {
//             res.status(200).send(tag[0].tag); 
//         }
//     });
// });

// app.put("/user/:userId/tags/:tagId", jsonParser, async (req, res) => {
//     const userId = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     const tagId = mongoose.Types.ObjectId(req.params.tagId.substring(1));
//     const tagBody = req.body;
//     User.findById(userId, (err, user) => {
//         if (err) {
//             res.status(500).send(err); 
//         } else {
//             Tag.findByIdAndUpdate(tagId, tagBody, {
//                 upsert: true, 
//                 new: true
//             }, (err, tag) => {
//                 if (err) {
//                     res.status(500).send(err);
//                 } else {
//                     res.status(200).send(tag);
//                 }
//             });
//         }
//     })
// });

// app.delete("/user/:userId/tags/:tagId", async (req, res) => {
//     const userId = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     const tagId = mongoose.Types.ObjectId(req.params.tagId.substring(1));
//     User.findById(userId, (err, user) => {
//         Tag.deleteOne({_id: tagId}, (err, entry) => {
//             if (err) {
//                 res.status(500).send(err)
//             } else {
//                 res.status(200).send("Tag deleted");
//             }
//         })
//     })
// });

// // FOR ADDING OF TAGS
// app.put("/user/:userId/entries/:entryId/tags", jsonParser, async (req, res) => {
//     const userId = mongoose.Types.ObjectId(req.params.userId.substring(1));
//     const entryId = mongoose.Types.ObjectId(req.params.entryId.substring(1));
//     // const tagId = mongoose.Types.ObjectId(req.params.tagId.substring(1));
//     const tagArray = req.body.tags;
    
//     for (let index = 0; index < tagArray.length; index++) {
//         const element = tagArray[index];
//         Tag.findOne({ name: element, user: userId }, async (err, tag) => {
//             let tagSchema = tag
//             if (err) {
//                 res.status(500).send(err);
//             } else {
//                 if (!tagSchema) {
//                     tagSchema = new Tag({user: userId, name: element});
//                     tagSchema.save()
//                     console.log(tagSchema);
//                 }
//                 try {
//                     await User.updateOne({_id: userId}, {$push: {tags: tagSchema}})
//                     await Entry.updateOne({_id: entryId}, {$push: {tags: tagSchema}})
//                 } catch (error) {
//                     res.status(500).send(error);
//                 }
//             }
//         })   
//     }
//     res.status(200).send("Tags added");

//     // Entry.findById(entryId, (err, entry) => {
//     //     for (let i = 0; i < entry.tags.length; i++) {
//     //         if (!tagArray.includes(entry.tags[i].name)) {

//     //         }
//     //     }
//     // })
// });