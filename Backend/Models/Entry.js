import mongoose from 'mongoose';
// import { Tag } from './Tag';

const EntrySchema = new mongoose.Schema({ 
    dateCreated: {
        type: Number,
        immutable: true
    }, 
    time: {
        type: Date, 
        default: () => Date.now(),
        immutable: true
    },
    mood: {
        type: Number,
    }, 
    note: {
        type: String,
        maxLength: 250,
        minLength: 0
    }, 
    user: {
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User'
    },
    tags: [{
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Tag'
    }]
})

const Entry = mongoose.model("Entry", EntrySchema);
export { Entry }