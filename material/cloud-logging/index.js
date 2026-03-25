const functions = require('@google-cloud/functions-framework');

// Register an HTTP function with the Functions Framework that will be executed
// when you make an HTTP request to the deployed function's endpoint.
functions.http('helloGET', (req, res) => {
    console.log('Passed in message: ' + req.query.message);
    res.send('Hello World! Message was ' + req.query.message);
});
