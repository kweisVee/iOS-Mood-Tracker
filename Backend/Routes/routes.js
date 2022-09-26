import express from 'express'
const router = express()
import { userCtrl } from '../Controllers/UserCtrl.js'
import { entryCtrl } from '../Controllers/EntryCtrl.js'
import { tagCtrl } from '../Controllers/TagCtrl.js'
import { authentication } from '../basicAuth.js'

router.post('/login', userCtrl.login);
router.get('/logout', authentication, userCtrl.logout);
router.post("", userCtrl.postUser);
router.get("", authentication, userCtrl.getUser);
router.put("", authentication, userCtrl.updateUser);
router.delete("", authentication, userCtrl.deleteUser);

router.get('/entries', authentication, entryCtrl.getEntries);
router.post('/entries', authentication, entryCtrl.postEntry);
router.get('/entries/filter', authentication, entryCtrl.getFilterEntries);
router.get('/entries/:entryId', authentication, entryCtrl.getEntry);
router.put('/entries/:entryId', authentication, entryCtrl.updateEntry);
router.delete('/entries/:entryId', authentication, entryCtrl.deleteEntry);

router.get('/tags', authentication, tagCtrl.getTags);
router.post('/entries/:entryId/tags', authentication, tagCtrl.addTags);
router.put('/entries/:entryId/tags', authentication, tagCtrl.updateTags);
router.get('/tags/recent', authentication, tagCtrl.getRecentTags);


export { router }