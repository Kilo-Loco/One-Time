var aws = require("aws-sdk");
var ses = new aws.SES({ region: "us-east-1" }); // This is you SES region
const digitGenerator = require('crypto-secure-random-digit');

function sendChallengeCode(emailAddress, secretCode) {
 var params = {
    Destination: {
      ToAddresses: [emailAddress],
    },
    Message: {
      Body: {
        Text: { Data: secretCode },
      },
       Subject: { Data: "Email Verification Code" },
    },
    Source: "ifro555@hotmail.com", // This is you SES Identity Email 
  };
 
 
  return ses.sendEmail(params).promise()
}


exports.handler = async function (event) {
  
    if (event.request.challengeName === 'CUSTOM_CHALLENGE') {
    
      // Generate a random code for the custom challenge
      const challengeCode = digitGenerator.randomDigits(6).join('');
      
      event.response.privateChallengeParameters = {};
      event.response.privateChallengeParameters.answer = challengeCode;
      
      event.response.publicChallengeParameters = {};
      event.response.publicChallengeParameters['fieldTitle'] = 'Enter the secert';
      event.response.publicChallengeParameters['fieldHint'] = 'Check your email';
      
   return  sendChallengeCode(event.request.userAttributes.email, challengeCode);

  }      
};
