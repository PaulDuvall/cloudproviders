const aws = require('aws-sdk');
const codedeploy = new aws.CodeDeploy();
const lambda = new aws.Lambda();

exports.lambdaHandler = (event, context, callback) => {

  let status = 'Failed';

  console.log("Entering PreTraffic.js Hook!");
  console.log(JSON.stringify(event));

  //Read the DeploymentId from the event payload.
  let deploymentId = event.DeploymentId;
  console.log("deploymentId=" + deploymentId);

  //Read the LifecycleEventHookExecutionId from the event payload
  let lifecycleEventHookExecutionId = event.LifecycleEventHookExecutionId;
  console.log("lifecycleEventHookExecutionId=" + lifecycleEventHookExecutionId);


    var functionToTest = process.env.CurrentVersion;
    console.log("Testing new function version: " + functionToTest);

    // Perform validation of the newly deployed Lambda version
    var lambdaParams = {
        FunctionName: functionToTest,
        InvocationType: "RequestResponse"
    };

    var lambdaResult = "Failed";
    lambda.invoke(lambdaParams, function (err, data) {
        if (err) {	// an error occurred
            console.log(err, err.stack);
            lambdaResult = "Failed";
        }
        else {	// successful response
            var result = JSON.parse(data.Payload);
            console.log("Result: " + JSON.stringify(result));

            if (result.statusCode != 500) {
                lambdaResult = "Succeeded";
                console.log("Validation testing succeeded!");
            }
            else {
                lambdaResult = "Failed";
                console.log("Validation testing failed!");
            }

            // Complete the PreTraffic Hook by sending CodeDeploy the validation status
            var params = {
                deploymentId: deploymentId,
                lifecycleEventHookExecutionId: lifecycleEventHookExecutionId,
                status: lambdaResult // status can be 'Succeeded' or 'Failed'
            };

            // Pass AWS CodeDeploy the prepared validation test results.
            codedeploy.putLifecycleEventHookExecutionStatus(params, function (err, data) {
                if (err) {
                    // Validation failed.
                    console.log('CodeDeploy Status update failed');
                    console.log(err, err.stack);
                    callback("CodeDeploy Status update failed");
                } else {
                    // Validation succeeded.
                    console.log('Codedeploy status updated successfully');
                    callback(null, 'Codedeploy status updated successfully');
                }
            });
        }
    });
}