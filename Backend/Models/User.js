import mongoose from 'mongoose';
// import { Entry } from './Entry';

const UserSchema = new mongoose.Schema({
    name: {
        type: String, 
        maxLength: 100,
        minLength: 2
    },
    email: {
        type: String,
        maxLength: 100,
        minLength: 4,
        required: true,
    },
    password: {
        type: String,
        required: true,
        minLength: 7
    }, 
    entries: [{
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Entry'
    }], 
    tags: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Tag'
    }]
});

const User = mongoose.model("User", UserSchema);

export { User }