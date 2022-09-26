import mongoose from "mongoose";
import { Entry } from "../Models/Entry.js"
import { Tag } from "../Models/Tag.js"
import { User } from "../Models/User.js"

const tagCtrl = {
    getTags: (req, res) => {
        User.aggregate([
            {$match: {
                $expr : {
                    $eq: [`$_id`, { $toObjectId: req.session.userId }]
                }
            }}, {
                $lookup: {
                    localField: 'tags',
                    from: 'tags', 
                    foreignField: '_id', 
                    as: 'tag'
                }
            }, {$unwind: "$tag"},
            {$project: {
                name: "$tag.name"
            }}, {$group: {
                _id: "$name"
            }}
        ], (err, tags) => {
            console.log(tags);
            res.status(200).send(tags)
        })
    },

    addTags: (req, res) => {
        const entryId = mongoose.Types.ObjectId(req.params.entryId);
        console.log("In adding tags")
        Tag.insertMany(req.body, (err, tags) => {
            if (err) {
                res.status(500).send(err)
            } else {
                console.log("printing of tags ID array")
                let idArr = tags.map(tag => { return tag._id })
                console.log(idArr)
                User.findByIdAndUpdate(req.session.userId, 
                    {$push: {
                        tags: {$each: idArr}
                    }}, (err, user) => {
                        if (err) {res.status(500).send(err)}
                    })
                Entry.findByIdAndUpdate(entryId, 
                    {"tags": idArr}, 
                    {new: true}, (err, user) => {
                        if (err) {res.status(500).send(err)}
                    })
                res.status(200).send("Tags Added")
            }
        })
    }, 

    updateTags: (req, res) => {
        const entryId = mongoose.Types.ObjectId(req.params.entryId);
        console.log("IN UPDATE TAGS")
        Entry.findById(entryId, (err, entry) => {
            if (err) { 
                res.status(500).send(err);
            } else {
                // store the tags of the entry
                let entryTags = entry.tags
                // delete the tags in the entry
                Tag.deleteMany(
                    {_id : {$in: entry.tags}}, (err, deletedTags) => {
                        if (err) { res.status(500).send(err) }
                        else {
                            // find usersand delete all the tags it owns that includes the entry tags
                            User.findByIdAndUpdate(req.session.userId, {
                                $pullAll: { tags: entryTags }
                            }, (err, user) => {
                                if (err) { res.status(500).send(err) }
                            })
                        }
                    }
                )
                // insert the new set of tags
                Tag.insertMany(req.body, (err, tags) => {
                    if (err) {
                        res.status(500).send(err)
                    } else {
                        console.log("printing of tags ID array in put tags")
                        let idArr = tags.map(tag => { return tag._id })
                        console.log(idArr)
                        User.findByIdAndUpdate(req.session.userId, 
                            {$push: {
                                tags: {$each: idArr}
                            }}, (err, user) => {
                                if (err) {res.status(500).send(err)}
                            })
                        Entry.findByIdAndUpdate(entryId, 
                            {"tags": idArr}, 
                            {new: true}, (err, user) => {
                                if (err) {res.status(500).send(err)}
                            })
                        res.status(200).send("Tags Updated")
                    }
                })
            }
        })
    },

    getRecentTags: (req, res) => {
        console.log("in get recent tags")
        // User.findById(req.session.userId, (err, user) => {
        //     if (err) {
        //         res.status(500).send(err); 
        //     } else {
        //         console.log(user.tags)
        //         res.status(200).send(user.tags)
        //     }
        // }).populate({
        //     path: 'tags', 
        //     options: {sort: {date: -1}, 
        //     limit: 6}
        // })
        User.aggregate([
            {$match: {
                $expr : {
                    $eq: [`$_id`, { $toObjectId: req.session.userId }]
                }
            }}, {
                $lookup: {
                    localField: 'tags',
                    from: 'tags', 
                    foreignField: '_id', 
                    as: 'tag'
                }
            }, {$unwind: "$tag"},
            {$project: {
                name: "$tag.name", 
                date: "$tag.date"
            }}, {
                $sort: {date: -1}
            }, 
            {$group:
                // {_id: {name: "$name", date: "$date"}}
                {_id: "$name"}
            }, {$limit: 6}
        ], (err, tags) => {
            console.log(tags);
            res.status(200).send(tags)
        })
    }
}

export { tagCtrl }