import jwt from 'jsonwebtoken';
// global.tokens = {}

const authentication = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    try {
        var decode = jwt.verify(authHeader, 'asdfdf');
        req.session.userId = decode.userId;
        next()
    } catch(err) {
        res.status(400).send(err.message);
    }
    // if (global.tokens[authHeader] && new Date().getTime() < global.tokens[authHeader]) {
    //     next()
    // } else {
    //     res.status(400).send("Not Authenticated")
    //     // var auth = new Buffer.from(authHeader.split(' ')[1],
    //     // 'base64').toString().split(':')
    //     // var user = auth[0]
    //     // var password = auth[1]
    // }
}

export { authentication } 