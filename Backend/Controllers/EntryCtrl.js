import mongoose from "mongoose";
import { Entry } from "../Models/Entry.js"
import { Tag } from "../Models/Tag.js"
import { User } from "../Models/User.js"

const entryCtrl = {
    getEntries: (req, res) => {
        var userId = req.session.userId;
        User.findById(userId, (err, user) => {
            if (err) {
                res.status(500).send(err); 
            } else {
                res.status(200).json(user.entries);
            }
        }).populate({
            path: 'entries',
            populate: {
                path: 'tags', 
                model: Tag
            }
        });
    },

    getEntry: (req, res) => {
        const entryId = mongoose.Types.ObjectId(req.params.entryId);
        User.findById(req.session.userId, (err, user) => {
            if (err) {
                res.status(500).send(err); 
            } else {
                res.status(200).send(user.entries)
            }
        }).populate({
            path: 'entries', 
            match: { _id: entryId }
        }).populate('entries.tags');
    },

    getFilterEntries: (req, res) => {
        let start = req.query.startDate
        let end = req.query.endDate
        console.log(start)
        console.log(end)
        console.log("IN FILTERING ENTRIES")
        User.findById(req.session.userId, (err, user) => {
            if (err) {
                res.status(500).send(err);
            } else {
                console.log(user.entries);
                res.status(200).send(user.entries)
            }
        }).populate(
            {
            path: 'entries', 
            populate: { path: 'tags' }, 
            match: { 'dateCreated': {
                    $gte: parseInt(start),
                    // $gte: 0,
                    $lt: parseInt(end)
                }   
            }, 
            options: {
                sort: {
                    dateCreated: -1
                }
            }    
        })
    },

    getInsightsEntries: (req, res) => {
        let start = req.query.startDate
        let end = req.query.endDate
        console.log(start)
        console.log(end)
        console.log("IN FILTERING ENTRIES")
        User.findById(req.session.userId, (err, user) => {
            if (err) {
                res.status(500).send(err);
            } else {
                console.log(user.entries);
                res.status(200).send(user.entries)
            }
        }).populate(
            {
            path: 'entries', 
            populate: { path: 'tags' }, 
            match: { 'dateCreated': {
                    $gte: parseInt(start),
                    // $gte: 0,
                    $lt: parseInt(end)
                }   
            }, 
            options: {
                sort: {
                    dateCreated: -1
                }
            }    
        })
    },

    postEntry: async (req, res) => {
        let entry = req.body;
        const entrySchema = new Entry({
            user: req.session.userId, 
            dateCreated: entry.dateCreated, 
            time: entry.time,
            mood: entry.mood, 
            note: entry.note, 
            tags: []
        })

        try {
            await entrySchema.save()
            console.log(entrySchema)
            await User.updateOne({_id: req.session.userId}, {$push: {entries: entrySchema}})
            res.status(200).json(entrySchema);
        } catch (error) {
            res.status(500).send(error);
        }
    },
    
    updateEntry: (req, res) => {
        console.log(req.body);
        console.log("INSIDE UPDATE ENTRY")
        // const entryId = mongoose.Types.ObjectId(req.params.entryId.substring(1));
        const entryBody = req.body;
        User.findById(req.session.userId, (err, user) => {
            if (err) {
                res.status(500).send(err); 
            } else {
                Entry.findByIdAndUpdate(entryBody.id, {
                    dateCreated: entryBody.dateCreated,
                    time: entryBody.time,
                    mood: entryBody.mood,
                    note: entryBody.note
                }, {
                    upsert: true, 
                    new: true
                }, (err, entry) => {
                    if (err) {
                        res.status(500).send(err);
                    } else {
                        console.log("updated");
                        entry.tags = [];
                        console.log(entry);
                        res.status(200).json(entry);
                    }
                });
            }
        }).populate({
            path: 'entries',
            populate: {
                path: 'tags', 
                model: Tag
            }
        });
    }, 

    deleteEntry: (req, res) => {
        const entryId = mongoose.Types.ObjectId(req.params.entryId.substring(1));
        
        User.findByIdAndUpdate(req.session.userId, {
                $pull: { "entries": entryId }
            }, (err, user) => {
                if (err) { res.status(500).send(err) }
                else {
                    Entry.deleteOne({_id: entryId}, (err, entry) => {
                        if (err) {
                            res.status(500).send(err)
                        } else {
                            res.status(200).send("Entry deleted");
                        }
                    })
                }
            }
        )
    }
}

export { entryCtrl }