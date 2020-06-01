console.log('Put data into DynamoDB table')

const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient({region: 'us-east-1'})

exports.handler = function(event, context, callback){
    console.log('processing event: ' + JSON.stringify(event, null, 2))

    let currentMonth = new Date().getMonth() + 1 
    let currentYear = new Date().getFullYear()

    let params =  {
        Item: {
            Date: Date.now(),
            CloudProvider: event.cloudprovider ? event.cloudprovider : "Anonymous",
            ServiceName: event.servicename,
            id: event.id,
            URL: event.url,
            MonthAttribute: currentMonth,
            YearAttribute: currentYear,
            YearMonthAttribute: currentYear + "-" + currentMonth
        },

        TableName: 'CloudProviders'
    };

    docClient.put(params, function(err,data){
        if(err) {
            callback(err, null)
        }else{
            callback(null, data)
        }
    });

}