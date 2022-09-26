import mongoose from 'mongoose';

const TagSchema = new mongoose.Schema({
    name: {
        type: String,
        minlength: 2, 
        maxlength: 20
    }, 
    date: {
        type: Number
    },
    mood: {
        type: Number
    },
    user: {
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User'
    }
}); 

const Tag = mongoose.model("Tag", TagSchema); 
export { Tag }