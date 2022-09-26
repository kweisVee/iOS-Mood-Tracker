import mongoose from "mongoose";
import { Entry } from "../Models/Entry.js"
import { Tag } from "../Models/Tag.js"
import { User } from "../Models/User.js"
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';

const userCtrl = {
    login: (req, res) => {
        User.findOne({email: req.body.email}, (err, user) => {
            console.log("printing user");
            console.log(user);
            bcrypt.compare(req.body.password, user.password, function(err, result) {
                console.log("inside here");
                console.log(req.body.password);
                console.log(user.password);
                if (result) {
                    console.log("in result")
                    var token = jwt.sign( { userId: user._id}, 'asdfdf', {expiresIn: '365d'} )
                    res.status(200).json(token);
                } else {
                    res.status(500).send(err); 
                }
            })
        })
        .populate('entries')
        .populate('tags');
    },

    logout: (req, res) => {
        console.log("Logged out")
        req.session.destroy();
        res.status(200).json("User Logged Out")
    }, 

    getUser: (req, res) => {
        User.findById(req.session.userId, (err, user) => {
            if (err) {
                console.log(err)
                res.status(500).send(err); 
            } else {
                res.status(200).send(user)
            }
        })
        .populate('entries')
        .populate('tags');
    },

    postUser: async (req, res) => {
        bcrypt.hash(req.body.password, 10, async function(err, hash) {
            if (err) {
                res.status(500).send(err);
            } else {
                const userSchema = new User({
                    name: req.body.name,
                    email: req.body.email,
                    password: hash
                });
                try {
                    await userSchema.save()
                    console.log("user has registered")
                    console.log(userSchema)
                    var token = jwt.sign( { userId: userSchema._id}, 'asdfdf', {expiresIn: '365d'} )
                    // delete userSchema.password;
                    res.status(201).send(token);
                } catch (error) {
                    console.log("catch error")
                    console.log(error)
                    res.status(500).send(error);
                }
            }
        });
    },

    updateUser: (req, res) => {
        const userBody = req.body;
        User.findByIdAndUpdate(req.session.userId, userBody, {
            upsert: true, 
            new: true
        }, (err, user) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.status(200).send(user);
            }
        }).select("-password");
    }, 

    deleteUser: (req, res) => {
        User.deleteOne({_id: req.session.userId}, (err, user) => {
            if (err) {
                res.status(500).send(err)
            } else {
                console.log("printing user")
                console.log(user)
                Entry.deleteMany({user: req.session.userId}, (err, tag) => {
                    if (err) { res.status(500).send(err) }
                })
                Tag.deleteMany(
                    {_id: {$in: user.tags}}, (err, tags) => {
                        if (err) {res.status(500).send(err)}
                    }
                )
                res.status(200).send("User deleted");
            }
        });
    }
}

export { userCtrl }