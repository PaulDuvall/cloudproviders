console.log('Gets data from DynamoDB table')

const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient({region: process.env.REGION});

exports.handler = function(event, context, callback){
    let StatusCode=false;
    console.log('processing event: %j', event);

    let scanningParameters = {
        TableName: process.env.TABLE_NAME,
        Limit: 100 //maximum result of 100 items
    };

    //In dynamoDB scan looks through your entire table and fetches all data
    docClient.scan(scanningParameters, function(err,data){
        if(err){
            callback(err, null);
        }else{
            StatusCode=(true);
            callback(null,data);
        }
    });
}